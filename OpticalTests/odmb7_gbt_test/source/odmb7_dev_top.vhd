----------------------------------------------------------------------------------
-- Project Name:    ODMB7_DEV
-- Target Devices:  Kintex Ultrascale xcku035-ffva1156-1-c
-- Tool versions:   Vivado 2019.2
-- Description:     Development firmware for the ODMB7
----------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library work;
use work.ucsb_types.all;

use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;

library unisim;
use unisim.vcomponents.all;

entity odmb7_dev_top is
  port (
    --------------------
    -- Clock
    --------------------
    CMS_CLK_FPGA_P : in std_logic;      -- system clock: 40.07897 MHz
    CMS_CLK_FPGA_N : in std_logic;      -- system clock: 40.07897 MHz
    GP_CLK_6_P : in std_logic;          -- clock synthesizer ODIV6: 80 MHz
    GP_CLK_6_N : in std_logic;          -- clock synthesizer ODIV6: 80 MHz
    GP_CLK_7_P : in std_logic;          -- clock synthesizer ODIV7: 80 MHz
    GP_CLK_7_N : in std_logic;          -- clock synthesizer ODIV7: 80 MHz
    REF_CLK_1_P : in std_logic;         -- refclk0 to 224
    REF_CLK_1_N : in std_logic;         -- refclk0 to 224
    REF_CLK_2_P : in std_logic;         -- refclk0 to 227
    REF_CLK_2_N : in std_logic;         -- refclk0 to 227
    REF_CLK_3_P : in std_logic;         -- refclk0 to 226
    REF_CLK_3_N : in std_logic;         -- refclk0 to 226
    REF_CLK_4_P : in std_logic;         -- refclk0 to 225
    REF_CLK_4_N : in std_logic;         -- refclk0 to 225
    REF_CLK_5_P : in std_logic;         -- refclk1 to 227
    REF_CLK_5_N : in std_logic;         -- refclk1 to 227
    CLK_125_REF_P : in std_logic;       -- refclk1 to 226
    CLK_125_REF_N : in std_logic;       -- refclk1 to 226
    EMCCLK : in std_logic;              -- Low frequency, 133 MHz for SPI programing clock
    LF_CLK : in std_logic;              -- Low frequency, 10 kHz

    --------------------
    -- Signals controlled by ODMB_VME
    --------------------
    VME_DATA        : inout std_logic_vector(15 downto 0); -- Bank 48
    VME_GAP_B       : in std_logic;                        -- Bank 48
    VME_GA_B        : in std_logic_vector(4 downto 0);     -- Bank 48
    VME_ADDR        : in std_logic_vector(23 downto 1);    -- Bank 46
    VME_AM          : in std_logic_vector(5 downto 0);     -- Bank 46
    VME_AS_B        : in std_logic;                        -- Bank 46
    VME_DS_B        : in std_logic_vector(1 downto 0);     -- Bank 46
    VME_LWORD_B     : in std_logic;                        -- Bank 48
    VME_WRITE_B     : in std_logic;                        -- Bank 48
    VME_IACK_B      : in std_logic;                        -- Bank 48
    VME_BERR_B      : in std_logic;                        -- Bank 48
    VME_SYSRST_B    : in std_logic;                        -- Bank 48, not used
    VME_SYSFAIL_B   : in std_logic;                        -- Bank 48
    VME_CLK_B       : in std_logic;                        -- Bank 48, not used
    KUS_VME_OE_B    : out std_logic;                       -- Bank 44
    KUS_VME_DIR     : out std_logic;                       -- Bank 44
    VME_DTACK_KUS_B : out std_logic;                       -- Bank 44

    DCFEB_TCK_P    : out std_logic_vector(7 downto 1);     -- Bank 68
    DCFEB_TCK_N    : out std_logic_vector(7 downto 1);     -- Bank 68
    DCFEB_TMS_P    : out std_logic;                        -- Bank 68
    DCFEB_TMS_N    : out std_logic;                        -- Bank 68
    DCFEB_TDI_P    : out std_logic;                        -- Bank 68
    DCFEB_TDI_N    : out std_logic;                        -- Bank 68
    DCFEB_TDO_P    : in  std_logic_vector(7 downto 1);     -- "C_TDO" in Bank 67-68
    DCFEB_TDO_N    : in  std_logic_vector(7 downto 1);     -- "C_TDO" in Bank 67-68
    DCFEB_DONE     : in  std_logic_vector(7 downto 1);     -- "DONE_?" in Bank 68
    RESYNC_P       : out std_logic;                        -- Bank 66
    RESYNC_N       : out std_logic;                        -- Bank 66
    BC0_P          : out std_logic;                        -- Bank 68
    BC0_N          : out std_logic;                        -- Bank 68
    INJPLS_P       : out std_logic;                        -- Bank 66, ODMB CTRL
    INJPLS_N       : out std_logic;                        -- Bank 66, ODMB CTRL
    EXTPLS_P       : out std_logic;                        -- Bank 66, ODMB CTRL
    EXTPLS_N       : out std_logic;                        -- Bank 66, ODMB CTRL
    L1A_P          : out std_logic;                        -- Bank 66, ODMB CTRL
    L1A_N          : out std_logic;                        -- Bank 66, ODMB CTRL
    L1A_MATCH_P    : out std_logic_vector(7 downto 1);     -- Bank 66, ODMB CTRL
    L1A_MATCH_N    : out std_logic_vector(7 downto 1);     -- Bank 66, ODMB CTRL
    PPIB_OUT_EN_B  : out std_logic;                        -- Bank 68

    --------------------------------
    -- LVMB control/monitor signals
    --------------------------------
    LVMB_PON     : out std_logic_vector(7 downto 0);
    PON_LOAD     : out std_logic;
    PON_OE_B     : out std_logic;
    MON_LVMB_PON : in  std_logic_vector(7 downto 0);
    LVMB_CSB     : out std_logic_vector(6 downto 0);
    LVMB_SCLK    : out std_logic;
    LVMB_SDIN    : out std_logic;

    --------------------------------
    -- ODMB optical ports
    --------------------------------
    -- Acutally connected optical TX/RX signals
    DAQ_RX_P     : in std_logic_vector(10 downto 0);
    DAQ_RX_N     : in std_logic_vector(10 downto 0);
    DAQ_SPY_RX_P : in std_logic;        -- DAQ_RX_P11 or SPY_RX_P
    DAQ_SPY_RX_N : in std_logic;        -- DAQ_RX_N11 or SPY_RX_N
    B04_RX_P     : in std_logic_vector(4 downto 2); -- B04 RX, no use yet
    B04_RX_N     : in std_logic_vector(4 downto 2); -- B04 RX, no use yet
    BCK_PRS_P    : in std_logic; -- B04_RX1_P
    BCK_PRS_N    : in std_logic; -- B04_RX1_N

    SPY_TX_P     : out std_logic;        -- output to PC
    SPY_TX_N     : out std_logic;        -- output to PC
    -- DAQ_TX_P     : out std_logic_vector(4 downto 1); -- B04 TX, output to FED
    -- DAQ_TX_N     : out std_logic_vector(4 downto 1); -- B04 TX, output to FED
    DAQ_TX_P     : out std_logic_vector(4 downto 4); -- B04 TX, output to FED
    DAQ_TX_N     : out std_logic_vector(4 downto 4); -- B04 TX, output to FED

    --------------------------------
    -- Optical control signals
    --------------------------------
    DAQ_SPY_SEL    : out std_logic;      -- 0 for DAQ_RX_P/N11, 1 for SPY_RX_P/N

    RX12_I2C_ENA   : out std_logic;
    RX12_SDA       : inout std_logic;
    RX12_SCL       : inout std_logic;
    RX12_CS_B      : out std_logic;
    RX12_RST_B    : out std_logic;
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
    SPY_SD        : in std_logic;   -- Signal Detect
    SPY_TDIS      : out std_logic;  -- Transmitter Disable

    --------------------------------
    -- Essential selector/reset signals not classified yet
    --------------------------------
    KUS_DL_SEL    : out std_logic;  -- Bank 47, ODMB JTAG path select
    FPGA_SEL      : out std_logic;  -- Bank 47, clock synthesizaer control input select
    RST_CLKS_B    : out std_logic;  -- Bank 47, clock synthesizaer reset
    CCB_HARDRST_B : in std_logic;   -- Bank 45
    CCB_SOFT_RST  : in std_logic;   -- Bank 45
    ODMB_DONE     : in std_logic;   -- "DONE" in bank 66, monitor of the DONE from Bank 0

    --------------------------------
    -- Clock synthesizer I2C
    --------------------------------

    --------------------------------
    -- SYSMON ports
    --------------------------------
    SYSMON_P      : in std_logic_vector(15 downto 0);
    SYSMON_N      : in std_logic_vector(15 downto 0);
    ADC_CS_B      : out std_logic_vector(4 downto 0);
    ADC_SCK       : out std_logic;
    ADC_DIN       : out std_logic;
    ADC_DOUT      : in std_logic;

    --------------------------------
    -- Others
    --------------------------------
    LEDS_CFV      : out std_logic_vector(11 downto 0)

    );
end odmb7_dev_top;

architecture odmb_inst of odmb7_dev_top is

  constant NCFEB : integer := 7;

  component ila_gbt_exde is
    port (
      clk: in std_logic;
      probe0: in std_logic_vector(83 downto 0);
      probe1: in std_logic_vector(31 downto 0);
      probe2: in std_logic_vector(0 downto 0);
      probe3: in std_logic_vector(0 downto 0)
      );
  end component;

  component vio_gbt_exde is
    port (
      clk : in std_logic;
      probe_in0 : in std_logic_vector(0 downto 0);
      probe_in1 : in std_logic_vector(0 downto 0);
      probe_in2 : in std_logic_vector(0 downto 0);
      probe_in3 : in std_logic_vector(0 downto 0);
      probe_in4 : in std_logic_vector(0 downto 0);
      probe_in5 : in std_logic_vector(5 downto 0);
      probe_in6 : in std_logic_vector(0 downto 0);
      probe_in7 : in std_logic_vector(0 downto 0);
      probe_in8 : in std_logic_vector(0 downto 0);
      probe_in9 : in std_logic_vector(0 downto 0);
      probe_in10 : in std_logic_vector(0 downto 0);
      probe_in11 : in std_logic_vector(0 downto 0);
      probe_in12 : in std_logic_vector(0 downto 0);
      probe_in13 : in std_logic_vector(31 downto 0);
      probe_in14 : in std_logic_vector(31 downto 0);
      probe_in15 : in std_logic_vector(0 downto 0);
      probe_in16 : in std_logic_vector(0 downto 0);
      probe_in17 : in std_logic_vector(7 downto 0);
      probe_out0 : out std_logic_vector(0 downto 0);
      probe_out1 : out std_logic_vector(0 downto 0);
      probe_out2 : out std_logic_vector(1 downto 0);
      probe_out3 : out std_logic_vector(2 downto 0);
      probe_out4 : out std_logic_vector(0 downto 0);
      probe_out5 : out std_logic_vector(0 downto 0);
      probe_out6 : out std_logic_vector(0 downto 0);
      probe_out7 : out std_logic_vector(0 downto 0);
      probe_out8 : out std_logic_vector(0 downto 0);
      probe_out9 : out std_logic_vector(2 downto 0);
      probe_out10 : out std_logic_vector(0 downto 0);
      probe_out11 : out std_logic_vector(7 downto 0);
      probe_out12 : out std_logic_vector(0 downto 0);
      probe_out13 : out std_logic_vector(0 downto 0);
      probe_out14 : out std_logic_vector(0 downto 0);
      probe_out15 : out std_logic_vector(0 downto 0)
      );
  end component;

  --------------------------------------
  -- clock signals
  --------------------------------------
  signal mgtrefclk0_224 : std_logic;
  signal mgtrefclk0_225 : std_logic;
  signal mgtrefclk0_226 : std_logic;
  signal mgtrefclk1_226 : std_logic;
  signal mgtrefclk0_227 : std_logic;
  signal mgtrefclk1_227 : std_logic;
  signal sysclk625k : std_logic;
  signal sysclk1p25 : std_logic;
  signal sysclk2p5 : std_logic;
  signal sysclk10 : std_logic;
  signal sysclk20 : std_logic;
  signal sysclk40 : std_logic;
  signal sysclk80 : std_logic;
  signal cmsclk : std_logic;
  signal clk_emcclk : std_logic;
  signal clk_lfclk : std_logic;
  signal clk_gp6 : std_logic;
  signal clk_gp7 : std_logic;
  signal mgtclk1 : std_logic;
  signal mgtclk2 : std_logic;
  signal mgtclk3 : std_logic;
  signal mgtclk4 : std_logic;
  signal mgtclk5 : std_logic;
  signal mgtclk125 : std_logic;

  signal led_clkfreqs : std_logic_vector(7 downto 0);

  --------------------------------------
  -- PPIB/DCFEB signals
  --------------------------------------
  signal dcfeb_tck    : std_logic_vector (NCFEB downto 1) := (others => '0');
  signal dcfeb_tms    : std_logic := '0';
  signal dcfeb_tdi    : std_logic := '0';
  signal dcfeb_tdo    : std_logic_vector (NCFEB downto 1) := (others => '0');

  signal reset_pulse, reset_pulse_q : std_logic := '0';
  signal l1acnt_rst, l1a_reset_pulse, l1a_reset_pulse_q : std_logic := '0';
  signal l1acnt_rst_meta, l1acnt_rst_sync : std_logic := '0';
  signal premask_injpls, premask_extpls, dcfeb_injpls, dcfeb_extpls : std_logic := '0';
  signal test_bc0, pre_bc0, dcfeb_bc0, dcfeb_resync : std_logic := '0';
  signal dcfeb_l1a, masked_l1a, odmbctrl_l1a : std_logic := '0';
  signal dcfeb_l1a_match, masked_l1a_match, odmbctrl_l1a_match : std_logic_vector(NCFEB downto 1) := (others => '0');

  signal pon_rst_reg : std_logic_vector(31 downto 0) := x"00FFFFFF";
  signal pon_reset : std_logic := '0';

  signal global_reset : std_logic := '0';

  --------------------------------------
  -- SPY channel signals
  --------------------------------------
  constant SPY_SEL : std_logic := '1';
  constant SPY_DATAWIDTH : integer := 40;

  signal usrclk_spy_tx : std_logic; -- USRCLK for TX data preparation
  signal usrclk_spy_rx : std_logic; -- USRCLK for RX data readout
  signal spy_rx_n : std_logic;
  signal spy_rx_p : std_logic;
  signal spy_txready : std_logic; -- Flag for tx reset done
  signal spy_rxready : std_logic; -- Flag for rx reset done
  signal spy_txdata : std_logic_vector(SPY_DATAWIDTH-1 downto 0);  -- Data to be transmitted
  signal spy_txd_valid : std_logic;   -- Flag for tx data valid
  signal spy_txdiffctrl : std_logic_vector(3 downto 0);   -- Controls the TX voltage swing
  signal spy_loopback : std_logic_vector(2 downto 0);   -- For internal loopback tests
  signal spy_rxdata : std_logic_vector(SPY_DATAWIDTH-1 downto 0);  -- Data received
  signal spy_rxd_valid : std_logic;   -- Flag for valid data;
  signal spy_bad_rx : std_logic;   -- Flag for fiber errors;
  signal spy_prbs_type : std_logic_vector(3 downto 0);
  signal spy_prbs_tx_en : std_logic;
  signal spy_prbs_rx_en : std_logic;
  signal spy_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal spy_prbs_err_cnt : std_logic_vector(15 downto 0);
  signal spy_reset : std_logic;

  signal spy_diagout : std_logic_vector(15 downto 0);

  --------------------------------------
  -- MGT signals for FED channels
  --------------------------------------
  constant FED_NTXLINK : integer := 4;
  constant FED_NRXLINK : integer := 4;
  constant FEDTXDWIDTH : integer := 16;
  constant FEDRXDWIDTH : integer := 16;

  signal usrclk_fed_tx : std_logic; -- USRCLK for TX data preparation
  signal usrclk_fed_rx : std_logic; -- USRCLK for RX data readout
  signal fed_txdata1 : std_logic_vector(FEDTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal fed_txdata2 : std_logic_vector(FEDTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal fed_txdata3 : std_logic_vector(FEDTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal fed_txdata4 : std_logic_vector(FEDTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal fed_txd_valid : std_logic_vector(FED_NTXLINK downto 1);   -- Flag for tx valid data;
  signal fed_rxdata1 : std_logic_vector(FEDRXDWIDTH-1 downto 0);   -- Data received
  signal fed_rxdata2 : std_logic_vector(FEDRXDWIDTH-1 downto 0);   -- Data received
  signal fed_rxdata3 : std_logic_vector(FEDRXDWIDTH-1 downto 0);   -- Data received
  signal fed_rxdata4 : std_logic_vector(FEDRXDWIDTH-1 downto 0);   -- Data received
  signal fed_rxd_valid : std_logic_vector(FED_NRXLINK downto 1);   -- Flag for rx valid data;
  signal fed_bad_rx : std_logic_vector(FED_NRXLINK downto 1);   -- Flag for fiber errors;
  signal fed_rxready : std_logic; -- Flag for rx reset done
  signal fed_txready : std_logic; -- Flag for rx reset done
  signal fed_reset : std_logic;

  signal fed_prbs_tx_en : std_logic_vector(4 downto 1);
  signal fed_prbs_rx_en : std_logic_vector(4 downto 1);
  signal fed_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal fed_prbs_err_cnt : std_logic_vector(15 downto 0);

  --------------------------------------
  -- MGT signals for DCFEB RX channels
  --------------------------------------
  signal usrclk_mgtc : std_logic;
  signal dcfeb_rxdata : t_twobyte_arr(NCFEB downto 1);  -- Data received
  signal dcfeb_rxd_valid : std_logic_vector(NCFEB downto 1);   -- Flag for valid data;
  signal dcfeb_crc_valid : std_logic_vector(NCFEB downto 1);   -- Flag for valid data;
  signal dcfeb_bad_rx : std_logic_vector(NCFEB downto 1);   -- Flag for fiber errors;
  signal dcfeb_rxready : std_logic; -- Flag for rx reset done
  signal mgtc_reset : std_logic;

  signal dcfeb_prbs_rx_en : std_logic_vector(NCFEB downto 1);
  signal dcfeb_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal dcfeb_prbs_err_cnt :  std_logic_vector(15 downto 0) := (others => '0');

  -- Place holder signals for dcfeb data FIFOs
  signal dcfeb_datafifo_full : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal dcfeb_datafifo_afull : std_logic_vector(NCFEB downto 1) := (others => '0');

  -- Place holder signals for dcfeb data FIFOs
  signal dcfeb_data_fifo_full : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal dcfeb_data_fifo_afull : std_logic_vector(NCFEB downto 1) := (others => '0');

  --=========================--
  -- GBT Bank example design --
  --=========================--

  constant NUM_LINKS             : integer := 1;
  constant TX_OPTIMIZATION       : integer := 0;   -- 0: STANDARD, 1: LATENCY_OPTIMZED
  constant RX_OPTIMIZATION       : integer := 0;   -- 0: STANDARD, 1: LATENCY_OPTIMZED
  constant TX_ENCODING           : integer := 0;   -- 0: GBT_FRAME, 1: WIDE_BUS, 2: GBT_DYNAMIC
  constant RX_ENCODING           : integer := 0;   -- 0: GBT_FRAME, 1: WIDE_BUS, 2: GBT_DYNAMIC
  constant CLOCKING_SCHEME       : integer := 1;   -- 0: BC_CLOCK, 1: FULL_MGTFREQ

  signal txFrameClk_from_txPll                      : std_logic;
  --------------------------------------------------
  signal reset_from_genRst                          : std_logic;
  signal txPllReset                                 : std_logic;
  -- signal resetgbtfpga_from_jtag                     : std_logic;
  signal resetgbtfpga_from_vio                      : std_logic;
  signal generalReset_from_user                     : std_logic;
  signal manualResetTx_from_user                    : std_logic;
  signal manualResetRx_from_user                    : std_logic;
  signal clkMuxSel_from_user                        : std_logic;
  signal testPatterSel_from_user                    : std_logic_vector(1 downto 0);
  signal loopBack_from_user                         : std_logic_vector(2 downto 0);
  signal resetDataErrorSeenFlag_from_user           : std_logic;
  signal resetGbtRxReadyLostFlag_from_user          : std_logic;
  signal txIsDataSel_from_user                      : std_logic;
  --------------------------------------------------
  signal debug_clk_alignment_debug                  : std_logic_vector(2 downto 0);
  signal txFrameClk_from_gbtExmplDsgn               : std_logic;
  signal txWordClk_from_gbtExmplDsgn                : std_logic;
  signal rxFrameClk_from_gbtExmplDsgn               : std_logic;
  signal rxWordClk_from_gbtExmplDsgn                : std_logic;
  signal txMatchFlag_from_gbtExmplDsgn              : std_logic;
  signal rxMatchFlag_from_gbtExmplDsgn              : std_logic;
  -- signal latOptGbtBankTx_from_gbtExmplDsgn          : std_logic;
  -- signal latOptGbtBankRx_from_gbtExmplDsgn          : std_logic;
  signal txFrameClkPllLocked_from_gbtExmplDsgn      : std_logic;
  signal mgtReady_from_gbtExmplDsgn                 : std_logic;
  signal rxFrameClkReady_from_gbtExmplDsgn          : std_logic;
  signal gbtRxReady_from_gbtExmplDsgn               : std_logic;
  signal rxIsData_from_gbtExmplDsgn                 : std_logic;
  signal gbtRxReadyLostFlag_from_gbtExmplDsgn       : std_logic;
  signal rxDataErrorSeen_from_gbtExmplDsgn          : std_logic;
  signal rxExtrDataWidebusErSeen_from_gbtExmplDsgn  : std_logic;
  signal rxBitSlipRstCount_from_gbtExmplDsgn        : std_logic_vector(7 downto 0);
  signal rxBitSlipRstOnEven_from_user               : std_logic;
  --------------------------------------------------
  signal vioControl_from_icon                       : std_logic_vector(35 downto 0);
  signal txIlaControl_from_icon                     : std_logic_vector(35 downto 0);
  signal rxIlaControl_from_icon                     : std_logic_vector(35 downto 0);
  signal gbtErrorDetected                           : std_logic;
  signal modifiedBitsCnt                            : std_logic_vector(7 downto 0);
  signal countWordReceived                          : std_logic_vector(31 downto 0);
  signal countBitsModified                          : std_logic_vector(31 downto 0);
  signal countWordErrors                            : std_logic_vector(31 downto 0);
  signal gbtModifiedBitFlagFiltered                 : std_logic_vector(127 downto 0);
  signal gbtModifiedBitFlag                         : std_logic_vector(83 downto 0);
  --------------------------------------------------
  signal txData_from_gbtExmplDsgn                   : std_logic_vector(83 downto 0);
  signal rxData_from_gbtExmplDsgn                   : std_logic_vector(83 downto 0);
  signal txExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(115 downto 0);
  signal rxExtraDataWidebus_from_gbtExmplDsgn       : std_logic_vector(115 downto 0);
  --------------------------------------------------
  signal shiftTxClock_from_vio                      : std_logic;
  signal txShiftCount_from_vio                      : std_logic_vector(7 downto 0);
  signal txAligned_from_gbtbank                     : std_logic;
  signal txAlignComputed_from_gbtbank               : std_logic;
  signal txAligned_from_gbtbank_latched             : std_logic;
  --------------------------------------------------
  signal sync_from_vio                              : std_logic_vector(11 downto 0);
  signal async_to_vio                               : std_logic_vector(17 downto 0);

  signal txEncoding_from_vio              : std_logic;
  signal rxEncoding_from_vio              : std_logic;


  --======================= Signal Declarations =========================--
  --==========--
  -- GBT Tx   --
  --==========--
  signal gbt_txframeclk_s                : std_logic_vector(1 to NUM_LINKS);
  signal gbt_txreset_s                   : std_logic_vector(1 to NUM_LINKS);
  signal gbt_txready_s                   : std_logic_vector(1 to NUM_LINKS);
  signal gbt_txdata_s                    : gbt_reg84_A(1 to NUM_LINKS);
  signal wb_txdata_s                     : gbt_reg32_A(1 to NUM_LINKS);
  signal gbt_txclken_s                   : std_logic_vector(1 to NUM_LINKS);

  --==========--
  -- NGT      --
  --==========--
  signal mgt_txwordclk_s                 : std_logic_vector(1 to NUM_LINKS);
  signal mgt_rxwordclk_s                 : std_logic_vector(1 to NUM_LINKS);
  signal mgt_txreset_s                   : std_logic_vector(1 to NUM_LINKS);
  signal mgt_rxreset_s                   : std_logic_vector(1 to NUM_LINKS);
  signal mgt_txready_s                   : std_logic_vector(1 to NUM_LINKS);
  signal mgt_rxready_s                   : std_logic_vector(1 to NUM_LINKS);

  signal mgt_headerflag_s                : std_logic_vector(1 to NUM_LINKS);
  signal mgt_devspecific_to_s            : mgtDeviceSpecific_i_R;
  signal mgt_devspecific_from_s          : mgtDeviceSpecific_o_R;
  signal resetOnBitslip_s                : std_logic_vector(1 to NUM_LINKS);

  --==========--
  -- GBT Rx   --
  --==========--
  signal gbt_rxframeclk_s                : std_logic_vector(1 to NUM_LINKS);
  signal gbt_rxreset_s                   : std_logic_vector(1 to NUM_LINKS);
  signal gbt_rxready_s                   : std_logic_vector(1 to NUM_LINKS);
  signal gbt_rxdata_s                    : gbt_reg84_A(1 to NUM_LINKS);
  signal wb_rxdata_s                     : gbt_reg32_A(1 to NUM_LINKS);
  signal gbt_rxclkenLogic_s              : std_logic_vector(1 to NUM_LiNKS);

  --================================--
  -- Data pattern generator/checker --
  --================================--
  signal gbtBank_txEncodingSel           : std_logic_vector(1 downto 0);
  signal gbtBank_rxEncodingSel           : std_logic_vector(1 downto 0);
  signal txData_from_gbtBank_pattGen     : gbt_reg84_A(1 to NUM_LINKS);
  signal txwBData_from_gbtBank_pattGen   : gbt_reg32_A(1 to NUM_LINKS);


begin

  -------------------------------------------------------------------------------------------
  -- Constant driver for selector/reset pins for board to work
  -------------------------------------------------------------------------------------------
  KUS_DL_SEL <= '1';
  FPGA_SEL <= '0';
  RST_CLKS_B <= '1';
  PPIB_OUT_EN_B <= '0';

  -------------------------------------------------------------------------------------------
  -- Constant driver for firefly selector/reset pins
  -------------------------------------------------------------------------------------------
  RX12_I2C_ENA <= '0';
  RX12_CS_B <= '1';
  RX12_RST_B <= '1';
  TX12_I2C_ENA <= '0';
  TX12_CS_B <= '1';
  TX12_RST_B <= '1';
  B04_I2C_ENA <= '0';
  B04_CS_B <= '1';
  B04_RST_B <= '1';
  SPY_TDIS <= '0';

  -------------------------------------------------------------------------------------------
  -- Handle ODMB7 clocks
  -------------------------------------------------------------------------------------------
  MBK : entity work.odmb_clocking
    port map (
      CMS_CLK_FPGA_P => CMS_CLK_FPGA_P,
      CMS_CLK_FPGA_N => CMS_CLK_FPGA_N,
      GP_CLK_6_P     => GP_CLK_6_P,
      GP_CLK_6_N     => GP_CLK_6_N,
      GP_CLK_7_P     => GP_CLK_7_P,
      GP_CLK_7_N     => GP_CLK_7_N,
      REF_CLK_1_P    => REF_CLK_1_P,
      REF_CLK_1_N    => REF_CLK_1_N,
      REF_CLK_2_P    => REF_CLK_2_P,
      REF_CLK_2_N    => REF_CLK_2_N,
      REF_CLK_3_P    => REF_CLK_3_P,
      REF_CLK_3_N    => REF_CLK_3_N,
      REF_CLK_4_P    => REF_CLK_4_P,
      REF_CLK_4_N    => REF_CLK_4_N,
      REF_CLK_5_P    => REF_CLK_5_P,
      REF_CLK_5_N    => REF_CLK_5_N,
      CLK_125_REF_P  => CLK_125_REF_P,
      CLK_125_REF_N  => CLK_125_REF_N,
      EMCCLK         => EMCCLK,
      LF_CLK         => LF_CLK,

      mgtrefclk0_224 => mgtrefclk0_224,
      mgtrefclk0_225 => mgtrefclk0_225,
      mgtrefclk0_226 => mgtrefclk0_226,
      mgtrefclk1_226 => mgtrefclk1_226,
      mgtrefclk0_227 => mgtrefclk0_227,
      mgtrefclk1_227 => mgtrefclk1_227,
      clk_sysclk625k => sysclk625k,
      clk_sysclk1p25 => sysclk1p25,
      clk_sysclk2p5  => sysclk2p5,
      clk_sysclk10   => sysclk10,
      clk_sysclk20   => sysclk20,
      clk_sysclk40   => sysclk40,
      clk_sysclk80   => sysclk80,
      clk_cmsclk     => cmsclk,
      clk_emcclk     => clk_emcclk,
      clk_lfclk      => clk_lfclk,
      clk_gp6        => clk_gp6,
      clk_gp7        => clk_gp7,
      clk_mgtclk1    => open,
      clk_mgtclk2    => open,
      clk_mgtclk3    => open,
      clk_mgtclk4    => mgtclk4,
      clk_mgtclk5    => open,
      clk_mgtclk125  => mgtclk125,
      led_clkfreqs   => led_clkfreqs
      );

  LEDS_CFV(0)  <= led_clkfreqs(0);
  LEDS_CFV(2)  <= led_clkfreqs(1);
  LEDS_CFV(4)  <= led_clkfreqs(3);
  LEDS_CFV(6)  <= led_clkfreqs(4);
  LEDS_CFV(8)  <= led_clkfreqs(6);
  LEDS_CFV(10) <= led_clkfreqs(7);

  -------------------------------------------------------------------------------------------
  -- Handle PPIB/DCFEB signals
  -------------------------------------------------------------------------------------------
  -- Handle DCFEB I/O buffers
  OB_DCFEB_TMS: OBUFDS port map (I => dcfeb_tms, O => DCFEB_TMS_P, OB => DCFEB_TMS_N);
  OB_DCFEB_TDI: OBUFDS port map (I => dcfeb_tdi, O => DCFEB_TDI_P, OB => DCFEB_TDI_N);
  OB_DCFEB_INJPLS: OBUFDS port map (I => dcfeb_injpls, O => INJPLS_P, OB => INJPLS_N);
  OB_DCFEB_EXTPLS: OBUFDS port map (I => dcfeb_extpls, O => EXTPLS_P, OB => EXTPLS_N);
  OB_DCFEB_RESYNC: OBUFDS port map (I => dcfeb_resync, O => RESYNC_P, OB => RESYNC_N);
  OB_DCFEB_BC0: OBUFDS port map (I => dcfeb_bc0, O => BC0_P, OB => BC0_N);
  OB_DCFEB_L1A: OBUFDS port map (I => dcfeb_l1a, O => L1A_P, OB => L1A_N);
  GEN_DCFEBJTAG_BUFDS : for I in 1 to NCFEB generate
  begin
    OB_DCFEB_TCK: OBUFDS port map (I => dcfeb_tck(I), O => DCFEB_TCK_P(I), OB => DCFEB_TCK_N(I));
    IB_DCFEB_TDO: IBUFDS port map (O => dcfeb_tdo(I), I => DCFEB_TDO_P(I), IB => DCFEB_TDO_N(I));
    OB_DCFEB_L1A_MATCH: OBUFDS port map (I => dcfeb_l1a_match(I), O => L1A_MATCH_P(I), OB => L1A_MATCH_N(I));
  end generate GEN_DCFEBJTAG_BUFDS;


  -------------------------------------------------------------------------------------------
  -- Optical ports for the SPY channel
  -------------------------------------------------------------------------------------------
  DAQ_SPY_SEL <= SPY_SEL; -- set for constant
  spy_rx_n <= DAQ_SPY_RX_N when SPY_SEL = '1' else '0';
  spy_rx_p <= DAQ_SPY_RX_P when SPY_SEL = '1' else '0';

  genRst: entity work.xlx_ku_reset
    generic map (
      CLK_FREQ             => 125e6)
    port map (
      CLK_I                => mgtclk125,
      RESET1_B_I           => '1',
      RESET2_B_I           => not generalReset_from_user,
      RESET_O              => reset_from_genRst
      );

  generalReset_from_user  <= resetgbtfpga_from_vio or not(txFrameClkPllLocked_from_gbtExmplDsgn);

  -- Can this be optimized out?
  txFrameclkGen_inst: entity work.xlx_ku_tx_phaligner
    Port map(
      -- Reset
      RESET_IN              => txPllReset,
      -- Clocks
      CLK_IN                => mgtclk4,
      CLK_OUT               => txFrameClk_from_txPll,
      -- Control
      SHIFT_IN              => shiftTxClock_from_vio,
      SHIFT_COUNT_IN        => txShiftCount_from_vio,
      -- Status
      LOCKED_OUT            => txFrameClkPllLocked_from_gbtExmplDsgn
      );

  --========================--
  -- Data pattern generator --
  --========================--

  gbtBank_txEncodingSel <= "00"; -- when TX_ENCODING = GBT_FRAME else '0' & not(TX_ENCODING_SEL_i);

  dataGenEn_output_gen: for i in 1 to NUM_LINKS generate
    gbtBank2_pattGen: entity work.gbt_pattern_generator
      generic map(
        CLOCKING_SCHEME                                => CLOCKING_SCHEME
        )
      port map (
        GENERAL_RST_I                                  => reset_from_genRst,
        RESET_I                                        => gbt_txreset_s(i),
        TX_FRAMECLK_I                                  => txFrameClk_from_txPll,
        TX_WORDCLK_I                                   => mgt_txwordclk_s(i),

        TX_FRAMECLK_O                                  => gbt_txframeclk_s(i),
        TX_CLKEN_o                                     => gbt_txclken_s(i),

        -----------------------------------------------
        TX_ENCODING_SEL_I                              => gbtBank_txEncodingSel,
        TEST_PATTERN_SEL_I                             => testPatterSel_from_user,
        STATIC_PATTERN_SCEC_I                          => "00",
        STATIC_PATTERN_DATA_I                          => x"000BABEAC1DACDCFFFFF",
        STATIC_PATTERN_EXTRADATA_WIDEBUS_I             => x"BEEFCAFE",
        -----------------------------------------------
        TX_DATA_O                                      => txData_from_gbtBank_pattGen(i),
        TX_EXTRA_DATA_WIDEBUS_O                        => txwBData_from_gbtBank_pattGen(i)
        );

    gbt_txdata_s(i) <= txData_from_gbtBank_pattGen(i);
    wb_txdata_s(i)  <= txwBData_from_gbtBank_pattGen(i);

    gbt_txreset_s(i) <= not gbt_txready_s(i);
  end generate;

  --==========================--
  -- Data pattern checker         --
  --==========================--
  gbtBank_rxEncodingSel <= "00"; -- when RX_ENCODING = GBT_FRAME else '0' & not(RX_ENCODING_SEL_i);

  gbtBank_patCheck_gen: for i in 1 to NUM_LINKS generate
    gbtBank_pattCheck: entity work.gbt_pattern_checker
      port map (
        RESET_I                                        => reset_from_genRst,
        RX_FRAMECLK_I                                  => gbt_rxframeclk_s(i),
        RX_CLKEN_I                                     => gbt_rxclkenLogic_s(i),
        -----------------------------------------------
        RX_DATA_I                                      => gbt_rxdata_s(i),
        RX_EXTRA_DATA_WIDEBUS_I                        => wb_rxdata_s(i),
        -----------------------------------------------
        GBT_RX_READY_I                                 => gbt_rxready_s(i),
        RX_ENCODING_SEL_I                              => gbtBank_rxEncodingSel,
        TEST_PATTERN_SEL_I                             => testPatterSel_from_user,
        STATIC_PATTERN_SCEC_I                          => "00",
        STATIC_PATTERN_DATA_I                          => x"000BABEAC1DACDCFFFFF",
        STATIC_PATTERN_EXTRADATA_WIDEBUS_I             => x"BEEFCAFE",
        RESET_GBTRXREADY_LOST_FLAG_I                   => resetGbtRxReadyLostFlag_from_user,
        RESET_DATA_ERRORSEEN_FLAG_I                    => resetDataErrorSeenFlag_from_user,
        -----------------------------------------------
        GBTRXREADY_LOST_FLAG_O                         => gbtRxReadyLostFlag_from_gbtExmplDsgn,
        RXDATA_ERRORSEEN_FLAG_O                        => rxDataErrorSeen_from_gbtExmplDsgn,
        RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O           => rxExtrDataWidebusErSeen_from_gbtExmplDsgn
        );
  end generate;

  --============--
  -- Match flag --
  --============--
  gbtBank_txFlag: entity work.gbt_pattern_matchflag
    PORT MAP (
      RESET_I                                           => gbt_txreset_s(1),
      CLK_I                                             => gbt_txframeclk_s(1),
      CLKEN_I                                           => gbt_txclken_s(1),
      DATA_I                                            => gbt_txdata_s(1),
      MATCHFLAG_O                                       => txMatchFlag_from_gbtExmplDsgn
      );

  gbtBank_rxFlag_gen: for i in 1 to NUM_LINKS generate
    gbtBank_rxFlag: entity work.gbt_pattern_matchflag
      PORT MAP (
        RESET_I                                           => gbt_rxreset_s(i),
        CLK_I                                             => gbt_rxframeclk_s(i),
        CLKEN_I                                           => gbt_rxclkenLogic_s(i),
        DATA_I                                            => gbt_rxdata_s(i),
        MATCHFLAG_O                                       => rxMatchFlag_from_gbtExmplDsgn
        );
  end generate;


  gbtExmplDsgn_inst : entity work.mgt_gbt
    generic map(
      NUM_LINKS                => 1
      )
    port map (

      --==============--
      -- Clocks       --
      --==============--
      MGT_REFCLK                => mgtrefclk0_225,
      GBT_FRAMECLK              => txFrameClk_from_txPll, -- 40 MHz derived from mgtrefclk0_225
      MGT_DRP_CLK               => mgtclk4,

      TX_WORDCLK_o              => mgt_txwordclk_s,
      RX_WORDCLK_o              => mgt_rxwordclk_s,
      TX_FRAMECLK_i             => gbt_txframeclk_s,
      RX_FRAMECLK_o             => gbt_rxframeclk_s,

      --==============--
      -- Serial lanes --
      --==============--
      MGT_RX_P(1)               => B04_RX_P(4),
      MGT_RX_N(1)               => B04_RX_N(4),
      MGT_TX_P(1)               => DAQ_TX_P(4),
      MGT_TX_N(1)               => DAQ_TX_N(4),

      --==============--
      -- Data         --
      --==============--
      GBT_TXDATA_i(1)           => gbt_txdata_s(1),
      GBT_RXDATA_o(1)           => gbt_rxdata_s(1), -- rxData_from_gbtExmplDsgn, -- to ILA
      WB_TXDATA_i(1)            => wb_txdata_s(1),
      WB_RXDATA_o(1)            => wb_rxdata_s(1),  -- rxExtraDataWidebus_from_gbtExmplDsgn, -- to ILA

      TXD_VALID_i(1)            => txIsDataSel_from_user,   -- from VIO
      RXD_VALID_o(1)            => rxIsData_from_gbtExmplDsgn, -- to VIO

      --==============--
      -- TX/RX Status --
      --==============--
      MGT_TXREADY_o             => mgt_txready_s,
      MGT_RXREADY_o             => mgt_rxready_s,
      GBT_TXREADY_o             => gbt_txready_s,
      GBT_RXREADY_o             => gbt_rxready_s,
      GBT_BAD_RX_o(1)           => gbtErrorDetected,           -- count BER

      --==============--
      -- Keep for now --
      --==============--
      GBTBANK_RXFRAMECLK_ALIGNPATTER_I  => debug_clk_alignment_debug,         -- from VIO
      GBTBANK_TX_ALIGNED_O(1)           => txAligned_from_gbtbank, -- latched to VIO
      GBTBANK_TX_ALIGNCOMPUTED_O(1)     => txAlignComputed_from_gbtbank, -- to VIO
      GBTBANK_RX_BITMODIFIED_FLAG_O(1)  => gbtModifiedBitFlag,         -- to count BER
      GBTBANK_LOOPBACK_I                => loopBack_from_user, -- from VIO
      RESET_TX_i                        => manualResetTx_from_user, -- from VIO
      RESET_RX_i                        => manualResetRx_from_user, -- from VIO
      GBT_TXCLKEN_i                     => gbt_txclken_s,           -- from pattern generator, to be evaluated
      GBT_RXCLKENLOGIC_o                => gbt_rxclkenLogic_s,      -- to pattern checker, to be evaluated
      RX_FRAMECLK_RDY_o(1)              => rxFrameClkReady_from_gbtExmplDsgn, -- to VIO

      --==============--
      -- Reset        --
      --==============--
      RESET_i           => reset_from_genRst
      );

  mgtReady_from_gbtExmplDsgn <= mgt_txready_s(1) and mgt_rxready_s(1);
  gbtRxReady_from_gbtExmplDsgn <= mgt_rxready_s(1) and gbt_rxready_s(1);

  --=====================================--
  -- BER                                 --
  --=====================================--
  countWordReceivedProc: PROCESS(reset_from_genRst, gbt_rxframeclk_s(1))
  begin

    if reset_from_genRst = '1' then
      countWordReceived <= (others => '0');
      countBitsModified <= (others => '0');
      countWordErrors    <= (others => '0');

    elsif rising_edge(gbt_rxframeclk_s(1)) then
      if gbtRxReady_from_gbtExmplDsgn = '1' then

        if gbtErrorDetected = '1' then
          countWordErrors    <= std_logic_vector(unsigned(countWordErrors) + 1 );
        end if;

        countWordReceived <= std_logic_vector(unsigned(countWordReceived) + 1 );
      end if;

      countBitsModified <= std_logic_vector(unsigned(modifiedBitsCnt) + unsigned(countBitsModified) );
    end if;
  end process;

  gbtModifiedBitFlagFiltered(127 downto 84) <= (others => '0');
  gbtModifiedBitFlagFiltered(83 downto 0) <= gbtModifiedBitFlag when gbtRxReady_from_gbtExmplDsgn = '1' else
                                             (others => '0');

  countOnesCorrected: entity work.CountOnes
    Generic map (
      SIZE           => 128,
      MAXOUTWIDTH    => 8
      )
    Port map(
      Clock    => gbt_rxframeclk_s(1), -- Warning: Because the enable signal (1 over 3 or 6 clock cycle) is not used, the number of error is multiplied by 3 or 6.
      I        => gbtModifiedBitFlagFiltered,
      O        => modifiedBitsCnt
      );

  vio_gbt_inst : vio_gbt_exde
    port map (
      clk => mgtclk125,

      probe_in0(0) => rxIsData_from_gbtExmplDsgn,
      probe_in1(0) => txFrameClkPllLocked_from_gbtExmplDsgn,
      probe_in2(0) => mgt_rxready_s(1),
      probe_in3(0) => mgtReady_from_gbtExmplDsgn,
      probe_in4(0) => gbt_rxready_s(1),
      probe_in5    => spy_diagout(5 downto 0),
      probe_in6(0) => rxFrameClkReady_from_gbtExmplDsgn,
      probe_in7(0) => gbtRxReady_from_gbtExmplDsgn,
      probe_in8(0) => gbtRxReadyLostFlag_from_gbtExmplDsgn,
      probe_in9(0) => rxDataErrorSeen_from_gbtExmplDsgn,
      probe_in10(0) => rxExtrDataWidebusErSeen_from_gbtExmplDsgn,
      probe_in11(0) => '0',
      probe_in12(0) => '1',
      probe_in13    => countBitsModified,
      probe_in14    => countWordReceived,
      probe_in15(0)    => txAligned_from_gbtbank_latched,
      probe_in16(0)    => txAlignComputed_from_gbtbank,
      probe_in17       => x"00",
      probe_out0(0) => resetgbtfpga_from_vio,
      probe_out1(0) => clkMuxSel_from_user,
      probe_out2 => testPatterSel_from_user,
      probe_out3 => loopBack_from_user,
      probe_out4(0) => resetDataErrorSeenFlag_from_user,
      probe_out5(0) => resetGbtRxReadyLostFlag_from_user,
      probe_out6(0) => txIsDataSel_from_user,
      probe_out7(0) => manualResetTx_from_user,
      probe_out8(0) => manualResetRx_from_user,
      probe_out9    => debug_clk_alignment_debug,
      probe_out10(0) => shiftTxClock_from_vio,
      probe_out11    => txShiftCount_from_vio,
      probe_out12(0) => rxBitSlipRstOnEven_from_user,
      probe_out13(0) => txPllReset,
      probe_out14(0) => txEncoding_from_vio,
      probe_out15(0) => rxEncoding_from_vio
      );


  ila_tx_inst : ila_gbt_exde
    port map (
      clk => sysclk80,                  -- original 300 MHz
      probe0 => gbt_txdata_s(1),
      probe1 => wb_txdata_s(1),
      probe2(0) => txIsDataSel_from_user,
      probe3(0) => '0'
      );

  ila_rx_inst : ila_gbt_exde
    port map (
      clk => sysclk80,                  -- original 300 MHz
      probe0 => gbt_rxdata_s(1),
      probe1 => wb_rxdata_s(1),
      probe2(0) => rxIsData_from_gbtExmplDsgn,
      probe3(0) => gbtErrorDetected
      );

  alignmenetLatchProc: process(txFrameClk_from_txPll)
  begin

    if reset_from_genRst = '1' then
      txAligned_from_gbtbank_latched <= '0';

    elsif rising_edge(txFrameClk_from_txPll) then

      if txAlignComputed_from_gbtbank = '1' then
        txAligned_from_gbtbank_latched <= txAligned_from_gbtbank;
      end if;

    end if;
  end process;


  GTH_spy : entity work.mgt_spy
    generic map (
      DATAWIDTH       => 40
      )
    port map (
      mgtrefclk       => mgtrefclk0_226, -- for 1.6 Gb/s DDU transmission, mgtrefclk1_226 is sourced from the 125 MHz crystal
      txusrclk        => usrclk_spy_tx,  -- 80 MHz for 1.6 Gb/s with 8b/10b encoding, 62.5 MHz for 1.25 Gb/s
      rxusrclk        => usrclk_spy_rx,
      sysclk          => cmsclk,    -- maximum DRP clock frequency 62.5 MHz for 1.25 Gb/s line rate
      spy_rx_n        => spy_rx_n,
      spy_rx_p        => spy_rx_p,
      spy_tx_n        => SPY_TX_N,
      spy_tx_p        => SPY_TX_P,
      txready         => spy_txready,
      rxready         => spy_rxready,
      txdata          => spy_txdata,
      txd_valid       => spy_txd_valid,
      txdiffctrl      => spy_txdiffctrl,
      loopback        => spy_loopback,
      rxdata          => spy_rxdata,
      rxd_valid       => spy_rxd_valid,
      bad_rx          => spy_bad_rx,
      prbs_type       => spy_prbs_type,
      prbs_tx_en      => spy_prbs_tx_en,
      prbs_rx_en      => spy_prbs_rx_en,
      prbs_tst_cnt    => spy_prbs_tst_cnt,
      prbs_err_cnt    => spy_prbs_err_cnt,
      diagout         => spy_diagout,
      reset           => resetgbtfpga_from_vio
      );

  -------------------------------------------------------------------------------------------
  -- SYSMON module instantiation
  -------------------------------------------------------------------------------------------
  sysmone1_inst : SYSMONE1
    port map (
      ALM => open,
      OT => open,
      DO => open,
      DRDY => open,
      BUSY => open,
      CHANNEL => open,
      EOC => open,
      EOS => open,
      JTAGBUSY => open,
      JTAGLOCKED => open,
      JTAGMODIFIED => open,
      MUXADDR => open,
      VAUXN => SYSMON_N, -- 16 bits AD[0-15]N
      VAUXP => SYSMON_P, -- 16 bits AD[0-15]P
      CONVST => '0',
      CONVSTCLK => '0',
      RESET => '0',
      VN => '0',
      VP => '0',
      DADDR => X"00",
      DCLK => '0',
      DEN => '0',
      DI => X"0000",
      DWE => '0',
      I2C_SCLK => '0',
      I2C_SDA => '0'
      );

end odmb_inst;
