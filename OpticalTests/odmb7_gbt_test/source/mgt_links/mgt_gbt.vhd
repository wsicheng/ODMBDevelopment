-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
-- use work.gbt_exampledesign_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity mgt_gbt is
  generic (
    NUM_LINKS                                    : integer := 1
    );
  port (

    --==============--
    -- Clocks       --
    --==============--
    MGT_REFCLK                                   : in  std_logic;
    GBT_FRAMECLK                                 : in  std_logic; -- 40 MHz
    MGT_DRP_CLK                                  : in  std_logic;

    TX_WORDCLK_o                                 : out std_logic_vector(1 to NUM_LINKS);
    RX_WORDCLK_o                                 : out std_logic_vector(1 to NUM_LINKS);
    TX_FRAMECLK_i                                : in  std_logic_vector(1 to NUM_LINKS); -- take input for now
    RX_FRAMECLK_o                                : out std_logic_vector(1 to NUM_LINKS);

    --==============--
    -- Serial lanes --
    --==============--
    MGT_RX_P                                     : in  std_logic_vector(1 to NUM_LINKS);
    MGT_RX_N                                     : in  std_logic_vector(1 to NUM_LINKS);
    MGT_TX_P                                     : out std_logic_vector(1 to NUM_LINKS);
    MGT_TX_N                                     : out std_logic_vector(1 to NUM_LINKS);

    --==============--
    -- Data          --
    --==============--
    GBT_TXDATA_i                                 : in  gbt_reg84_A(1 to NUM_LINKS);
    GBT_RXDATA_o                                 : out gbt_reg84_A(1 to NUM_LINKS);
    WB_TXDATA_i                                  : in  gbt_reg32_A(1 to NUM_LINKS);
    WB_RXDATA_o                                  : out gbt_reg32_A(1 to NUM_LINKS);

    TXD_VALID_i                                  : in  std_logic_vector(1 to NUM_LINKS);
    RXD_VALID_o                                  : out std_logic_vector(1 to NUM_LINKS);

    --==============--
    -- TX/RX Status --
    --==============--
    MGT_TXREADY_o                                : out std_logic_vector(1 to NUM_LINKS);
    MGT_RXREADY_o                                : out std_logic_vector(1 to NUM_LINKS);
    GBT_TXREADY_o                                : out std_logic_vector(1 to NUM_LINKS);
    GBT_RXREADY_o                                : out std_logic_vector(1 to NUM_LINKS);
    GBT_BAD_RX_o                                 : out std_logic_vector(1 to NUM_LINKS);

    --==============--
    -- Temporary    --
    --==============--
    GBTBANK_RXFRAMECLK_ALIGNPATTER_I             : in  std_logic_vector(2 downto 0);
    GBTBANK_TX_ALIGNED_O                         : out std_logic_vector(1 to NUM_LINKS);
    GBTBANK_TX_ALIGNCOMPUTED_O                   : out std_logic_vector(1 to NUM_LINKS);
    GBTBANK_RX_BITMODIFIED_FLAG_O                : out gbt_reg84_A(1 to NUM_LINKS);
    GBTBANK_RXBITSLIP_RST_CNT_O                  : out gbt_reg8_A(1 to NUM_LINKS);
    GBTBANK_LOOPBACK_I                           : in  std_logic_vector(2 downto 0);
    RESET_TX_i                                   : in  std_logic;
    RESET_RX_i                                   : in  std_logic;
    GBT_TXCLKEN_i                                : in  std_logic_vector(1 to NUM_LINKS);
    GBT_RXCLKENLOGIC_o                           : out std_logic_vector(1 to NUM_LINKS);
    RX_FRAMECLK_RDY_o                            : out std_logic_vector(1 to NUM_LINKS);

    --==============--
    -- Reset        --
    --==============--
    RESET_i                                      : in  std_logic
    );
end mgt_gbt;

--=================================================================================================--
--####################################   Architecture   ###########################################--
--=================================================================================================--

architecture mgt_gbt_inst of mgt_gbt is

  --===========--
  -- Constants --
  --===========--
  constant TX_OPTIMIZATION               : integer range 0 to 1 := STANDARD;
  constant RX_OPTIMIZATION               : integer range 0 to 1 := STANDARD;
  constant TX_ENCODING                   : integer range 0 to 2 := GBT_FRAME;
  constant RX_ENCODING                   : integer range 0 to 2 := GBT_FRAME;
  constant CLOCKING_SCHEME               : integer range 0 to 1 := 0; -- 0: BC_CLOCK, 1: FULL_MGTFREQ

  --==========--
  -- GBT Tx   --
  --==========--
  signal gbt_txframeclk_s                : std_logic_vector(1 to NUM_LINKS);
  signal gbt_txreset_s                   : std_logic_vector(1 to NUM_LINKS);
  signal gbt_txdata_s                    : gbt_reg84_A(1 to NUM_LINKS);
  signal wb_txdata_s                     : gbt_reg32_A(1 to NUM_LINKS);
  signal gbt_txclken_s                   : std_logic_vector(1 to NUM_LINKS);
  signal gbt_txencoding_s                : std_logic_vector(1 to NUM_LINKS);

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
  signal gbt_rxclken_s                   : std_logic_vector(1 to NUM_LiNKS);
  signal gbt_rxclkenLogic_s              : std_logic_vector(1 to NUM_LiNKS);
  signal gbt_rxencoding_s                : std_logic_vector(1 to NUM_LINKS);

  --=====================================================================================--

  -- Debug --
  signal ila_data_mgt                    : std_logic_vector(83 downto 0);
  -- signal ila_data0                       : std_logic_vector(83 downto 0);

  component ila_gbt_exde is
    port (
      clk: in std_logic;
      probe0: in std_logic_vector(83 downto 0);
      probe1: in std_logic_vector(31 downto 0);
      probe2: in std_logic_vector(0 downto 0);
      probe3: in std_logic_vector(0 downto 0)
      );
  end component;

--=================================================================================================--
begin                 --========####   Architecture Body   ####========--
--=================================================================================================--

  --==================================== User Logic =====================================--

  --============--
  -- Clocks     --
  --============--
  gbtBank_Clk_gen: for i in 1 to NUM_LINKS generate

    gbtBank_rxFrmClkPhAlgnr: entity work.gbt_rx_frameclk_phalgnr
      generic map(
        TX_OPTIMIZATION                           => TX_OPTIMIZATION,
        RX_OPTIMIZATION                           => RX_OPTIMIZATION,
        DIV_SIZE_CONFIG                           => 3,
        METHOD                                    => 0, -- 0: GATED_CLOCK, 1: PLL
        CLOCKING_SCHEME                           => CLOCKING_SCHEME
        )
      port map (
        RESET_I                                   => not(mgt_rxready_s(i)),

        RX_WORDCLK_I                              => mgt_rxwordclk_s(i),
        FRAMECLK_I                                => GBT_FRAMECLK,
        RX_FRAMECLK_o                             => gbt_rxframeclk_s(i),
        RX_CLKEn_o                                => gbt_rxclkenLogic_s(i),

        SYNC_I                                    => mgt_headerflag_s(i),
        CLK_ALIGN_CONFIG                          => GBTBANK_RXFRAMECLK_ALIGNPATTER_I,
        DEBUG_CLK_ALIGNMENT                       => open,

        PLL_LOCKED_O                              => open,
        DONE_O                                    => RX_FRAMECLK_RDY_O(i)
        );

    RX_FRAMECLK_o(i)    <= gbt_rxframeclk_s(i);
    gbt_txframeclk_s(i) <= TX_FRAMECLK_i(i);

    TX_WORDCLK_o(i)     <= mgt_txwordclk_s(i);
    RX_WORDCLK_o(i)     <= mgt_rxwordclk_s(i);

    gbt_rxclken_s(i)    <= mgt_headerflag_s(i) when CLOCKING_SCHEME = 1 else '1';
  end generate;

  GBT_RXCLKENLOGIC_o <= gbt_rxclkenLogic_s; -- to be evaluated

  --============--
  -- Resets     --
  --============--
  gbtBank_rst_gen: for i in 1 to NUM_LINKS generate

    gbtBank_gbtBankRst: entity work.gbt_bank_reset
      generic map (
        INITIAL_DELAY                          => 1 * 40e6   --          * 1s
        )
      port map (
        GBT_CLK_I                              => GBT_FRAMECLK,
        TX_FRAMECLK_I                          => gbt_txframeclk_s(i),
        TX_CLKEN_I                             => GBT_TXCLKEN_i(i),
        RX_FRAMECLK_I                          => gbt_rxframeclk_s(i),
        RX_CLKEN_I                             => gbt_rxclkenLogic_s(i),
        MGTCLK_I                               => MGT_DRP_CLK,

        --===============--
        -- Resets scheme --
        --===============--
        GENERAL_RESET_I                        => RESET_i,
        TX_RESET_I                             => RESET_TX_i,
        RX_RESET_I                             => RESET_RX_i,

        MGT_TX_RESET_O                         => mgt_txreset_s(i),
        MGT_RX_RESET_O                         => mgt_rxreset_s(i),
        GBT_TX_RESET_O                         => gbt_txreset_s(i),
        GBT_RX_RESET_O                         => gbt_rxreset_s(i),

        MGT_TX_RSTDONE_I                       => mgt_txready_s(i),
        MGT_RX_RSTDONE_I                       => mgt_rxready_s(i)
        );

    GBT_TXREADY_o(i) <= not(gbt_txreset_s(i));
  end generate;

  MGT_TXREADY_o <= mgt_txready_s;
  MGT_RXREADY_o <= mgt_rxready_s;
  GBT_RXREADY_o <= gbt_rxready_s;

  --=============--
  -- Transceiver --
  --=============--
  gbtBank_mgt_gen: for i in 1 to NUM_LINKS generate

    mgt_devspecific_to_s.drp_addr(i)               <= "000000000";
    mgt_devspecific_to_s.drp_en(i)                 <= '0';
    mgt_devspecific_to_s.drp_di(i)                 <= x"0000";
    mgt_devspecific_to_s.drp_we(i)                 <= '0';
    mgt_devspecific_to_s.drp_clk(i)                <= MGT_DRP_CLK;

    mgt_devspecific_to_s.prbs_txSel(i)             <= "000";
    mgt_devspecific_to_s.prbs_rxSel(i)             <= "000";
    mgt_devspecific_to_s.prbs_txForceErr(i)        <= '0';
    mgt_devspecific_to_s.prbs_rxCntReset(i)        <= '0';

    mgt_devspecific_to_s.conf_diffCtrl(i)          <= "1000";    -- Comment: 807 mVppd
    mgt_devspecific_to_s.conf_postCursor(i)        <= "00000";   -- Comment: 0.00 dB (default)
    mgt_devspecific_to_s.conf_preCursor(i)         <= "00000";   -- Comment: 0.00 dB (default)
    mgt_devspecific_to_s.conf_txPol(i)             <= '0';       -- Comment: Not inverted
    mgt_devspecific_to_s.conf_rxPol(i)             <= '0';       -- Comment: Not inverted

    mgt_devspecific_to_s.loopBack(i)               <= GBTBANK_LOOPBACK_I;

    mgt_devspecific_to_s.rx_p(i)                   <= MGT_RX_P(i);
    mgt_devspecific_to_s.rx_n(i)                   <= MGT_RX_N(i);

    mgt_devspecific_to_s.reset_freeRunningClock(i) <= MGT_DRP_CLK;

    MGT_TX_P(i)                                    <= mgt_devspecific_from_s.tx_p(i);
    MGT_TX_N(i)                                    <= mgt_devspecific_from_s.tx_n(i);

    resetOnBitslip_s(i)                            <= '1' when RX_OPTIMIZATION = LATENCY_OPTIMIZED else '0';

    gbt_txencoding_s(i)                            <= '1'; -- Not used. Select encoding in dynamic mode ('1': GBT / '0': WideBus)
    gbt_rxencoding_s(i)                            <= '1'; -- Not used. Select encoding in dynamic mode ('1': GBT / '0': WideBus)
  end generate;

  --============--
  -- GBT Bank   --
  --============--
  gbt_inst: entity work.gbt_bank
    generic map(
      NUM_LINKS                 => NUM_LINKS,
      TX_OPTIMIZATION           => TX_OPTIMIZATION,
      RX_OPTIMIZATION           => RX_OPTIMIZATION,
      TX_ENCODING               => TX_ENCODING,
      RX_ENCODING               => RX_ENCODING
      )
    port map(

      --========--
      -- Resets --
      --========--
      MGT_TXRESET_i            => mgt_txreset_s,
      MGT_RXRESET_i            => mgt_rxreset_s,
      GBT_TXRESET_i            => gbt_txreset_s,
      GBT_RXRESET_i            => gbt_rxreset_s,

      --========--
      -- Clocks --
      --========--
      MGT_CLK_i                => MGT_REFCLK,
      GBT_TXFRAMECLK_i         => gbt_txframeclk_s,
      GBT_TXCLKEn_i            => GBT_TXCLKEN_i,
      GBT_RXFRAMECLK_i         => gbt_rxframeclk_s,
      GBT_RXCLKEn_i            => gbt_rxclken_s,
      MGT_TXWORDCLK_o          => mgt_txwordclk_s,
      MGT_RXWORDCLK_o          => mgt_rxwordclk_s,

      --================--
      -- GBT TX Control --
      --================--
      GBT_ISDATAFLAG_i         => TXD_VALID_i,
      TX_ENCODING_SEL_i        => gbt_txencoding_s,    --! Select the Tx encoding in dynamic mode ('1': GBT / '0': WideBus)

      --=================--
      -- GBT TX Status   --
      --=================--
      TX_PHALIGNED_o          => GBTBANK_TX_ALIGNED_O,
      TX_PHCOMPUTED_o         => GBTBANK_TX_ALIGNCOMPUTED_O,

      --================--
      -- GBT RX Control --
      --================--
      RX_ENCODING_SEL_i        => gbt_rxencoding_s,    --! Select the Rx encoding in dynamic mode ('1': GBT / '0': WideBus)

      --=================--
      -- GBT RX Status   --
      --=================--
      GBT_RXREADY_o            => gbt_rxready_s,
      GBT_ISDATAFLAG_o         => RXD_VALID_o,
      GBT_ERRORDETECTED_o      => GBT_BAD_RX_o,
      GBT_ERRORFLAG_o          => GBTBANK_RX_BITMODIFIED_FLAG_O,

      --================--
      -- MGT Control    --
      --================--
      MGT_DEVSPECIFIC_i        => mgt_devspecific_to_s,
      MGT_RSTONBITSLIPEn_i     => resetOnBitslip_s,
      MGT_RSTONEVEN_i          => (others => '0'),

      --=================--
      -- MGT Status      --
      --=================--
      MGT_TXREADY_o            => mgt_txready_s, --GBTBANK_LINK_TX_READY_O,
      MGT_RXREADY_o            => mgt_rxready_s, --GBTBANK_LINK_RX_READY_O,
      MGT_DEVSPECIFIC_o        => mgt_devspecific_from_s,
      MGT_HEADERFLAG_o         => mgt_headerflag_s,
      MGT_HEADERLOCKED_o       => open,
      MGT_RSTCNT_o             => GBTBANK_RXBITSLIP_RST_CNT_O,

      ILA_DATA_o               => ila_data_mgt,

      --========--
      -- Data   --
      --========--
      GBT_TXDATA_i             => GBT_TXDATA_i,
      GBT_RXDATA_o             => GBT_RXDATA_o,

      WB_TXDATA_i              => WB_TXDATA_i,
      WB_RXDATA_o              => WB_RXDATA_o

      );

  ila_mgt_gbt : ila_gbt_exde
    port map (
      clk => MGT_DRP_CLK,        -- original 300 MHz
      probe0 => ila_data_mgt,
      probe1 => (others => '0'),
      probe2(0) => '0',
      probe3(0) => '0'
      );

--=====================================================================================--
end mgt_gbt_inst;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--
