library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity odmb7_dev_tb is
  generic (
    NCFEB       : integer range 1 to 7 := 7
    );
end entity odmb7_dev_tb;

architecture Behavioral of odmb7_dev_tb is


  -- LUT constents
  constant bw_addr   : integer := 4;
  constant bw_addr_entries : integer := 16;
  constant bw_input1 : integer := 16;
  constant bw_input2 : integer := 16;
  
  -- component pseudolut is
  --   port (
  --     CLK   : in std_logic;
  --     ADDR  : in std_logic_vector(3 downto 0);
  --     DOUT1 : out std_logic_vector(15 downto 0);
  --     DOUT2 : out std_logic_vector(15 downto 0)
  --     );
  -- end component;

  signal use_vio_input_vector : std_logic_vector(0 downto 0) := "0";
  signal vio_issue_vme_cmd_vector : std_logic_vector(0 downto 0) := "0";
  signal use_vio_input : std_logic := '0';
  signal vio_issue_vme_cmd : std_logic := '0';
  signal vio_issue_vme_cmd_q : std_logic := '0';
  signal vio_issue_vme_cmd_qq : std_logic := '0';
  signal vio_vme_addr : std_logic_vector(15 downto 0) := x"0000";
  signal vio_vme_data : std_logic_vector(15 downto 0) := x"0000";
  signal vio_vme_out : std_logic_vector(15 downto 0) := x"0000";
  signal vme_dtack_q : std_logic := '0';

  -- Clock signals
  signal cmsclk   : std_logic := '0';
  signal cmsclk_p : std_logic := '0';
  signal cmsclk_n : std_logic := '1';
  signal cmsclk10 : std_logic := '0';
  signal cmsclk80 : std_logic := '0';
  signal cmsclk80_p : std_logic := '0';
  signal cmsclk80_n : std_logic := '1';
  signal cmsclk120_p : std_logic := '0';
  signal cmsclk120_n : std_logic := '1';
  signal cmsclk160_p : std_logic := '0';
  signal cmsclk160_n : std_logic := '1';
  signal oscclk125_p : std_logic := '0';
  signal oscclk125_n : std_logic := '1';
  signal oscclk160_p : std_logic := '0';
  signal oscclk160_n : std_logic := '1';
  signal init_done: std_logic := '0';
  -- Constants
  constant bw_output : integer := 20;
  constant bw_fifo   : integer := 18;
  constant bw_count  : integer := 16;
  constant bw_wait   : integer := 10;
  constant nclksrun  : integer := 2048;
  -- Counters
  signal waitCounter  : unsigned(bw_wait-1 downto 0) := (others=> '0');
  signal inputCounter : unsigned(bw_count-1 downto 0) := (others=> '0');
  signal startCounter  : unsigned(bw_count-1 downto 0) := (others=> '0');

  -- Reset
  signal rst_global : std_logic := '0';

  --Diagnostic
  signal diagout          : std_logic_vector (17 downto 0) := (others => '0');

  -- VME signals
  -- Simulation (PC) -> VME
  attribute mark_debug : string;
  signal vme_data_in      : std_logic_vector (15 downto 0) := (others => '0');
  signal rstn             : std_logic := '1';
  signal vc_cmd           : std_logic := '0';
  signal vc_cmd_q         : std_logic := '0';
  signal vc_cmd_rd        : std_logic := '0';
  signal vc_cmd_rd_q      : std_logic := '0';
  signal vc_addr          : std_logic_vector(23 downto 1) := (others => '0');
  signal vc_rd            : std_logic := '0';
  signal vc_rd_data       : std_logic_vector(15 downto 0) := (others => '0');
  -- VME -> ODMB
  -- signal vme_gap     : std_logic := '0';
  signal vme_ga      : std_logic_vector(5 downto 0) := (others => '0');
  signal vme_addr    : std_logic_vector(23 downto 1) := (others => '0');
  signal vme_am      : std_logic_vector(5 downto 0) := (others => '0');
  signal vme_as      : std_logic := '0';
  signal vme_ds      : std_logic_vector(1 downto 0) := (others => '0');
  signal vme_lword   : std_logic := '0';
  signal vme_write_b : std_logic := '0';
  signal vme_berr    : std_logic := '0';
  signal vme_iack    : std_logic := '0';
  signal vme_sysrst  : std_logic := '0';
  signal vme_sysfail : std_logic := '0';
  signal vme_clk_b   : std_logic := '0';
  signal vme_oe_b    : std_logic := '0';
  signal kus_vme_oe_b : std_logic := '0';
  signal vme_dir     : std_logic := '0';
  signal vme_data_io_in   : std_logic_vector(15 downto 0) := (others => '0');
  signal vme_data_io_out  : std_logic_vector (15 downto 0) := (others => '0');
  signal vme_data_io_in_buf   : std_logic_vector(15 downto 0) := (others => '0');
  signal vme_data_io_out_buf  : std_logic_vector (15 downto 0) := (others => '0');
  signal vme_data_io      : std_logic_vector(15 downto 0) := (others => '0');
  signal vme_dtack   : std_logic := 'H';

  -- DCFEB signals (ODMB <-> (xD)CFEB)
  signal dl_jtag_tck    : std_logic_vector (NCFEB downto 1)  := (others => '0');
  signal dl_jtag_tms    : std_logic := '0';
  signal dl_jtag_tdi    : std_logic := '0';
  signal dl_jtag_tdo    : std_logic_vector (NCFEB downto 1)  := (others => '0');
  signal dcfeb_initjtag : std_logic := '0';
  signal dcfeb_tck_p    : std_logic_vector (NCFEB downto 1)  := (others => '0');
  signal dcfeb_tck_n    : std_logic_vector (NCFEB downto 1)  := (others => '0');
  signal dcfeb_tms_p    : std_logic := '0';
  signal dcfeb_tms_n    : std_logic := '0';
  signal dcfeb_tdi_p    : std_logic := '0';
  signal dcfeb_tdi_n    : std_logic := '0';
  signal dcfeb_tdo_p    : std_logic_vector (NCFEB downto 1)  := (others => '0');
  signal dcfeb_tdo_n    : std_logic_vector (NCFEB downto 1)  := (others => '0');
  signal injpls         : std_logic := '0';
  signal injpls_p       : std_logic := '0';
  signal injpls_n       : std_logic := '0';
  signal extpls         : std_logic := '0';
  signal extpls_p       : std_logic := '0';
  signal extpls_n       : std_logic := '0';
  signal dcfeb_resync   : std_logic := '0';
  signal resync_p       : std_logic := '0';
  signal resync_n       : std_logic := '0';
  signal dcfeb_bc0      : std_logic := '0';
  signal bc0_p          : std_logic := '0';
  signal bc0_n          : std_logic := '0';
  signal dcfeb_l1a      : std_logic := '0';
  signal l1a_p          : std_logic := '0';
  signal l1a_n          : std_logic := '0';
  signal dcfeb_l1a_match : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal l1a_match_p     : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal l1a_match_n     : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal dcfeb_diagout  : std_logic_vector(17 downto 0) := (others => '0');

  -- signal dcfeb_tdo_t    : std_logic_vector (NCFEB downto 1)  := (others => '0');

  signal dcfeb_done       : std_logic_vector (NCFEB downto 1) := (others => '0');

  signal lvmb_pon     : std_logic_vector(7 downto 0);
  signal pon_load     : std_logic;
  signal pon_oe       : std_logic;
  signal r_lvmb_PON   : std_logic_vector(7 downto 0);
  signal lvmb_csb     : std_logic_vector(6 downto 0);
  signal lvmb_sclk    : std_logic;
  signal lvmb_sdin    : std_logic;
  signal lvmb_sdout_p : std_logic;
  signal lvmb_sdout_n : std_logic;

  signal dcfeb_prbs_FIBER_SEL : std_logic_vector(3 downto 0);
  signal dcfeb_prbs_EN        : std_logic;
  signal dcfeb_prbs_RST       : std_logic;
  signal dcfeb_prbs_RD_EN     : std_logic;
  signal dcfeb_rxprbserr      : std_logic;
  signal dcfeb_prbs_ERR_CNT   : std_logic_vector(15 downto 0);

  signal otmb_tx    : std_logic_vector(48 downto 0);
  signal otmb_rx    : std_logic_vector(5 downto 0);

  signal cms_clk_fpga_p : std_logic;
  signal cms_clk_fpga_n : std_logic;

  signal b04_rx_p : std_logic_vector(4 downto 2);
  signal b04_rx_n : std_logic_vector(4 downto 2);

  signal daq_loopback_p : std_logic_vector(4 downto 4);
  signal daq_loopback_n : std_logic_vector(4 downto 4);

  -- ILA
  signal trig0 : std_logic_vector(255 downto 0) := (others=> '0');
  signal data  : std_logic_vector(4095 downto 0) := (others=> '0');
  -- LUT input
  signal lut_input_addr1_s : unsigned(bw_addr-1 downto 0) := (others=> '0');
  signal lut_input_addr2_s : unsigned(bw_addr-1 downto 0) := (others=> '0');
  signal lut_input1_dout_c : std_logic_vector(bw_input1-1 downto 0) := (others=> '0');
  signal lut_input2_dout_c : std_logic_vector(bw_input2-1 downto 0) := (others=> '0');

  --signals for generating input to VME
  signal cmddev    : std_logic_vector(15 downto 0) := (others=> '0');
  attribute mark_debug of cmddev : signal is "true";
  signal nextcmd   : std_logic := '1';
  signal cack      : std_logic := 'H';
  attribute mark_debug of cack : signal is "true";
  signal cack_reg  : std_logic := 'H';
  signal cack_i    : std_logic := '1';

  -- Checker bit
  signal checker  : std_logic := '0';

begin

  -- Generate clock in simulation
  cmsclk <= not cmsclk after 12.5 ns;
  cmsclk_p <= not cmsclk_p after 12.5 ns;
  cmsclk_n <= not cmsclk_n after 12.5 ns;
  cmsclk80_p <= not cmsclk80_p after 6.25 ns;
  cmsclk80_n <= not cmsclk80_n after 6.25 ns;
  cmsclk120_p <= not cmsclk120_p after 4.16667 ns;
  cmsclk120_n <= not cmsclk120_n after 4.16667 ns;
  cmsclk160_p <= not cmsclk160_p after 3.125 ns;
  cmsclk160_n <= not cmsclk160_n after 3.125 ns;

  oscclk160_p <= not cmsclk160_p after 3.125 ns;
  oscclk160_n <= not cmsclk160_n after 3.125 ns;
  oscclk125_p <= not cmsclk160_p after 4 ns;
  oscclk125_n <= not cmsclk160_n after 4 ns;

  -- -- Input LUTs
  -- lut_input1_i: lut_input1
  --   port map(
  --     clka=> cmsclk,
  --     addra=> std_logic_vector(lut_input_addr1_s),
  --     douta=> lut_input1_dout_c
  --     );
  -- lut_input2_i: lut_input2
  --   port map(
  --     clka=> cmsclk,
  --     addra=> std_logic_vector(lut_input_addr2_s),
  --     douta=> lut_input2_dout_c
  --     );
  -- pseudolut_i : pseudolut
  --   port map(
  --     CLK => cmsclk,
  --     ADDR => std_logic_vector(lut_input_addr1_s),
  --     DOUT1 => lut_input1_dout_c,
  --     DOUT2 => lut_input2_dout_c
  --     );

  --in simulation, VIO always outputs 0, even though this output is default 1
  --use_vio_input <= use_vio_input_vector(0);
  --vio_issue_vme_cmd <= vio_issue_vme_cmd_vector(0);

  -- Process to generate counter and initialization
  startGenerator_i: process (cmsclk) is
  begin
    if rising_edge(cmsclk) then
      if (init_done = '0') then
        startCounter <= startCounter + 1;
        -- Set the intime to 1 only after 7 clk cycles
        if startCounter = 0 then
          rst_global <= '1';
        elsif startCounter = 1 then
          rst_global <= '0';
          init_done <= '0';
        elsif startCounter = 6 then
          dcfeb_initjtag <= '1';
        elsif startCounter = 7 then
          dcfeb_initjtag <= '0';
          init_done <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Process to read input from LUTs or VIO and give to VME
  inputGenerator_i: process (cmsclk) is
    variable init_input1: unsigned(bw_fifo-3 downto 0):= (others => '0');
    variable init_input2: unsigned(bw_fifo-3 downto 0):= (others => '1');
  begin
    if cmsclk'event and cmsclk='1' then
      if init_done = '1' then
        --if (use_vio_input = '0') then
        --handle LUT input
        if waitCounter = 0  then
          if cack = '1' then
            inputCounter <= inputCounter + 1;
            waitCounter <= "0000001000";
            -- Initalize lut_input_addr_s
            if inputCounter = 0 then
              lut_input_addr1_s <= to_unsigned(0,bw_addr);
              lut_input_addr2_s <= to_unsigned(0,bw_addr);
              cmddev <= std_logic_vector(init_input1);
            else
              if lut_input_addr1_s = bw_addr_entries-1 then
                lut_input_addr1_s <= x"0";
                lut_input_addr2_s <= x"0";
              else
                lut_input_addr1_s <= lut_input_addr1_s + 1;
                lut_input_addr2_s <= lut_input_addr2_s + 1;
              end if;
              cmddev <= lut_input1_dout_c;
              vme_data_in <= lut_input2_dout_c;
            end if;
          else
            cmddev <= std_logic_vector(init_input1);
          end if;
        else
          cmddev <= std_logic_vector(init_input1);
          waitCounter <= waitCounter - 1;
        end if;
      else
        inputCounter <= to_unsigned(0,bw_count);
      end if;
    end if;
  end process;

  -- generate vme output for vio
  --proc_vio_vme_out : process (cmsclk) is
  --begin
  --if rising_edge(cmsclk) then
  --  vme_dtack_q <= vme_dtack;
  --  if (vme_dtack='0' and vme_dtack_q='1') then
  --    vio_vme_out <= vme_data_io_out;
  --  end if;
  --end if;
  --end process;

  -- Generate VME acknowledge
  i_cmd_ack : process (vc_cmd, vc_cmd_rd) is
  begin
    if vc_cmd'event and vc_cmd = '1' then
      cack_i <= '0';
    end if;
    if vc_cmd_rd'event and vc_cmd_rd = '1' then
      cack_i <= '1';
    end if;
  end process;
  cack <= cack_i;

  --aVME signal management
  rstn <= not rst_global;
  vc_cmd <= '1' when (cmddev(15 downto 12) = x"1" or cmddev(15 downto 12) = x"2" or cmddev(15 downto 12) = x"4" or cmddev(15 downto 12) = x"3" or cmddev(15 downto 12) = x"6" or cmddev(15 downto 12) = x"7" or cmddev(15 downto 12) = x"8") else '0';
  vc_addr <= x"A8" & cmddev(15 downto 1);
  vc_rd <=  '1' when vme_data_in = x"2EAD" else '0';

  -- Manage ODMB<->VME<->VCC signals-------------------------------------------------------------------
  -- in simulation/real ODMB, use IOBUF
  VCC_GEN_15 : for I in 0 to 15 generate
  begin
    VME_BUF : IOBUF port map(O => vme_data_io_out_buf(I), IO => vme_data_io(I), I => vme_data_io_in_buf(I), T => vme_oe_b);
  end generate VCC_GEN_15;

  b04_rx_p(4) <= daq_loopback_p(4);
  b04_rx_n(4) <= daq_loopback_n(4);
  b04_rx_p(3) <= '0';
  b04_rx_n(3) <= '0';
  b04_rx_p(2) <= '0';
  b04_rx_n(2) <= '0';

  -- ODMB Firmware module
  odmb_i: entity work.odmb7_dev_top
    port map(
      -- Clock
      CMS_CLK_FPGA_P       => cmsclk_p,
      CMS_CLK_FPGA_N       => cmsclk_n,
      GP_CLK_6_P           => cmsclk80_p,
      GP_CLK_6_N           => cmsclk80_n,
      GP_CLK_7_P           => cmsclk80_p,
      GP_CLK_7_N           => cmsclk80_n,
      REF_CLK_1_P          => cmsclk160_p,
      REF_CLK_1_N          => cmsclk160_n,
      REF_CLK_2_P          => cmsclk160_p,
      REF_CLK_2_N          => cmsclk160_n,
      REF_CLK_3_P          => oscclk160_p,
      REF_CLK_3_N          => oscclk160_n,
      REF_CLK_4_P          => cmsclk120_p,
      REF_CLK_4_N          => cmsclk120_n,
      REF_CLK_5_P          => cmsclk160_p,
      REF_CLK_5_N          => cmsclk160_n,
      CLK_125_REF_P        => oscclk125_p,
      CLK_125_REF_N        => oscclk125_n,
      EMCCLK               => oscclk125_p, -- Low frequency, 133 MHz for SPI programing clock, use 160 for now...
      LF_CLK               => cmsclk10, -- Low frequency, 10 kHz, use clk10 for now

      VME_DATA             => vme_data_io,
      VME_GAP_B            => vme_ga(5),
      VME_GA_B             => vme_ga(4 downto 0),
      VME_ADDR             => vme_addr,
      VME_AM               => vme_am,
      VME_AS_B             => vme_as,
      VME_DS_B             => vme_ds,
      VME_LWORD_B          => vme_lword,
      VME_WRITE_B          => vme_write_b,
      VME_IACK_B           => vme_iack,
      VME_BERR_B           => vme_berr,
      VME_SYSRST_B         => vme_sysrst,
      VME_SYSFAIL_B        => vme_sysfail,
      VME_CLK_B            => vme_clk_b,
      KUS_VME_OE_B         => kus_vme_oe_b,
      KUS_VME_DIR          => vme_dir,
      VME_DTACK_KUS_B      => vme_dtack,

      DCFEB_TCK_P          => dcfeb_tck_p,
      DCFEB_TCK_N          => dcfeb_tck_n,
      DCFEB_TMS_P          => dcfeb_tms_p,
      DCFEB_TMS_N          => dcfeb_tms_n,
      DCFEB_TDI_P          => dcfeb_tdi_p,
      DCFEB_TDI_N          => dcfeb_tdi_n,
      DCFEB_TDO_P          => dcfeb_tdo_p,
      DCFEB_TDO_N          => dcfeb_tdo_n,
      DCFEB_DONE           => dcfeb_done,
      RESYNC_P             => resync_p,
      RESYNC_N             => resync_n,
      BC0_P                => bc0_p,
      BC0_N                => bc0_n,
      INJPLS_P             => injpls_p,
      INJPLS_N             => injpls_n,
      EXTPLS_P             => extpls_p,
      EXTPLS_N             => extpls_n,
      L1A_P                => l1a_p,
      L1A_N                => l1a_n,
      L1A_MATCH_P          => l1a_match_p,
      L1A_MATCH_N          => l1a_match_n,
      PPIB_OUT_EN_B        => open,
      -- DCFEB_REPROG_B       => open,

      -- CCB_CMD              => "011000",
      -- CCB_CMD_S            => cmsclk80,
      -- CCB_DATA             => x"00",
      -- CCB_DATA_S           => '0',
      -- CCB_CAL              => "000",
      -- CCB_CRSV             => x"0",
      -- CCB_DRSV             => "00",
      -- CCB_RSVO             => "00000",
      -- CCB_RSVI             => open,
      -- CCB_BX0_B            => '1',
      -- CCB_BX_RST_B         => '1',
      -- CCB_L1A_RST_B        => '1',
      -- CCB_L1A_B            => '1',
      -- CCB_L1A_RLS          => open,
      -- CCB_CLKEN            => '0',
      -- CCB_EVCNTRES_B       => '1',
      CCB_HARDRST_B        => '0',
      CCB_SOFT_RST         => '1',

      LVMB_PON             => lvmb_pon,
      PON_LOAD             => pon_load,
      PON_OE_B             => pon_oe,
      MON_LVMB_PON         => x"00",
      LVMB_CSB             => lvmb_csb,
      LVMB_SCLK            => lvmb_sclk,
      LVMB_SDIN            => lvmb_sdin,
      -- LVMB_SDOUT_P         => lvmb_sdout_p,
      -- LVMB_SDOUT_N         => lvmb_sdout_n,

      -- OTMB                 => x"F_FFFFFFFF",
      -- RAWLCT               => x"00",
      -- OTMB_DAV             => '0',
      -- LEGACY_ALCT_DAV      => '0',
      -- OTMB_FF_CLK          => '0',
      -- RSVTD                => "000",
      -- RSVFD                => open,
      -- LCT_RQST             => open,

      -- KUS_TMS              => open,
      -- KUS_TCK              => open,
      -- KUS_TDI              => open,
      -- KUS_TDO              => '0',
      KUS_DL_SEL           => open,

      DAQ_RX_P             => "00000000000",
      DAQ_RX_N             => "00000000000",
      DAQ_SPY_RX_P         => '0',
      DAQ_SPY_RX_N         => '0',
      B04_RX_P             => b04_rx_p,
      B04_RX_N             => b04_rx_n,
      BCK_PRS_P            => '0',
      BCK_PRS_N            => '0',
      SPY_TX_P             => open,
      SPY_TX_N             => open,
      DAQ_TX_P             => daq_loopback_p,
      DAQ_TX_N             => daq_loopback_n,

      DAQ_SPY_SEL          => open,
      RX12_I2C_ENA         => open,
      RX12_SDA             => open,
      RX12_SCL             => open,
      RX12_CS_B            => open,
      RX12_RST_B           => open,
      RX12_INT_B           => '0',
      RX12_PRESENT_B       => '0',
      TX12_I2C_ENA         => open,
      TX12_SDA             => open,
      TX12_SCL             => open,
      TX12_CS_B            => open,
      TX12_RST_B           => open,
      TX12_INT_B           => '0',
      TX12_PRESENT_B       => '0',
      B04_I2C_ENA          => open,
      B04_SDA              => open,
      B04_SCL              => open,
      B04_CS_B             => open,
      B04_RST_B            => open,
      B04_INT_B            => '0',
      B04_PRESENT_B        => '0',
      SPY_I2C_ENA          => open,
      SPY_SDA              => open,
      SPY_SCL              => open,
      SPY_SD               => '0',
      SPY_TDIS             => open,

      ODMB_DONE            => '1',
      FPGA_SEL             => open,
      RST_CLKS_B           => open,

      SYSMON_P             => x"0000",
      SYSMON_N             => x"0000",
      ADC_CS_B             => open,
      ADC_DIN              => open,
      ADC_SCK              => open,
      ADC_DOUT             => '1',

      -- PROM_RST_B           => open,
      -- PROM_CS2_B           => open,
      -- CNFG_DATA            => open,

      LEDS_CFV             => open
      );



end Behavioral;
