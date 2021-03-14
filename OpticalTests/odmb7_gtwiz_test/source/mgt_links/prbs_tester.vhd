--------------------------------------------------------------------------------
-- MGT wrapper
-- Based on example design
--------------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.ucsb_types.all;

library UNISIM;
use UNISIM.VComponents.all;

use ieee.std_logic_misc.all;

entity prbs_tester is
  generic (
    SPYDATAWIDTH : integer := 16;
    FEBDATAWIDTH : integer := 16;
    DDUDATAWIDTH : integer := 16
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
    -- Pattern generation for mgt_ddu
    usrclk_ddu_tx  : in std_logic; -- USRCLK for SPY TX data generation
    txdata_ddu1    : out std_logic_vector(DDUDATAWIDTH-1 downto 0); -- PRBS data out 
    txdata_ddu2    : out std_logic_vector(DDUDATAWIDTH-1 downto 0); -- PRBS data out 
    txdata_ddu3    : out std_logic_vector(DDUDATAWIDTH-1 downto 0); -- PRBS data out 
    txdata_ddu4    : out std_logic_vector(DDUDATAWIDTH-1 downto 0); -- PRBS data out 
    txd_valid_ddu  : out std_logic_vector(4 downto 1);
    -- Pattern checking for mgt_ddu
    usrclk_ddu_rx  : in std_logic;  -- USRCLK for DDU RX data readout
    rxdata_ddu1    : in std_logic_vector(DDUDATAWIDTH-1 downto 0);   -- Data received
    rxdata_ddu2    : in std_logic_vector(DDUDATAWIDTH-1 downto 0);   -- Data received
    rxdata_ddu3    : in std_logic_vector(DDUDATAWIDTH-1 downto 0);   -- Data received
    rxdata_ddu4    : in std_logic_vector(DDUDATAWIDTH-1 downto 0);   -- Data received
    rxd_valid_ddu  : in std_logic_vector(4 downto 1);
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
    mgtc_rxready   : in std_logic; -- Flag for rx reset done
    -- Receiver signals for mgt_alct
    usrclk_mgta    : in std_logic; -- USRCLK for RX data readout
    rxdata_alct    : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
    rxd_valid_alct : in std_logic;
    rxdata_daq8    : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
    rxdata_daq9    : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
    rxdata_daq10   : in std_logic_vector(FEBDATAWIDTH-1 downto 0);  -- Data received
    mgta_dvalid    : in std_logic_vector(4 downto 1);   -- Flag for valid data;
    mgta_rxready   : in std_logic; -- Flag for rx reset done

    -- LED indicator
    led_out       : out std_logic_vector(7 downto 0);
    -- Reset
    reset         : out std_logic
    );
end prbs_tester;

architecture Behavioral of prbs_tester is

  component gtwiz_prbs_any is
    generic  (
      CHK_MODE    : integer := 0;
      INV_PATTERN : integer := 0;
      POLY_LENGHT : integer := 31;
      POLY_TAP    : integer := 3;
      NBITS       : integer := 16
      );
    port (
      RST      : in std_logic;
      CLK      : in std_logic;
      DATA_IN  : in std_logic_vector(NBITS-1 downto 0);
      EN       : in std_logic;
      DATA_OUT : out std_logic_vector(NBITS-1 downto 0) := (others => '1')
      );
  end component;

  component vio_1
    port (
      clk : in std_logic;
      probe_in0 : in std_logic_vector(3 downto 0);
      probe_in1 : in std_logic_vector(6 downto 0);
      probe_in2 : in std_logic;
      probe_in3 : in std_logic;
      probe_out0 : out std_logic
      );
  end component;

  signal txdata_ch : twobyte_array_ndev;
  signal rxdata_ch : twobyte_array_ndev;

  signal txdata_spy_int : std_logic_vector(SPYDATAWIDTH-1 downto 0) := (others => '0');
  signal txdata_ddu_int : std_logic_vector(DDUDATAWIDTH-1 downto 0) := (others => '0');

  signal prbs_anyerr_spy  : std_logic_vector(SPYDATAWIDTH-1 downto 0) := (others => '0');
  signal prbs_match_spy : std_logic := '0';

  type dwidth_array_ddu is array (1 to 4) of std_logic_vector(DDUDATAWIDTH-1 downto 0);
  signal rxdata_ddu_ch : dwidth_array_ddu;
  signal prbs_anyerr_ddu : dwidth_array_ddu;
  signal prbs_match_ddu : std_logic_vector(4 downto 1) := (others => '0');

  type dwidth_array_feb is array (1 to 7) of std_logic_vector(FEBDATAWIDTH-1 downto 0);
  signal rxdata_cfeb_ch : dwidth_array_feb;
  signal rxdata_alct_ch : dwidth_array_feb;
  signal prbs_anyerr_cfeb : dwidth_array_feb;
  signal prbs_match_cfeb : std_logic_vector(7 downto 1) := (others => '0');
  signal prbs_anyerr_mgta : dwidth_array_feb;
  signal prbs_match_mgta : std_logic_vector(4 downto 1) := (others => '0');

  signal prbs_anyerr_alct  : std_logic_vector(FEBDATAWIDTH-1 downto 0) := (others => '0');
  signal prbs_match_alct : std_logic := '0';

  -- signal txdata_valid_int : std_logic_vector(NTXLINK-1 downto 0) := (others => '0');
  signal txd_spy_init_ctr : unsigned(15 downto 0) := (others => '0');
  signal txd_ddu_init_ctr : unsigned(15 downto 0) := (others => '0');

  signal gtwiz_tx_stimulus_reset_sync : std_logic := '0';
  signal global_reset : std_logic := '0';

begin

  ---------------------------------------------------------------------------------------------------------------------
  -- PRBS stimulus 
  ---------------------------------------------------------------------------------------------------------------------

  -- Single TX PRBS pattern generator
  prbs_stimulus_spy_inst : gtwiz_prbs_any
    generic map (
      CHK_MODE    => 0,
      INV_PATTERN => 1,
      POLY_LENGHT => 31,
      POLY_TAP    => 28,
      NBITS       => SPYDATAWIDTH
      )
    port map (
      RST      => global_reset,
      CLK      => usrclk_spy_tx,
      DATA_IN  => (others => '0'),
      EN       => '1',
      DATA_OUT => txdata_spy_int
      );
  
  txdata_spy <= txdata_spy_int;

  txdata_spy_init_inst : process (usrclk_spy_tx)
  begin
    if (rising_edge(usrclk_spy_tx)) then
      if (global_reset = '1') then
        txd_valid_spy <= '0';
        txd_spy_init_ctr <= x"0000";
      elsif (txd_spy_init_ctr < 100) then
        txd_valid_spy <= '0';
        txd_spy_init_ctr <= txd_spy_init_ctr + 1;
      else
        txd_valid_spy <= '1';
      end if;
    end if;
  end process;


  prbs_stimulus_ddu_inst : gtwiz_prbs_any
    generic map (
      CHK_MODE    => 0,
      INV_PATTERN => 1,
      POLY_LENGHT => 31,
      POLY_TAP    => 28,
      NBITS       => DDUDATAWIDTH
      )
    port map (
      RST      => global_reset,
      CLK      => usrclk_ddu_tx,
      DATA_IN  => (others => '0'),
      EN       => '1',
      DATA_OUT => txdata_ddu_int
      );

  txdata_ddu1 <= txdata_ddu_int;
  txdata_ddu2 <= txdata_ddu_int;
  txdata_ddu3 <= txdata_ddu_int;
  txdata_ddu4 <= txdata_ddu_int;

  txdata_ddu_init_inst : process (usrclk_ddu_tx)
  begin
    if (rising_edge(usrclk_ddu_tx)) then
      if (global_reset = '1') then
        txd_valid_ddu <= x"0";
        txd_ddu_init_ctr <= x"0000";
      elsif (txd_ddu_init_ctr < 100) then
        txd_valid_ddu <= x"0";
        txd_ddu_init_ctr <= txd_ddu_init_ctr + 1;
      else
        txd_valid_ddu <= x"F";
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------------------------------------------------
  -- PRBS Checking
  ---------------------------------------------------------------------------------------------------------------------
  -- Individual RX PRBS pattern checking
  prbs_checking_spy : gtwiz_prbs_any
    generic map (
      CHK_MODE    => 1,
      INV_PATTERN => 1,
      POLY_LENGHT => 31,
      POLY_TAP    => 28,
      NBITS       => SPYDATAWIDTH
      )
    port map (
      RST      => global_reset,
      CLK      => usrclk_spy_rx,
      DATA_IN  => rxdata_spy,
      EN       => rxd_valid_spy,
      DATA_OUT => prbs_anyerr_spy
      );
  
  prbs_match_spy <= not or_reduce(prbs_anyerr_spy);

  -- DDU regime
  rxdata_ddu_ch(1) <= rxdata_ddu1;
  rxdata_ddu_ch(2) <= rxdata_ddu2;
  rxdata_ddu_ch(3) <= rxdata_ddu3;
  rxdata_ddu_ch(4) <= rxdata_ddu4;

  gen_prbs_checking_ddu : for I in 1 to 4 generate
    prbs_checking_spy : gtwiz_prbs_any
      generic map (
        CHK_MODE    => 1,
        INV_PATTERN => 1,
        POLY_LENGHT => 31,
        POLY_TAP    => 28,
        NBITS       => DDUDATAWIDTH
        )
      port map (
        RST      => global_reset,
        CLK      => usrclk_ddu_rx,
        DATA_IN  => rxdata_ddu_ch(I),
        EN       => rxd_valid_ddu(I),
        DATA_OUT => prbs_anyerr_ddu(I)
        );

    prbs_match_ddu(I) <= not or_reduce(prbs_anyerr_ddu(I));
  end generate gen_prbs_checking_ddu;
  
  rxdata_cfeb_ch(1) <= rxdata_cfeb1;
  rxdata_cfeb_ch(2) <= rxdata_cfeb2;
  rxdata_cfeb_ch(3) <= rxdata_cfeb3;
  rxdata_cfeb_ch(4) <= rxdata_cfeb4;
  rxdata_cfeb_ch(5) <= rxdata_cfeb5;
  rxdata_cfeb_ch(6) <= rxdata_cfeb6;
  rxdata_cfeb_ch(7) <= rxdata_cfeb7;

  gen_prbs_checking_cfeb : for I in 1 to 7 generate
    prbs_checking_cfeb : gtwiz_prbs_any
      generic map (
        CHK_MODE    => 1,
        INV_PATTERN => 1,
        POLY_LENGHT => 31,
        POLY_TAP    => 28,
        NBITS       => FEBDATAWIDTH
        )
      port map (
        RST      => global_reset,
        CLK      => usrclk_mgtc,
        DATA_IN  => rxdata_cfeb_ch(I),
        EN       => rxd_valid_mgtc(I),
        DATA_OUT => prbs_anyerr_cfeb(I)
        );

    prbs_match_cfeb(I) <= not or_reduce(prbs_anyerr_cfeb(I));
  end generate gen_prbs_checking_cfeb;

  -- Checking for 1 channel alct data
  prbs_checking_alct : gtwiz_prbs_any
    generic map (
      CHK_MODE    => 1,
      INV_PATTERN => 1,
      POLY_LENGHT => 31,
      POLY_TAP    => 28,
      NBITS       => FEBDATAWIDTH
      )
    port map (
      RST      => global_reset,
      CLK      => usrclk_mgta,
      DATA_IN  => rxdata_alct,
      EN       => rxd_valid_alct,
      DATA_OUT => prbs_anyerr_alct
      );
  
  prbs_match_alct <= not or_reduce(prbs_anyerr_alct);

  -- LED indicator for prbs_match of link(I)
  led_out(0) <= not and_reduce(prbs_match_cfeb(4 downto 1));
  led_out(1) <= not (and_reduce(prbs_match_cfeb(7 downto 5)));
  led_out(2) <= not prbs_match_alct;
  led_out(3) <= not prbs_match_spy;
  led_out(4) <= not and_reduce(prbs_match_ddu);
  led_out(7 downto 5) <= "111";         -- set the LEDs off

  reset <= global_reset;

  prbs_test_vio_inst : vio_1
    port map (
      clk => sysclk,
      probe_in0 => prbs_match_ddu,
      probe_in1 => prbs_match_cfeb,
      probe_in2 => prbs_match_alct,
      probe_in3 => prbs_match_spy,
      probe_out0 => global_reset
      );


end Behavioral;
