library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;
-- use work.ucsb_types.all;

-- To mimic the behavior of ODMB_VME on the component CFEBJTAG

-- library UNISIM;
-- use UNISIM.VComponents.all;

-- use work.Firmware_pkg.all;     -- for switch between sim and synthesis

entity odmb7_ucsb_dev is
  generic (
    NCFEB       : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 for ME1/1, 5
  );
  PORT (
    --------------------
    -- Clock
    --------------------
    -- CLK160      : in std_logic;  -- For dcfeb prbs (160MHz)
    -- CLK40       : in std_logic;  -- NEW (fastclk -> 40MHz)
    -- CLK10       : in std_logic;  -- NEW (midclk -> fastclk/4 -> 10MHz)

    CMS_CLK_FPGA_P : in std_logic;      -- system clock: 40.07897 MHz
    CMS_CLK_FPGA_N : in std_logic;      -- system clock: 40.07897 MHz
    GP_CLK_6_P : in std_logic;          -- system clock: ? MHz
    GP_CLK_6_N : in std_logic;          -- system clock: ? MHz
    GP_CLK_7_P : in std_logic;          -- system clock: ? MHz, pretend 80
    GP_CLK_7_N : in std_logic;          -- system clock: ? MHz, pretend 80
    REF_CLK_1_P : in std_logic;         -- optical TX/RX refclk
    REF_CLK_1_N : in std_logic;         -- optical TX/RX refclk
    REF_CLK_2_P : in std_logic;         -- optical TX/RX refclk
    REF_CLK_2_N : in std_logic;         -- optical TX/RX refclk
    REF_CLK_3_P : in std_logic;         -- optical TX/RX refclk
    REF_CLK_3_N : in std_logic;         -- optical TX/RX refclk
    REF_CLK_4_P : in std_logic;         -- optical TX/RX refclk
    REF_CLK_4_N : in std_logic;         -- optical TX/RX refclk
    REF_CLK_5_P : in std_logic;         -- optical TX/RX refclk
    REF_CLK_5_N : in std_logic;         -- optical TX/RX refclk
    CLK_125_REF_P : in std_logic;       -- optical TX/RX refclk
    CLK_125_REF_N : in std_logic;       -- optical TX/RX refclk

    --------------------------------
    -- ODMB optical signals
    --------------------------------
    -- Optical TX/RX signals
    DAQ_RX_P : in std_logic_vector(10 downto 0);
    DAQ_RX_N : in std_logic_vector(10 downto 0);
    DAQ_SPY_RX_P : in std_logic;        -- DAQ_RX_P11 or SPY_RX_P
    DAQ_SPY_RX_N : in std_logic;        -- DAQ_RX_N11 or SPY_RX_N

    B04_RX_P : in std_logic_vector(4 downto 2); -- B04 RX, no use
    B04_RX_N : in std_logic_vector(4 downto 2); -- B04 RX, no use
    BCK_PRS_P : in std_logic; -- copy of B04_RX_P1
    BCK_PRS_N : in std_logic; -- copy of B04_RX_N1

    SPY_TX_P : out std_logic;        -- output to PC
    SPY_TX_N : out std_logic;        -- output to PC
    DAQ_TX_P : out std_logic_vector(4 downto 1); -- B04 TX, output to FED
    DAQ_TX_N : out std_logic_vector(4 downto 1); -- B04 TX, output to FED

    -- Optical control signals
    DAQ_SPY_SEL    : out std_logic;      -- 0 for DAQ_RX_P/N11, 1 for SPY_RX_P/N

    RX12_I2C_ENA   : out std_logic;
    RX12_SDA       : inout std_logic;
    RX12_SCL       : inout std_logic;
    RX12_CS_B      : out std_logic;
    RX12_RST_B     : out std_logic;
    RX12_INT_B     : in std_logic;
    RX12_PRESENT_B : in std_logic;

    TX12_I2C_ENA   : out std_logic;
    TX12_SDA       : inout std_logic;
    TX12_SCL       : inout std_logic;
    TX12_CS_B      : out std_logic;
    TX12_RST_B     : out std_logic;
    TX12_INT_B     : in std_logic;
    TX12_PRESENT_B : in std_logic;

    B04_I2C_ENA   : out std_logic;
    B04_SDA       : inout std_logic;
    B04_SCL       : inout std_logic;
    B04_CS_B      : out std_logic;
    B04_RST_B     : out std_logic;
    B04_INT_B     : in std_logic;
    B04_PRESENT_B : in std_logic;

    SPY_I2C_ENA   : out std_logic;
    SPY_SDA       : inout std_logic;
    SPY_SCL       : inout std_logic;
    SPY_SD        : in std_logic;       -- Signal Detect
    SPY_TDIS      : out std_logic;      -- Transmitter Disable

    --------------------------------
    -- Selector and monitor pins
    --------------------------------
    KUS_DL_SEL    : out std_logic;
    FPGA_SEL_18   : out std_logic;
    RST_CLKS_18_B : out std_logic;
    CCB_HARDRST_B : in std_logic;
    CCB_SOFT_RST  : in std_logic;
    DONE          : in std_logic;

    --------------------------------
    -- Others
    --------------------------------
    LEDS_CFV      : out std_logic_vector(11 downto 0)

    --------------------------------
    -- IBERT test signals for
    --------------------------------
    -- gth_txn_o : out std_logic_vector(15 downto 0);
    -- gth_txp_o : out std_logic_vector(15 downto 0);
    -- gth_rxn_i : in std_logic_vector(15 downto 0);
    -- gth_rxp_i : in std_logic_vector(15 downto 0)
    -- gth_sysclkp_i : in std_logic;  -- ibert sysclk
    -- gth_sysclkn_i : in std_logic;  -- ibert sysclk
    -- gth_refclk0p_i : in std_logic_vector(3 downto 0);
    -- gth_refclk0n_i : in std_logic_vector(3 downto 0);
    -- gth_refclk1p_i : in std_logic_vector(3 downto 0);
    -- gth_refclk1n_i : in std_logic_vector(3 downto 0)

    );
end odmb7_ucsb_dev;

architecture odmb_inst of odmb7_ucsb_dev is

  --------------------------------------
  -- Component and signals for the IBERT test
  --------------------------------------
  component clockManager is
    port (
      clk_in1    : in std_logic;
      -- clk_in1_p  : in std_logic;
      -- clk_in1_n  : in std_logic;
      clk_out40  : out std_logic;
      clk_out10  : out std_logic;
      clk_out80  : out std_logic;
      clk_out160 : out std_logic
      );
  end component;

  --------------------------------------
  -- Component and signals for the IBERT test
  --------------------------------------
  component ibert_odmb7_gth
    PORT (
      txn_o : out std_logic_vector(15 downto 0);
      txp_o : out std_logic_vector(15 downto 0);
      rxoutclk_o : out std_logic_vector(15 downto 0);
      rxn_i : in std_logic_vector(15 downto 0);
      rxp_i : in std_logic_vector(15 downto 0);
      gtrefclk0_i : in std_logic_vector(3 downto 0);
      gtrefclk1_i : in std_logic_vector(3 downto 0);
      gtnorthrefclk0_i : in std_logic_vector(3 downto 0);
      gtnorthrefclk1_i : in std_logic_vector(3 downto 0);
      gtsouthrefclk0_i : in std_logic_vector(3 downto 0);
      gtsouthrefclk1_i : in std_logic_vector(3 downto 0);
      gtrefclk00_i : in std_logic_vector(3 downto 0);
      gtrefclk10_i : in std_logic_vector(3 downto 0);
      gtrefclk01_i : in std_logic_vector(3 downto 0);
      gtrefclk11_i : in std_logic_vector(3 downto 0);
      gtnorthrefclk00_i : in std_logic_vector(3 downto 0);
      gtnorthrefclk10_i : in std_logic_vector(3 downto 0);
      gtnorthrefclk01_i : in std_logic_vector(3 downto 0);
      gtnorthrefclk11_i : in std_logic_vector(3 downto 0);
      gtsouthrefclk00_i : in std_logic_vector(3 downto 0);
      gtsouthrefclk10_i : in std_logic_vector(3 downto 0);
      gtsouthrefclk01_i : in std_logic_vector(3 downto 0);
      gtsouthrefclk11_i : in std_logic_vector(3 downto 0);
      clk : in std_logic
    );
  end component;

  component vio_ibert is
    port (
      clk        : in  std_logic := '0';
      probe_in0  : in  std_logic_vector(11 downto 0) := (others => '0');
      probe_out0 : out std_logic
      );
  end component;

  signal gth_txn_o : std_logic_vector(15 downto 0);
  signal gth_txp_o : std_logic_vector(15 downto 0);
  signal gth_rxn_i : std_logic_vector(15 downto 0);
  signal gth_rxp_i : std_logic_vector(15 downto 0);
  signal gth_qrefclk0_i : std_logic_vector(3 downto 0);
  signal gth_qrefclk1_i : std_logic_vector(3 downto 0);
  signal gth_qnorthrefclk0_i : std_logic_vector(3 downto 0);
  signal gth_qnorthrefclk1_i : std_logic_vector(3 downto 0);
  signal gth_qsouthrefclk0_i : std_logic_vector(3 downto 0);
  signal gth_qsouthrefclk1_i : std_logic_vector(3 downto 0);
  signal gth_qrefclk00_i : std_logic_vector(3 downto 0);
  signal gth_qrefclk10_i : std_logic_vector(3 downto 0);
  signal gth_qrefclk01_i : std_logic_vector(3 downto 0);
  signal gth_qrefclk11_i : std_logic_vector(3 downto 0);
  signal gth_qnorthrefclk00_i : std_logic_vector(3 downto 0);
  signal gth_qnorthrefclk10_i : std_logic_vector(3 downto 0);
  signal gth_qnorthrefclk01_i : std_logic_vector(3 downto 0);
  signal gth_qnorthrefclk11_i : std_logic_vector(3 downto 0);
  signal gth_qsouthrefclk00_i : std_logic_vector(3 downto 0);
  signal gth_qsouthrefclk10_i : std_logic_vector(3 downto 0);
  signal gth_qsouthrefclk01_i : std_logic_vector(3 downto 0);
  signal gth_qsouthrefclk11_i : std_logic_vector(3 downto 0);

  signal mgtrefclk0_226_i : std_logic;
  signal mgtrefclk1_226_i : std_logic;
  signal mgtrefclk0_odiv2_226_i : std_logic;
  signal mgtrefclk1_odiv2_226_i : std_logic;
  signal gth_sysclk_i : std_logic;
  signal clk_sysclk40 : std_logic;
  signal clk_sysclk80 : std_logic;
  signal clk_cmsclk : std_logic;
  signal clk_gp7 : std_logic;
  signal clk_mgtclk0 : std_logic;

  signal cntr_cmsclk : unsigned(40 downto 0) := (others => '0');
  signal cntr_gthclk : unsigned(40 downto 0) := (others => '0');
  signal cntr_mgtclk : unsigned(40 downto 0) := (others => '0');
  signal cntr_clkgp7 : unsigned(40 downto 0) := (others => '0');
  signal cntr_clk80  : unsigned(40 downto 0) := (others => '0');

begin

  -------------------------------------------------------------------------------------------
  -- Output pins need to be controlled
  -------------------------------------------------------------------------------------------
  KUS_DL_SEL <= '1';
  FPGA_SEL_18 <= '0';
  RST_CLKS_18_B <= '1';

  -------------------------------------------------------------------------------------------
  -- Handle VME signals
  -------------------------------------------------------------------------------------------

  u_buf_gth_q3_clk0 : IBUFDS_GTE3
    port map (
      O     => mgtrefclk0_226_i,
      ODIV2 => mgtrefclk0_odiv2_226_i,
      CEB   => '0',
      I     => REF_CLK_3_P,
      IB    => REF_CLK_3_N
      );

  u_buf_gth_q3_clk1 : IBUFDS_GTE3
    port map (
      O     => mgtrefclk1_226_i,
      ODIV2 => mgtrefclk1_odiv2_226_i,
      CEB   => '0',
      I     => CLK_125_REF_P,
      IB    => CLK_125_REF_N
      );

  -- Using external input clock pin as IBERT sysclk <- option 1
  u_ibufgds_gp7 : IBUFGDS
    -- generic map (DIFF_TERM => TRUE)
    port map (
      I => GP_CLK_7_P,
      IB => GP_CLK_7_N,
      O => clk_gp7
    );

  -- Using the clock manager output as IBERT sysclk <- option 2
  u_ibufgds_cms : IBUFGDS
    -- generic map (DIFF_TERM => TRUE)
    port map (
      I => CMS_CLK_FPGA_P,
      IB => CMS_CLK_FPGA_N,
      O => clk_cmsclk
    );

  -- Using optical refclk as IBERT sysclk <- option 3
  u_gth_sysclk_internal : BUFG_GT
    port map(
      I       => mgtrefclk0_odiv2_226_i,
      O       => clk_mgtclk0,
      CE      => '1',
      CEMASK  => '0',
      CLR     => '0',
      CLRMASK => '0',
      DIV     => "000"
      );

  -- Extras for LED
  clockManager_i : clockManager
    port map (
      clk_in1   => clk_cmsclk,     -- input 40 MHz
      -- clk_in1_p  => CMS_CLK_FPGA_P,
      -- clk_in1_n  => CMS_CLK_FPGA_N,
      clk_out40 => clk_sysclk40,   -- output 40 MHz
      clk_out80 => clk_sysclk80    -- output 80 MHz
      );

  gth_sysclk_i <= clk_sysclk80;
  -- gth_sysclk_i <= clk_mgtclk0;
  -- gth_sysclk_i <= clk_gp7;

  vio_gth : vio_ibert
  port map (
    clk        => gth_sysclk_i,
    probe_in0  => std_logic_vector(cntr_gthclk(40 downto 29)),
    probe_out0 => open
    -- probe_out0 => DAQ_SPY_SEL
  );

  DAQ_SPY_SEL <= '1';   -- Priority to test the SPY TX

  -- Clock counting and LED outputs
  process (clk_cmsclk)
  begin
    if (rising_edge(clk_cmsclk)) then
      cntr_cmsclk <= cntr_cmsclk + 1;
      LEDS_CFV(0) <= std_logic(cntr_cmsclk(29));
    end if;
  end process;

  process (clk_sysclk80)
  begin
    if (rising_edge(clk_sysclk80)) then
      cntr_clk80 <= cntr_clk80 + 1;
      LEDS_CFV(1) <= std_logic(cntr_clk80(29));
    end if;
  end process;

  process (clk_gp7)
  begin
    if (rising_edge(clk_gp7)) then
      cntr_clkgp7 <= cntr_clkgp7 + 1;
      LEDS_CFV(2) <= std_logic(cntr_clkgp7(29));
    end if;
  end process;

  process (clk_mgtclk0)
  begin
    if (rising_edge(clk_mgtclk0)) then
      cntr_mgtclk <= cntr_mgtclk + 1;
      LEDS_CFV(3) <= std_logic(cntr_mgtclk(29));
    end if;
  end process;

  process (gth_sysclk_i)
  begin
    if (rising_edge(gth_sysclk_i)) then
      cntr_gthclk <= cntr_gthclk + 1;
      LEDS_CFV(4) <= std_logic(cntr_gthclk(29));
    end if;
  end process;

  -- vio_clk80 : vio_ibert
  --   port map (
  --     clk        => clk_sysclk80,
  --     probe_in0  => std_logic_vector(cntr_clk80(40 downto 29)),
  --     probe_out0 => open
  --     );

  -- vio_cmsclk : vio_ibert
  --   port map (
  --     clk        => clk_cmsclk,
  --     probe_in0  => std_logic_vector(cntr_cmsclk(40 downto 29)),
  --     probe_out0 => open
  --     );

  -- vio_clkgp7 : vio_ibert
  --   port map (
  --     clk        => clk_gp7,
  --     probe_in0  => std_logic_vector(cntr_clkgp7(40 downto 29)),
  --     probe_out0 => open
  --     );

  -- MGT I/O pins assignment
  gth_rxp_i(10 downto 0)  <= DAQ_RX_P;
  gth_rxn_i(10 downto 0)  <= DAQ_RX_N;
  gth_rxp_i(11)           <= DAQ_SPY_RX_P;
  gth_rxn_i(11)           <= DAQ_SPY_RX_N;
  gth_rxp_i(12)           <= BCK_PRS_P;
  gth_rxn_i(12)           <= BCK_PRS_N;
  gth_rxp_i(15 downto 13) <= B04_RX_P;
  gth_rxn_i(15 downto 13) <= B04_RX_N;

  DAQ_TX_P <= gth_txp_o(15 downto 12);
  DAQ_TX_N <= gth_txn_o(15 downto 12);
  SPY_TX_P <= gth_txp_o(11);
  SPY_TX_N <= gth_txn_o(11);

  -- Refclk connection from each IBUFDS to respective quads depending on the source selected in gui
  gth_qrefclk0_i(0) <= '0';
  gth_qrefclk1_i(0) <= '0';
  gth_qnorthrefclk0_i(0) <= '0';
  gth_qnorthrefclk1_i(0) <= '0';
  gth_qsouthrefclk0_i(0) <= mgtrefclk0_226_i;
  gth_qsouthrefclk1_i(0) <= '0';
  -- COMMON clock connection
  gth_qrefclk00_i(0) <= '0';
  gth_qrefclk10_i(0) <= '0';
  gth_qrefclk01_i(0) <= '0';
  gth_qrefclk11_i(0) <= '0';
  gth_qnorthrefclk00_i(0) <= '0';
  gth_qnorthrefclk10_i(0) <= '0';
  gth_qnorthrefclk01_i(0) <= '0';
  gth_qnorthrefclk11_i(0) <= '0';
  gth_qsouthrefclk00_i(0) <= mgtrefclk0_226_i;
  gth_qsouthrefclk10_i(0) <= '0';
  gth_qsouthrefclk01_i(0) <= mgtrefclk0_226_i;
  gth_qsouthrefclk11_i(0) <= '0';

  gth_qrefclk0_i(1) <= '0';
  gth_qrefclk1_i(1) <= '0';
  gth_qnorthrefclk0_i(1) <= '0';
  gth_qnorthrefclk1_i(1) <= '0';
  gth_qsouthrefclk0_i(1) <= mgtrefclk0_226_i;
  gth_qsouthrefclk1_i(1) <= '0';
  -- COMMON clock connection
  gth_qrefclk00_i(1) <= '0';
  gth_qrefclk10_i(1) <= '0';
  gth_qrefclk01_i(1) <= '0';
  gth_qrefclk11_i(1) <= '0';
  gth_qnorthrefclk00_i(1) <= '0';
  gth_qnorthrefclk10_i(1) <= '0';
  gth_qnorthrefclk01_i(1) <= '0';
  gth_qnorthrefclk11_i(1) <= '0';
  gth_qsouthrefclk00_i(1) <= mgtrefclk0_226_i;
  gth_qsouthrefclk10_i(1) <= '0';
  gth_qsouthrefclk01_i(1) <= mgtrefclk0_226_i;
  gth_qsouthrefclk11_i(1) <= '0';

  gth_qrefclk0_i(2) <= mgtrefclk0_226_i;
  gth_qrefclk1_i(2) <= mgtrefclk1_226_i;
  gth_qnorthrefclk0_i(2) <= '0';
  gth_qnorthrefclk1_i(2) <= '0';
  gth_qsouthrefclk0_i(2) <= '0';
  gth_qsouthrefclk1_i(2) <= '0';
  -- COMMON clock connection
  gth_qrefclk00_i(2) <= mgtrefclk0_226_i;
  gth_qrefclk10_i(2) <= mgtrefclk1_226_i;
  gth_qrefclk01_i(2) <= mgtrefclk0_226_i;
  gth_qrefclk11_i(2) <= mgtrefclk1_226_i;
  gth_qnorthrefclk00_i(2) <= '0';
  gth_qnorthrefclk10_i(2) <= '0';
  gth_qnorthrefclk01_i(2) <= '0';
  gth_qnorthrefclk11_i(2) <= '0';
  gth_qsouthrefclk00_i(2) <= '0';
  gth_qsouthrefclk10_i(2) <= '0';
  gth_qsouthrefclk01_i(2) <= '0';
  gth_qsouthrefclk11_i(2) <= '0';

  gth_qrefclk0_i(3) <= '0';
  gth_qrefclk1_i(3) <= '0';
  gth_qnorthrefclk0_i(3) <= mgtrefclk0_226_i;
  gth_qnorthrefclk1_i(3) <= '0';
  gth_qsouthrefclk0_i(3) <= '0';
  gth_qsouthrefclk1_i(3) <= '0';
  -- COMMON clock connection
  gth_qrefclk00_i(3) <= '0';
  gth_qrefclk10_i(3) <= '0';
  gth_qrefclk01_i(3) <= '0';
  gth_qrefclk11_i(3) <= '0';
  gth_qnorthrefclk00_i(3) <= mgtrefclk0_226_i;
  gth_qnorthrefclk10_i(3) <= '0';
  gth_qnorthrefclk01_i(3) <= mgtrefclk0_226_i;
  gth_qnorthrefclk11_i(3) <= '0';
  gth_qsouthrefclk00_i(3) <= '0';
  gth_qsouthrefclk10_i(3) <= '0';
  gth_qsouthrefclk01_i(3) <= '0';
  gth_qsouthrefclk11_i(3) <= '0';

  u_ibert_gth_core : ibert_odmb7_gth
    port map (
      txn_o => gth_txn_o,
      txp_o => gth_txp_o,
      rxn_i => gth_rxn_i,
      rxp_i => gth_rxp_i,
      clk => gth_sysclk_i,
      gtrefclk0_i => gth_qrefclk0_i,
      gtrefclk1_i => gth_qrefclk1_i,
      gtnorthrefclk0_i => gth_qnorthrefclk0_i,
      gtnorthrefclk1_i => gth_qnorthrefclk1_i,
      gtsouthrefclk0_i => gth_qsouthrefclk0_i,
      gtsouthrefclk1_i => gth_qsouthrefclk1_i,
      gtrefclk00_i => gth_qrefclk00_i,
      gtrefclk10_i => gth_qrefclk10_i,
      gtrefclk01_i => gth_qrefclk01_i,
      gtrefclk11_i => gth_qrefclk11_i,
      gtnorthrefclk00_i => gth_qnorthrefclk00_i,
      gtnorthrefclk10_i => gth_qnorthrefclk10_i,
      gtnorthrefclk01_i => gth_qnorthrefclk01_i,
      gtnorthrefclk11_i => gth_qnorthrefclk11_i,
      gtsouthrefclk00_i => gth_qsouthrefclk00_i,
      gtsouthrefclk10_i => gth_qsouthrefclk10_i,
      gtsouthrefclk01_i => gth_qsouthrefclk01_i,
      gtsouthrefclk11_i => gth_qsouthrefclk11_i
      );

  -------------------------------------------------------------------------------------------
  -- Handle PPIB/DCFEB signals
  -------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------
  -- Handle Internal configuration signals
  -------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------
  -- Handle reset signals
  -------------------------------------------------------------------------------------------

  --need flip flop, ultrascale only has fancy ones like FDXE

  -------------------------------------------------------------------------------------------
  -- Sub-modules
  -------------------------------------------------------------------------------------------


end odmb_inst;
