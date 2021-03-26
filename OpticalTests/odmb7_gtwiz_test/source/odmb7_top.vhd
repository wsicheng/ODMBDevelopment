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

library unisim;
use unisim.vcomponents.all;

entity odmb7_dev_top is
  -- generic (
  --   NCFEB       : integer range 1 to 7 := 7  -- Number of DCFEBS, 7 for ME1/1, 5
  -- );
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

    DCFEB_TCK_P    : out std_logic_vector(NCFEB downto 1); -- Bank 68
    DCFEB_TCK_N    : out std_logic_vector(NCFEB downto 1); -- Bank 68
    DCFEB_TMS_P    : out std_logic;                        -- Bank 68
    DCFEB_TMS_N    : out std_logic;                        -- Bank 68
    DCFEB_TDI_P    : out std_logic;                        -- Bank 68
    DCFEB_TDI_N    : out std_logic;                        -- Bank 68
    DCFEB_TDO_P    : in  std_logic_vector(NCFEB downto 1); -- "C_TDO" in Bank 67-68
    DCFEB_TDO_N    : in  std_logic_vector(NCFEB downto 1); -- "C_TDO" in Bank 67-68
    DCFEB_DONE     : in  std_logic_vector(NCFEB downto 1); -- "DONE_?" in Bank 68
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
    L1A_MATCH_P    : out std_logic_vector(NCFEB downto 1); -- Bank 66, ODMB CTRL
    L1A_MATCH_N    : out std_logic_vector(NCFEB downto 1); -- Bank 66, ODMB CTRL
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
    DAQ_TX_P     : out std_logic_vector(4 downto 1); -- B04 TX, output to FED
    DAQ_TX_N     : out std_logic_vector(4 downto 1); -- B04 TX, output to FED

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

  component odmb7_clocking is
    port (
      -- Input ports
      CMS_CLK_FPGA_P : in std_logic;    -- system clock: 40.07897 MHz
      CMS_CLK_FPGA_N : in std_logic;    -- system clock: 40.07897 MHz
      GP_CLK_6_P     : in std_logic;    -- clock synthesizer ODIV6: 80 MHz
      GP_CLK_6_N     : in std_logic;    -- clock synthesizer ODIV6: 80 MHz
      GP_CLK_7_P     : in std_logic;    -- clock synthesizer ODIV7: 80 MHz
      GP_CLK_7_N     : in std_logic;    -- clock synthesizer ODIV7: 80 MHz
      REF_CLK_1_P    : in std_logic;    -- refclk0 to 224
      REF_CLK_1_N    : in std_logic;    -- refclk0 to 224
      REF_CLK_2_P    : in std_logic;    -- refclk0 to 227
      REF_CLK_2_N    : in std_logic;    -- refclk0 to 227
      REF_CLK_3_P    : in std_logic;    -- refclk0 to 226
      REF_CLK_3_N    : in std_logic;    -- refclk0 to 226
      REF_CLK_4_P    : in std_logic;    -- refclk0 to 225
      REF_CLK_4_N    : in std_logic;    -- refclk0 to 225
      REF_CLK_5_P    : in std_logic;    -- refclk1 to 227
      REF_CLK_5_N    : in std_logic;    -- refclk1 to 227
      CLK_125_REF_P  : in std_logic;    -- refclk1 to 226
      CLK_125_REF_N  : in std_logic;    -- refclk1 to 226
      EMCCLK         : in std_logic;    -- Low frequency, 133 MHz for SPI programing clock
      LF_CLK         : in std_logic;    -- Low frequency, 10 kHz

      -- Output clocks
      mgtrefclk0_224 : out std_logic;   -- MGT refclk for GT wizard
      mgtrefclk0_225 : out std_logic;   -- MGT refclk for GT wizard
      mgtrefclk0_226 : out std_logic;   -- MGT refclk for GT wizard
      mgtrefclk1_226 : out std_logic;   -- MGT refclk for GT wizard
      mgtrefclk0_227 : out std_logic;   -- MGT refclk for GT wizard
      mgtrefclk1_227 : out std_logic;   -- MGT refclk for GT wizard
      clk_sysclk10   : out std_logic;
      clk_sysclk40   : out std_logic;
      clk_sysclk80   : out std_logic;
      clk_cmsclk     : out std_logic;
      clk_emcclk     : out std_logic;   -- buffed EMC clokc
      clk_lfclk      : out std_logic;   -- buffed LF clokc
      clk_gp6        : out std_logic;
      clk_gp7        : out std_logic;
      clk_mgtclk1    : out std_logic;   -- buffed ODIV2 port of the refclks
      clk_mgtclk2    : out std_logic;   -- buffed ODIV2 port of the refclks
      clk_mgtclk3    : out std_logic;   -- buffed ODIV2 port of the refclks
      clk_mgtclk4    : out std_logic;   -- buffed ODIV2 port of the refclks
      clk_mgtclk5    : out std_logic;   -- buffed ODIV2 port of the refclks
      clk_mgtclk125  : out std_logic    -- buffed ODIV2 port of the refclks
      );
  end component;

  component mgt_spy is
    port (
      mgtrefclk       : in  std_logic; -- buffer'ed reference clock signal
      txusrclk        : out std_logic; -- USRCLK for TX data preparation
      rxusrclk        : out std_logic; -- USRCLK for RX data readout
      sysclk          : in  std_logic; -- clock for the helper block, 80 MHz
      spy_rx_n        : in  std_logic;
      spy_rx_p        : in  std_logic;
      spy_tx_n        : out std_logic;
      spy_tx_p        : out std_logic;
      txready         : out std_logic; -- Flag for tx reset done
      rxready         : out std_logic; -- Flag for rx reset done
      txdata          : in std_logic_vector(15 downto 0);  -- Data to be transmitted
      txd_valid       : in std_logic;   -- Flag for tx data valid
      txdiffctrl      : in std_logic_vector(3 downto 0);   -- Controls the TX voltage swing
      loopback        : in std_logic_vector(2 downto 0);   -- For internal loopback tests
      rxdata          : out std_logic_vector(15 downto 0);  -- Data received
      rxd_valid       : out std_logic;   -- Flag for valid data;
      bad_rx          : out std_logic;   -- Flag for fiber errors;
      prbs_type       : in  std_logic_vector(3 downto 0);
      prbs_tx_en      : in  std_logic;
      prbs_rx_en      : in  std_logic;
      prbs_tst_cnt    : in  std_logic_vector(15 downto 0);
      prbs_err_cnt    : out std_logic_vector(15 downto 0);
      reset           : in  std_logic
      );
  end component;

  component mgt_alct is
    generic (
      NLINK : integer range 1 to 5 := 1;   -- number of links
      DATAWIDTH : integer := 16            -- user data width
      );
    port (
      mgtrefclk       : in  std_logic; -- buffer'ed reference clock signal
      rxusrclk        : out std_logic; -- USRCLK for RX data readout
      sysclk          : in  std_logic; -- clock for the helper block, 80 MHz
      daq_rx_n        : in  std_logic;
      daq_rx_p        : in  std_logic;
      rxready         : out std_logic; -- Flag for rx reset done
      rxdata          : out std_logic_vector(15 downto 0);  -- Data received
      rxd_valid       : out std_logic;   -- Flag for valid data;
      bad_rx          : out std_logic;   -- Flag for fiber errors;
      prbs_type       : in  std_logic_vector(3 downto 0);
      prbs_rx_en      : in  std_logic;
      prbs_tst_cnt    : in  std_logic_vector(15 downto 0);
      prbs_err_cnt    : out std_logic_vector(15 downto 0);
      reset           : in  std_logic
      );
  end component;

  component mgt_cfeb is
    generic (
      NLINK     : integer range 1 to 20 := 7;  -- number of links
      DATAWIDTH : integer := 16                -- user data width
      );
    port (
      mgtrefclk    : in  std_logic; -- buffer'ed reference clock signal
      rxusrclk     : out std_logic; -- USRCLK for RX data readout
      sysclk       : in  std_logic; -- clock for the helper block, 80 MHz
      daq_rx_n     : in  std_logic_vector(NLINK-1 downto 0);
      daq_rx_p     : in  std_logic_vector(NLINK-1 downto 0);
      rxdata_feb1  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxdata_feb2  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxdata_feb3  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxdata_feb4  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxdata_feb5  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxdata_feb6  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxdata_feb7  : out std_logic_vector(DATAWIDTH-1 downto 0);  -- Data received
      rxd_valid    : out std_logic_vector(NLINK downto 1);   -- Flag for valid data
      crc_valid    : out std_logic_vector(NLINK downto 1);   -- Flag for valid CRC
      bad_rx       : out std_logic_vector(NLINK downto 1);   -- Flag for fiber errors
      rxready      : out std_logic;                          -- Flag for rx reset done
      fifo_full    : in  std_logic_vector(NLINK downto 1);   -- Flag for FIFO full
      fifo_afull   : in  std_logic_vector(NLINK downto 1);   -- Flag for FIFO almost full
      prbs_type    : in  std_logic_vector(3 downto 0);
      prbs_rx_en   : in  std_logic_vector(NLINK downto 1);
      prbs_tst_cnt : in  std_logic_vector(15 downto 0);
      prbs_err_cnt : out std_logic_vector(15 downto 0);
      reset        : in  std_logic
      );
  end component;

  component mgt_ddu is
    generic (
      NCHANNL     : integer range 1 to 4 := 4;  -- number of (firmware) channels (max of TX/RX links)
      NRXLINK     : integer range 1 to 4 := 4;  -- number of (physical) RX links
      NTXLINK     : integer range 1 to 4 := 4;  -- number of (physical) TX links
      TXDATAWIDTH : integer := 16;              -- transmitter user data width
      RXDATAWIDTH : integer := 16               -- receiver user data width
      );
    port (
      mgtrefclk    : in  std_logic; -- buffer'ed reference clock signal
      txusrclk     : out std_logic; -- USRCLK for TX data readout
      rxusrclk     : out std_logic; -- USRCLK for RX data readout
      sysclk       : in  std_logic; -- clock for the helper block, 80 MHz
      daq_tx_n     : out std_logic_vector(NTXLINK-1 downto 0);
      daq_tx_p     : out std_logic_vector(NTXLINK-1 downto 0);
      bck_rx_n     : in  std_logic; -- for back pressure / loopback
      bck_rx_p     : in  std_logic; -- for back pressure / loopback
      b04_rx_n     : in  std_logic_vector(3 downto 1); -- for back pressure / loopback
      b04_rx_p     : in  std_logic_vector(3 downto 1); -- for back pressure / loopback
      txdata_ch0   : in std_logic_vector(TXDATAWIDTH-1 downto 0);  -- Data received
      txdata_ch1   : in std_logic_vector(TXDATAWIDTH-1 downto 0);  -- Data received
      txdata_ch2   : in std_logic_vector(TXDATAWIDTH-1 downto 0);  -- Data received
      txdata_ch3   : in std_logic_vector(TXDATAWIDTH-1 downto 0);  -- Data received
      txd_valid    : in std_logic_vector(NTXLINK downto 1);   -- Flag for valid data;
      rxdata_ch0   : out std_logic_vector(RXDATAWIDTH-1 downto 0);  -- Data received
      rxdata_ch1   : out std_logic_vector(RXDATAWIDTH-1 downto 0);  -- Data received
      rxdata_ch2   : out std_logic_vector(RXDATAWIDTH-1 downto 0);  -- Data received
      rxdata_ch3   : out std_logic_vector(RXDATAWIDTH-1 downto 0);  -- Data received
      rxd_valid    : out std_logic_vector(NRXLINK downto 1);   -- Flag for valid data;
      bad_rx       : out std_logic_vector(NRXLINK downto 1);   -- Flag for fiber errors;
      rxready      : out std_logic; -- Flag for rx reset done
      txready      : out std_logic; -- Flag for tx reset done
      prbs_type    : in  std_logic_vector(3 downto 0);
      prbs_rx_en   : in  std_logic_vector(NRXLINK downto 1);
      prbs_tst_cnt : in  std_logic_vector(15 downto 0);
      prbs_err_cnt : out std_logic_vector(15 downto 0);
      reset        : in  std_logic
      );
  end component;

  component prbs_tester is
    generic (
      DDU_NRXLINK  : integer := 1;
      SPYDATAWIDTH : integer := 16;
      FEBDATAWIDTH : integer := 16;
      DDUTXDWIDTH  : integer := 32;
      DDURXDWIDTH  : integer := 16;
      SPY_PATTERN  : integer := 0;        -- 0 for PRBS, 1 for counter
      DDU_PATTERN  : integer := 0         -- 0 for PRBS, 1 for counter
      );
    port (
      sysclk         : in std_logic; -- sysclk
      -- Pattern generation and checking for SPY channel
      usrclk_spy_tx  : in std_logic; -- USRCLK for SPY TX data generation
      txdata_spy     : out std_logic_vector(SPYDATAWIDTH-1 downto 0); -- PRBS data out
      txd_valid_spy  : out std_logic;
      usrclk_spy_rx  : in std_logic;  -- USRCLK for SPY RX data readout
      rxdata_spy     : in std_logic_vector(SPYDATAWIDTH-1 downto 0); -- PRBS data out
      rxd_valid_spy  : in std_logic;
      rxready_spy    : in std_logic; -- Flag for rx reset done
      -- Pattern generation for mgt_ddu
      usrclk_ddu_tx  : in std_logic; -- USRCLK for SPY TX data generation
      txdata_ddu1    : out std_logic_vector(DDUTXDWIDTH-1 downto 0); -- PRBS data out
      txdata_ddu2    : out std_logic_vector(DDUTXDWIDTH-1 downto 0); -- PRBS data out
      txdata_ddu3    : out std_logic_vector(DDUTXDWIDTH-1 downto 0); -- PRBS data out
      txdata_ddu4    : out std_logic_vector(DDUTXDWIDTH-1 downto 0); -- PRBS data out
      txd_valid_ddu  : out std_logic_vector(4 downto 1);
      -- Pattern checking for mgt_ddu
      usrclk_ddu_rx  : in std_logic;  -- USRCLK for DDU RX data readout
      rxdata_ddu1    : in std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
      rxdata_ddu2    : in std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
      rxdata_ddu3    : in std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
      rxdata_ddu4    : in std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
      rxd_valid_ddu  : in std_logic_vector(DDU_NRXLINK downto 1);
      rxready_ddu    : in std_logic; -- Flag for rx reset done
      -- Receiver signals for mgt_cfeb
      usrclk_mgtc    : in std_logic; -- USRCLK for RX data readout
      rxdata_cfeb1   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_cfeb2   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_cfeb3   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_cfeb4   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_cfeb5   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_cfeb6   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_cfeb7   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxd_valid_mgtc : in std_logic_vector(7 downto 1);   -- Flag for valid data;
      rxready_mgtc   : in std_logic; -- Flag for rx reset done
      -- Receiver signals for mgt_alct
      usrclk_mgta    : in std_logic; -- USRCLK for RX data readout
      rxdata_alct    : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxd_valid_alct : in std_logic;
      rxready_alct   : in std_logic; -- Flag for rx reset done
      rxdata_daq8    : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_daq9    : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      rxdata_daq10   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
      mgta_dvalid    : in std_logic_vector(4 downto 1);   -- Flag for valid data;
      -- LED indicator
      led_out       : out std_logic_vector(7 downto 0);
      -- Reset
      reset         : out std_logic
      );
  end component;

  --------------------------------------
  -- Clock signals
  --------------------------------------
  signal mgtrefclk0_224 : std_logic;
  signal mgtrefclk0_225 : std_logic;
  signal mgtrefclk0_226 : std_logic;
  signal mgtrefclk1_226 : std_logic;
  signal mgtrefclk0_227 : std_logic;
  signal mgtrefclk1_227 : std_logic;
  signal gth_sysclk_i : std_logic;
  signal clk_sysclk10 : std_logic;
  signal clk_sysclk40 : std_logic;
  signal clk_sysclk80 : std_logic;
  signal clk_cmsclk : std_logic;
  signal clk_emcclk : std_logic;
  signal clk_lfclk : std_logic;
  signal clk_gp6 : std_logic;
  signal clk_gp7 : std_logic;
  signal clk_mgtclk1 : std_logic;
  signal clk_mgtclk2 : std_logic;
  signal clk_mgtclk3 : std_logic;
  signal clk_mgtclk4 : std_logic;
  signal clk_mgtclk5 : std_logic;
  signal clk_mgtclk125 : std_logic;

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

  -- signals to generate dcfeb_initjtag when DCFEBs are done programming
  signal pon_rst_reg : std_logic_vector(31 downto 0) := x"00FFFFFF";
  signal pon_reset : std_logic := '0';
  signal done_cnt_en, done_cnt_rst : std_logic_vector(NCFEB downto 1);
  signal done_cnt : done_cnt_type;
  signal done_next_state, done_current_state : done_state_array_type;
  signal dcfeb_done_pulse : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal dcfeb_initjtag : std_logic := '0';
  signal dcfeb_initjtag_d : std_logic := '0';
  signal dcfeb_initjtag_dd : std_logic := '0';

  signal global_reset : std_logic := '0';

  --------------------------------------
  -- SPY channel signals
  --------------------------------------
  constant SPY_SEL : std_logic := '1';

  signal usrclk_spy_tx : std_logic; -- USRCLK for TX data preparation
  signal usrclk_spy_rx : std_logic; -- USRCLK for RX data readout
  signal spy_rx_n : std_logic;
  signal spy_rx_p : std_logic;
  signal spy_txready : std_logic; -- Flag for tx reset done
  signal spy_rxready : std_logic; -- Flag for rx reset done
  signal spy_txdata : std_logic_vector(15 downto 0);  -- Data to be transmitted
  signal spy_txd_valid : std_logic;   -- Flag for tx data valid
  signal spy_txdiffctrl : std_logic_vector(3 downto 0);   -- Controls the TX voltage swing
  signal spy_loopback : std_logic_vector(2 downto 0);   -- For internal loopback tests
  signal spy_rxdata : std_logic_vector(15 downto 0);  -- Data received
  signal spy_rxd_valid : std_logic;   -- Flag for valid data;
  signal spy_bad_rx : std_logic;   -- Flag for fiber errors;
  signal spy_prbs_type : std_logic_vector(3 downto 0);
  signal spy_prbs_tx_en : std_logic;
  signal spy_prbs_rx_en : std_logic;
  signal spy_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal spy_prbs_err_cnt : std_logic_vector(15 downto 0);
  signal spy_reset : std_logic;

  --------------------------------------
  -- MGT signals for DDU channels
  --------------------------------------
  constant DDU_NTXLINK : integer := 4;
  constant DDU_NRXLINK : integer := 4;
  constant DDUTXDWIDTH : integer := 16;
  constant DDURXDWIDTH : integer := 16;

  signal usrclk_ddu_tx : std_logic; -- USRCLK for TX data preparation
  signal usrclk_ddu_rx : std_logic; -- USRCLK for RX data readout
  signal ddu_txdata1 : std_logic_vector(DDUTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal ddu_txdata2 : std_logic_vector(DDUTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal ddu_txdata3 : std_logic_vector(DDUTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal ddu_txdata4 : std_logic_vector(DDUTXDWIDTH-1 downto 0);   -- Data to be transmitted
  signal ddu_txd_valid : std_logic_vector(DDU_NTXLINK downto 1);   -- Flag for tx valid data;
  signal ddu_rxdata1 : std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
  signal ddu_rxdata2 : std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
  signal ddu_rxdata3 : std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
  signal ddu_rxdata4 : std_logic_vector(DDURXDWIDTH-1 downto 0);   -- Data received
  signal ddu_rxd_valid : std_logic_vector(DDU_NRXLINK downto 1);   -- Flag for rx valid data;
  signal ddu_bad_rx : std_logic_vector(DDU_NRXLINK downto 1);   -- Flag for fiber errors;
  signal ddu_rxready : std_logic; -- Flag for rx reset done
  signal ddu_txready : std_logic; -- Flag for rx reset done
  signal ddu_prbs_type : std_logic_vector(3 downto 0);
  signal ddu_prbs_tx_en : std_logic_vector(DDU_NTXLINK downto 1);
  signal ddu_prbs_rx_en : std_logic_vector(DDU_NRXLINK downto 1);
  signal ddu_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal ddu_prbs_err_cnt : std_logic_vector(15 downto 0);
  signal ddu_reset : std_logic;

  --------------------------------------
  -- MGT signals for DCFEB RX channels
  --------------------------------------
  signal usrclk_mgtc : std_logic;
  signal dcfeb1_data : std_logic_vector(15 downto 0);  -- Data received
  signal dcfeb2_data : std_logic_vector(15 downto 0);  -- Data received
  signal dcfeb3_data : std_logic_vector(15 downto 0);  -- Data received
  signal dcfeb4_data : std_logic_vector(15 downto 0);  -- Data received
  signal dcfeb5_data : std_logic_vector(15 downto 0);  -- Data received
  signal dcfeb6_data : std_logic_vector(15 downto 0);  -- Data received
  signal dcfeb7_data : std_logic_vector(15 downto 0);  -- Data received
  signal mgtc_rxd_valid : std_logic_vector(NCFEB downto 1);   -- Flag for valid data;
  signal mgtc_crc_valid : std_logic_vector(NCFEB downto 1);   -- Flag for valid data;
  signal mgtc_bad_rx : std_logic_vector(NCFEB downto 1);   -- Flag for fiber errors;
  signal mgtc_rxready : std_logic; -- Flag for rx reset done
  signal mgtc_prbs_type : std_logic_vector(3 downto 0);
  signal mgtc_prbs_rx_en : std_logic_vector(NCFEB downto 1);
  signal mgtc_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal mgtc_prbs_err_cnt : std_logic_vector(15 downto 0);
  signal mgtc_reset : std_logic;

  -- Place holder signals for dcfeb data FIFOs
  signal dcfeb_data_fifo_full : std_logic_vector(NCFEB downto 1) := (others => '0');
  signal dcfeb_data_fifo_afull : std_logic_vector(NCFEB downto 1) := (others => '0');

  --------------------------------------
  -- MGT signals for ALCT RX channels
  --------------------------------------
  signal usrclk_mgta : std_logic;
  signal alct_rxdata : std_logic_vector(15 downto 0);  -- Data received
  signal alct_rxd_valid : std_logic;   -- Flag for valid data;
  signal alct_bad_rx : std_logic;   -- Flag for valid data;
  signal alct_rxready : std_logic; -- Flag for rx reset done
  signal mgta_data_valid : std_logic_vector(4 downto 1);   -- Flag for valid data;
  signal mgta_bad_rx : std_logic_vector(4 downto 1);   -- Flag for fiber errors;
  signal mgta_rxready : std_logic; -- Flag for rx reset done
  signal mgta_prbs_type : std_logic_vector(3 downto 0);
  signal mgta_prbs_rx_en : std_logic_vector(4 downto 1);
  signal mgta_prbs_tst_cnt : std_logic_vector(15 downto 0);
  signal mgta_prbs_err_cnt : std_logic_vector(15 downto 0);
  signal mgta_reset : std_logic;

  signal daq8_rxdata  : std_logic_vector(15 downto 0);  -- Data received
  signal daq9_rxdata  : std_logic_vector(15 downto 0);  -- Data received
  signal daq10_rxdata : std_logic_vector(15 downto 0);  -- Data received

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
  u_clocking : odmb7_clocking
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
      clk_sysclk10   => clk_sysclk10,
      clk_sysclk40   => clk_sysclk40,
      clk_sysclk80   => clk_sysclk80,
      clk_cmsclk     => clk_cmsclk,
      clk_emcclk     => clk_emcclk,
      clk_lfclk      => clk_lfclk,
      clk_gp6        => clk_gp6,
      clk_gp7        => clk_gp7,
      clk_mgtclk1    => clk_mgtclk1,
      clk_mgtclk2    => clk_mgtclk2,
      clk_mgtclk3    => clk_mgtclk3,
      clk_mgtclk4    => clk_mgtclk4,
      clk_mgtclk5    => clk_mgtclk5,
      clk_mgtclk125  => clk_mgtclk125
      );


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

  u_spy_gth : mgt_spy
    port map (
      mgtrefclk       => mgtrefclk1_226,
      txusrclk        => usrclk_spy_tx,
      rxusrclk        => usrclk_spy_rx,
      sysclk          => clk_cmsclk,    -- maximum DRP clock frequency 62.5 MHz for 1.25 Gb/s line rate
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
      reset           => spy_reset
      );


  u_dcfeb_gth : mgt_cfeb
    generic map (
      NLINK     => 7,  -- number of links
      DATAWIDTH => 16  -- user data width
      )
    port map (
      mgtrefclk    => mgtrefclk0_224,
      rxusrclk     => usrclk_mgtc,
      sysclk       => clk_sysclk80,
      daq_rx_n     => DAQ_RX_N(6 downto 0),
      daq_rx_p     => DAQ_RX_P(6 downto 0),
      rxdata_feb1  => dcfeb1_data,
      rxdata_feb2  => dcfeb2_data,
      rxdata_feb3  => dcfeb3_data,
      rxdata_feb4  => dcfeb4_data,
      rxdata_feb5  => dcfeb5_data,
      rxdata_feb6  => dcfeb6_data,
      rxdata_feb7  => dcfeb7_data,
      rxd_valid    => mgtc_rxd_valid,
      crc_valid    => mgtc_crc_valid,
      bad_rx       => mgtc_bad_rx,
      rxready      => mgtc_rxready,
      fifo_full    => dcfeb_data_fifo_full,
      fifo_afull   => dcfeb_data_fifo_afull,
      prbs_type    => mgtc_prbs_type,
      prbs_rx_en   => mgtc_prbs_rx_en,
      prbs_tst_cnt => mgtc_prbs_tst_cnt,
      prbs_err_cnt => mgtc_prbs_err_cnt,
      reset        => mgtc_reset
      );

  u_alct_gth : mgt_alct
    port map (
      mgtrefclk       => mgtrefclk0_225,
      rxusrclk        => usrclk_mgta,
      sysclk          => clk_sysclk80,
      daq_rx_n        => DAQ_RX_N(7),
      daq_rx_p        => DAQ_RX_P(7),
      rxready         => alct_rxready,
      rxdata          => alct_rxdata,
      rxd_valid       => alct_rxd_valid,
      bad_rx          => alct_bad_rx,
      prbs_type       => mgta_prbs_type,
      prbs_rx_en      => mgta_prbs_rx_en(1),
      prbs_tst_cnt    => mgta_prbs_tst_cnt,
      prbs_err_cnt    => mgta_prbs_err_cnt,
      reset           => mgta_reset
      );

  u_ddu_gth : mgt_ddu
    generic map (
      NCHANNL     => 4,            -- number of (firmware) channels (max of TX/RX links)
      NRXLINK     => DDU_NRXLINK,  -- number of (physical) RX links
      NTXLINK     => DDU_NTXLINK,  -- number of (physical) TX links
      TXDATAWIDTH => DDUTXDWIDTH,  -- transmitter user data width
      RXDATAWIDTH => DDURXDWIDTH   -- receiver user data width
      )
    port map (
      mgtrefclk    => mgtrefclk0_227,
      txusrclk     => usrclk_ddu_tx,
      rxusrclk     => usrclk_ddu_rx,
      sysclk       => clk_sysclk80,
      daq_tx_n     => DAQ_TX_N,
      daq_tx_p     => DAQ_TX_P,
      bck_rx_n     => BCK_PRS_N,
      bck_rx_p     => BCK_PRS_P,
      b04_rx_n     => B04_RX_N,
      b04_rx_p     => B04_RX_P,
      txdata_ch0   => ddu_txdata1,
      txdata_ch1   => ddu_txdata2,
      txdata_ch2   => ddu_txdata3,
      txdata_ch3   => ddu_txdata4,
      txd_valid    => ddu_txd_valid,
      rxdata_ch0   => ddu_rxdata1,
      rxdata_ch1   => ddu_rxdata2,
      rxdata_ch2   => ddu_rxdata3,
      rxdata_ch3   => ddu_rxdata4,
      rxd_valid    => ddu_rxd_valid,
      bad_rx       => ddu_bad_rx,
      rxready      => ddu_rxready,
      txready      => ddu_txready,
      prbs_type    => ddu_prbs_type,
      prbs_rx_en   => ddu_prbs_rx_en,
      prbs_tst_cnt => ddu_prbs_tst_cnt,
      prbs_err_cnt => ddu_prbs_err_cnt,
      reset        => ddu_reset
      );


  -------------------------------------------------------------------------------------------
  -- Tester
  -------------------------------------------------------------------------------------------
  u_mgt_tester : prbs_tester
    generic map (
      DDU_NRXLINK   => DDU_NRXLINK,
      SPYDATAWIDTH  => 16,
      FEBDATAWIDTH  => 16,
      DDUTXDWIDTH   => DDUTXDWIDTH,
      DDURXDWIDTH   => DDURXDWIDTH,
      SPY_PATTERN   => 0,
      DDU_PATTERN   => 0
      )
    port map (
      sysclk         => clk_cmsclk,
      usrclk_spy_tx  => usrclk_spy_tx,
      txdata_spy     => spy_txdata,
      txd_valid_spy  => spy_txd_valid,
      usrclk_spy_rx  => usrclk_spy_rx,
      rxdata_spy     => spy_rxdata,
      rxd_valid_spy  => spy_rxd_valid,
      rxready_spy    => spy_rxready,
      usrclk_ddu_tx  => usrclk_ddu_tx,
      txdata_ddu1    => ddu_txdata1,
      txdata_ddu2    => ddu_txdata2,
      txdata_ddu3    => ddu_txdata3,
      txdata_ddu4    => ddu_txdata4,
      txd_valid_ddu  => ddu_txd_valid,
      usrclk_ddu_rx  => usrclk_ddu_rx,
      rxdata_ddu1    => ddu_rxdata1,
      rxdata_ddu2    => ddu_rxdata2,
      rxdata_ddu3    => ddu_rxdata3,
      rxdata_ddu4    => ddu_rxdata4,
      rxd_valid_ddu  => ddu_rxd_valid,
      rxready_ddu    => ddu_rxready,
      usrclk_mgtc    => usrclk_mgtc,
      rxdata_cfeb1   => dcfeb1_data,
      rxdata_cfeb2   => dcfeb2_data,
      rxdata_cfeb3   => dcfeb3_data,
      rxdata_cfeb4   => dcfeb4_data,
      rxdata_cfeb5   => dcfeb5_data,
      rxdata_cfeb6   => dcfeb6_data,
      rxdata_cfeb7   => dcfeb7_data,
      rxd_valid_mgtc => mgtc_rxd_valid,
      rxready_mgtc   => mgtc_rxready,
      usrclk_mgta    => usrclk_mgta,
      rxdata_alct    => alct_rxdata,
      rxd_valid_alct => alct_rxd_valid,
      rxready_alct   => alct_rxready,
      rxdata_daq8    => daq8_rxdata,
      rxdata_daq9    => daq9_rxdata,
      rxdata_daq10   => daq10_rxdata,
      mgta_dvalid    => mgta_data_valid,
      led_out        => LEDS_CFV(7 downto 0),
      reset          => global_reset
      );

  mgtc_reset <= global_reset;
  mgta_reset <= global_reset;
  ddu_reset  <= global_reset;
  spy_reset  <= global_reset;

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
