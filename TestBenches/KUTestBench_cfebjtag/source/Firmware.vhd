library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

-- To mimic the behavior of ODMB_VME on the component CFEBJTAG

-- library UNISIM;
-- use UNISIM.VComponents.all;

use work.Firmware_pkg.all;     -- for switch between sim and synthesis

entity Firmware is
  PORT (
    -- Clock
    CLK160      : in std_logic;  -- For dcfeb prbs (160MHz)
    CLK80       : in std_logic;  -- For vme master (80MHz)
    CLK40       : in std_logic;  -- NEW (fastclk -> 40MHz)
    CLK10       : in std_logic;  -- NEW (midclk -> fastclk/4 -> 10MHz)
    -- VME signals <-- relevant ones only
    VME_DATA_IN    : in std_logic_vector (15 downto 0);  -- data(15 downto 0)
    -- JTAG Signals To/From DCFEBs
    DL_JTAG_TCK    : out std_logic_vector (6 downto 0);
    DL_JTAG_TMS    : out std_logic;
    DL_JTAG_TDI    : out std_logic;
    DL_JTAG_TDO    : in  std_logic_vector (6 downto 0);
    DCFEB_INITJTAG : in  std_logic;
    -- User input
    CMDDEV      : in std_logic_vector (15 downto 0);
    -- Reset
    RST         : in std_logic
    );
end Firmware;

architecture Behavioral of Firmware is
  -- Constants
  constant bw_data  : integer := 16;
  constant NCFEB    : integer := 7;

  component CFEBJTAG is
    port (
      -- CSP_LVMB_LA_CTRL : inout std_logic_vector(35 downto 0);

      FASTCLK   : in std_logic;  -- fastclk -> 40 MHz
      SLOWCLK   : in std_logic;  -- midclk  -> 10 MHz
      RST       : in std_logic;
      DEVICE    : in std_logic;
      STROBE    : in std_logic;
      COMMAND   : in std_logic_vector(9 downto 0);
      WRITER    : in std_logic;
      INDATA    : in std_logic_vector(15 downto 0);
      OUTDATA   : inout std_logic_vector(15 downto 0);
      DTACK     : out std_logic;
      INITJTAGS : in  std_logic;
      TCK       : out std_logic_vector(NCFEB downto 1);
      TDI       : out std_logic;
      TMS       : out std_logic;
      FEBTDO    : in  std_logic_vector(NCFEB downto 1);
      DIAGOUT   : out std_logic_vector(17 downto 0);
      LED       : out std_logic
      );
  end component;

  component command_module is
    port (
      FASTCLK : in std_logic;
      SLOWCLK : in std_logic;

      GA      : in std_logic_vector(5 downto 0);
      ADR     : in std_logic_vector(23 downto 1);
      AM      : in std_logic_vector(5 downto 0);

      AS      : in std_logic;
      DS0     : in std_logic;
      DS1     : in std_logic;
      LWORD   : in std_logic;
      WRITER  : in std_logic;
      IACK    : in std_logic;
      BERR    : in std_logic;
      SYSFAIL : in std_logic;

      DEVICE  : out std_logic_vector(9 downto 0);
      STROBE  : out std_logic;
      COMMAND : out std_logic_vector(9 downto 0);
      ADRS    : out std_logic_vector(17 downto 2);

      TOVME_B : out std_logic;
      DOE_B   : out std_logic;

      DIAGOUT : out std_logic_vector(19 downto 0);
      LED     : out std_logic_vector(2 downto 0)
      );
  end component;

  component vme_master is

    port (
      CLK         : in  std_logic;
      RSTN        : in  std_logic;
      SW_RESET    : in  std_logic;
      VME_CMD     : in  std_logic;
      VME_CMD_RD  : out std_logic;
      VME_ADDR    : in  std_logic_vector(23 downto 1);
      VME_WR      : in  std_logic;
      VME_WR_DATA : in  std_logic_vector(15 downto 0);
      VME_RD      : in  std_logic;
      VME_RD_DATA : out std_logic_vector(15 downto 0);
      GA          : out std_logic_vector(5 downto 0);
      ADDR        : out std_logic_vector(23 downto 1);
      AM          : out std_logic_vector(5 downto 0);
      AS          : out std_logic;
      DS0         : out std_logic;
      DS1         : out std_logic;
      LWORD       : out std_logic;
      WRITE_B     : out std_logic;
      IACK        : out std_logic;
      BERR        : out std_logic;
      SYSFAIL     : out std_logic;
      DTACK       : in  std_logic;
      DATA_IN     : in  std_logic_vector(15 downto 0);
      DATA_OUT    : out std_logic_vector(15 downto 0);
      OE_B        : out std_logic
      );

  end component;
  signal device    : std_logic_vector(9 downto 0) := (others => '0');
  signal cmd       : std_logic_vector(9 downto 0) := (others => '0');
  signal strobe    : std_logic := '0';
  signal tovme_b, doe_b : std_logic := '0';

  signal dtack_dev : std_logic_vector(9 downto 0) := (others => '0');

  signal diagout_cfebjtag : std_logic_vector(17 downto 0) := (others => '0');
  signal led_cfebjtag     : std_logic := '0';
  signal diagout_command  : std_logic_vector(19 downto 0) := (others => '0');
  signal led_command      : std_logic_vector(2 downto 0)  := (others => '0');


  signal dl_jtag_tck_inner : std_logic_vector(6 downto 0);
  signal dl_jtag_tdi_inner, dl_jtag_tms_inner : std_logic;

  -- New, used in place of the array
  signal devout : std_logic_vector(bw_data-1 downto 0) := (others => '0');
  -- New, to test  of the array
  signal dcfeb_initjtag_i : std_logic := '0';

  -- New, to generate strobe
  signal strobe_temp1 : std_logic := '0';
  signal strobe_temp2 : std_logic := '0';
  signal asynstrb     : std_logic := '0';
  signal asynstrb_not : std_logic := '0';

  signal cmd_adrs_inner : std_logic_vector(17 downto 2);

  -- signals between test_controller and vme_master_fsm and command_module
  signal vme_cmd     : std_logic;
  signal vme_cmd_rd  : std_logic;
  signal vme_addr    : std_logic_vector(23 downto 1);
  signal vme_wr      : std_logic;
  signal vme_wr_data : std_logic_vector(15 downto 0);
  signal vme_rd      : std_logic;
  signal vme_rd_data : std_logic_vector(15 downto 0);
  signal vme_data    : std_logic_vector(15 downto 0);
  -- signals between vme_master_fsm and command_module
  signal vme_berr    : std_logic;
  signal vme_as      : std_logic;
  signal vme_ds      : std_logic_vector(1 downto 0);
  signal vme_lword   : std_logic;
  signal vme_write_b : std_logic;
  signal vme_iack    : std_logic;
  signal vme_sysfail : std_logic;
  signal vme_am      : std_logic_vector(5 downto 0);
  signal vme_ga      : std_logic_vector(5 downto 0);
  signal vme_adr     : std_logic_vector(23 downto 1);
  signal vme_oe_b    : std_logic;
  -- signals between vme_master_fsm and cfebjtag and lvdbmon modules
  signal vme_dtack   : std_logic;
  signal vme_indata  : std_logic_vector(15 downto 0);
  signal vme_outdata : std_logic_vector(15 downto 0);

  -- signals for vme_master
  signal rstn : std_logic := '1';

begin

  -- device(1) <= '1' when CMDDEV(15 downto 12) = x"1" else '0';
  -- cmd <= CMDDEV(11 downto 2);

  dcfeb_initjtag_i <= DCFEB_INITJTAG;

  DL_JTAG_TCK <= dl_jtag_tck_inner;
  DL_JTAG_TDI <= dl_jtag_tdi_inner;
  DL_JTAG_TMS <= dl_jtag_tms_inner;

  DEV1_CFEBJTAG : CFEBJTAG
    port map (
      -- CSP_LVMB_LA_CTRL => CSP_LVMB_LA_CTRL,
      FASTCLK => clk40,
      SLOWCLK => clk10,
      RST     => rst,

      DEVICE  => device(1),
      STROBE  => strobe,
      COMMAND => cmd,

      WRITER  => VME_WRITE_B,
      INDATA  => VME_DATA_IN,
      OUTDATA => devout,                -- dev_outdata(1),

      DTACK   => dtack_dev(1),

      INITJTAGS => dcfeb_initjtag_i,
      TCK       => dl_jtag_tck_inner,
      TDI       => dl_jtag_tdi_inner,
      TMS       => dl_jtag_tms_inner,
      FEBTDO    => DL_JTAG_TDO,

      DIAGOUT => diagout_cfebjtag,
      LED     => led_cfebjtag
      );

  asynstrb <= '1' when device(1) = '1' else '0';  -- hack for test
  asynstrb_not <= not asynstrb;

  FDC_STROBE   : FDC port map(Q=>strobe_temp1, C=>clk40, CLR=>asynstrb_not, D=>asynstrb);
  FDC_1_STROBE : FDC_1 port map(Q=>strobe_temp2, C=>clk40, CLR=>asynstrb_not, D=>asynstrb);
  -- strobe <= '1' when (strobe_temp1 = '1' and strobe_temp2 = '1') else '0';

  COMMAND_PM : COMMAND_MODULE
    port map (
      FASTCLK => clk40,
      SLOWCLK => clk10,
      GA      => vme_ga,                -- gap = ga(5)
      ADR     => vme_addr,
      AM      => vme_am,
      AS      => vme_as,
      DS0     => vme_ds(0),
      DS1     => vme_ds(1),
      LWORD   => vme_lword,
      WRITER  => vme_write_b,
      IACK    => vme_iack,
      BERR    => vme_berr,
      SYSFAIL => vme_sysfail,
      TOVME_B => tovme_b,
      DOE_B   => doe_b,
      DEVICE  => device,
      STROBE  => strobe,
      COMMAND => cmd,
      ADRS    => cmd_adrs_inner,
      DIAGOUT => diagout_command,      -- temp
      LED     => led_command           -- temp
      );

  rstn <= not rst;
  PMAP_VME_Master : vme_master
    port map (
      clk         => clk80,
      rstn        => rstn,
      sw_reset    => rst,
      vme_cmd     => vme_cmd,
      vme_cmd_rd  => vme_cmd_rd,
      vme_wr      => vme_cmd,
      vme_addr    => vme_addr,
      vme_wr_data => vme_wr_data,
      vme_rd      => vme_rd,
      vme_rd_data => vme_rd_data,
      ga          => vme_ga,
      addr        => vme_addr,
      am          => vme_am,
      as          => vme_as,
      ds0         => vme_ds(0),
      ds1         => vme_ds(1),
      lword       => vme_lword,
      write_b     => vme_write_b,
      iack        => vme_iack,
      berr        => vme_berr,
      sysfail     => vme_sysfail,
      dtack       => vme_dtack,
      oe_b        => vme_oe_b,
      data_in     => vme_outdata,
      data_out    => vme_indata
      );


end Behavioral;
