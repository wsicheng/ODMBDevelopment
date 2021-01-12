library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;
-- use work.ucsb_types.all;

-- To mimic the behavior of ODMB_VME on the component CFEBJTAG

entity kcu_ibert_gth is
  generic (
    NQUAD    : integer range 0 to 5 := 3   -- Number of Quads used for IBERT
    );
  port (
    --------------------
    -- Clock
    --------------------
    CMS_CLK_FPGA_P : in std_logic;      -- system clock: 300 MHz
    CMS_CLK_FPGA_N : in std_logic;      -- system clock: 300 MHz
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

    -- SPY_TX_P : out std_logic;        -- quad 227, link 3:
    -- SPY_TX_N : out std_logic;        -- quad 227, link 3:
    -- DAQ_TX_P : out std_logic_vector(4 downto 1); -- B04 TX, output to FED
    -- DAQ_TX_N : out std_logic_vector(4 downto 1); -- B04 TX, output to FED

    -- FMC_TX_P : out std_logic_vector(2 downto 0); -- Empty in ODMB, quad 227 link 0-2
    -- FMC_TX_N : out std_logic_vector(2 downto 0); -- Empty in ODMB, quad 227 link 0-2
    -- SFP_TX_P : out std_logic_vector(1 downto 0); -- Empty in ODMB, needed for SFP0/1 on KCU105
    -- SFP_TX_N : out std_logic_vector(1 downto 0); -- Empty in ODMB, needed for SFP0/1 on KCU105

    DAQ_TX_P : out std_logic_vector(4*NQUAD-1 downto 0); -- B04 TX, output to FED
    DAQ_TX_N : out std_logic_vector(4*NQUAD-1 downto 0); -- B04 TX, output to FED

    -- Optical control signals
    DAQ_SPY_SEL : out std_logic;      -- 0 for DAQ_RX_P/N11, 1 for SPY_RX_P/N

    --------------------------------
    -- SYSMON ports
    --------------------------------
    -- selectors
    SYSMON_MUX_ADDR_LS : out std_logic_vector(2 downto 0);
    SYSMON_AD0_R_P : in std_logic; -- MGTAVCC 1.0V SCALED to 0.5V
    SYSMON_AD0_R_N : in std_logic;
    SYSMON_AD8_R_P : in std_logic; -- MGTAVTT 1.2V SCALED to 0.6V
    SYSMON_AD8_R_N : in std_logic;
    SYSMON_AD2_R_P : in std_logic; -- SYSMON_MUX0_SENSE
    SYSMON_AD2_R_N : in std_logic

    );
end kcu_ibert_gth;

architecture kcu_inst of kcu_ibert_gth is

  --------------------------------------
  -- Component definiton for the IP cores
  --------------------------------------
  component clockManager is
    port (
      clk_in1_p  : in std_logic;
      clk_in1_n  : in std_logic;
      clk_out160 : out std_logic;
      clk_out80  : out std_logic;
      clk_out40  : out std_logic;
      clk_out20  : out std_logic;
      clk_out10  : out std_logic
      );
  end component;

  component vio_0
    port (
      clk : in std_logic;
      probe_out0 : out std_logic;
      probe_out1 : out std_logic;
      probe_out2 : out std_logic_vector(2 downto 0)
      );
  end component;

  --------------------------------------
  -- Component and signals for the IBERT test
  --------------------------------------
  component ibert_kcu_gth
    port (
      txn_o : out std_logic_vector(4*NQUAD-1 downto 0);
      txp_o : out std_logic_vector(4*NQUAD-1 downto 0);
      rxoutclk_o : out std_logic_vector(4*NQUAD-1 downto 0);
      rxn_i : in std_logic_vector(4*NQUAD-1 downto 0);
      rxp_i : in std_logic_vector(4*NQUAD-1 downto 0);
      gtrefclk0_i : in std_logic_vector(NQUAD-1 downto 0);
      gtrefclk1_i : in std_logic_vector(NQUAD-1 downto 0);
      gtnorthrefclk0_i : in std_logic_vector(NQUAD-1 downto 0);
      gtnorthrefclk1_i : in std_logic_vector(NQUAD-1 downto 0);
      gtsouthrefclk0_i : in std_logic_vector(NQUAD-1 downto 0);
      gtsouthrefclk1_i : in std_logic_vector(NQUAD-1 downto 0);
      gtrefclk00_i : in std_logic_vector(NQUAD-1 downto 0);
      gtrefclk10_i : in std_logic_vector(NQUAD-1 downto 0);
      gtrefclk01_i : in std_logic_vector(NQUAD-1 downto 0);
      gtrefclk11_i : in std_logic_vector(NQUAD-1 downto 0);
      gtnorthrefclk00_i : in std_logic_vector(NQUAD-1 downto 0);
      gtnorthrefclk10_i : in std_logic_vector(NQUAD-1 downto 0);
      gtnorthrefclk01_i : in std_logic_vector(NQUAD-1 downto 0);
      gtnorthrefclk11_i : in std_logic_vector(NQUAD-1 downto 0);
      gtsouthrefclk00_i : in std_logic_vector(NQUAD-1 downto 0);
      gtsouthrefclk10_i : in std_logic_vector(NQUAD-1 downto 0);
      gtsouthrefclk01_i : in std_logic_vector(NQUAD-1 downto 0);
      gtsouthrefclk11_i : in std_logic_vector(NQUAD-1 downto 0);
      clk : in std_logic
      );
  end component;

  signal gth_txn_o : std_logic_vector(4*NQUAD-1 downto 0);
  signal gth_txp_o : std_logic_vector(4*NQUAD-1 downto 0);
  signal gth_rxn_i : std_logic_vector(4*NQUAD-1 downto 0);
  signal gth_rxp_i : std_logic_vector(4*NQUAD-1 downto 0);

  signal gth_qrefclk0_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qrefclk1_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qnorthrefclk0_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qnorthrefclk1_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qsouthrefclk0_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qsouthrefclk1_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qrefclk00_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qrefclk10_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qrefclk01_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qrefclk11_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qnorthrefclk00_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qnorthrefclk10_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qnorthrefclk01_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qnorthrefclk11_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qsouthrefclk00_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qsouthrefclk10_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qsouthrefclk01_i : std_logic_vector(NQUAD-1 downto 0);
  signal gth_qsouthrefclk11_i : std_logic_vector(NQUAD-1 downto 0);

  signal mgtrefclk0_225_i : std_logic;
  signal mgtrefclk0_225_odiv2 : std_logic;
  signal mgtrefclk0_227_i : std_logic;
  signal mgtrefclk0_227_odiv2 : std_logic;
  signal mgtrefclk1_227_i : std_logic;
  signal mgtrefclk1_227_odiv2 : std_logic;
  signal mgtrefclk0_228_i : std_logic;
  signal mgtrefclk0_228_odiv2 : std_logic;
  signal mgtrefclk1_228_i : std_logic;
  signal mgtrefclk1_228_odiv2 : std_logic;
  signal gth_sysclk_i : std_logic;
  signal clk_sysclk40 : std_logic;
  signal clk_sysclk80 : std_logic;
  signal clk_cmsclk : std_logic;
  signal clk_gp6 : std_logic;
  signal clk_gp7 : std_logic;
  signal clk_mgtclk0 : std_logic;
  signal clk_mgtclk1 : std_logic;
  signal clk_mgtclk2 : std_logic;

  signal gth_clk_sel : std_logic;

  --------------------------------------
  -- Clock synthesizer and clock signals
  --------------------------------------
  signal clk160          : std_logic := '0';  -- For dcfeb prbs (160MHz)
  signal clk80           : std_logic := '0';
  signal clk40           : std_logic := '0';  -- NEW (fastclk -> 40MHz)
  signal clk20           : std_logic := '0';
  signal clk10           : std_logic := '0';  -- NEW (midclk -> fastclk/4 -> 10MHz)

  --------------------------------------
  -- Sysmon signals
  --------------------------------------
  signal sysmon_mux_addr : std_logic_vector(2 downto 0) := (others => '0');
  signal vauxn : std_logic_vector(15 downto 0) := (others=> '0');
  signal vauxp : std_logic_vector(15 downto 0) := (others=> '0');

  signal toggle_button : std_logic := '0';

begin

  -------------------------------------------------------------------------------------------
  -- Handle clock synthesizer signals and generate clocks
  -------------------------------------------------------------------------------------------

  u_buf_gth_q1_clk0 : IBUFDS_GTE3
    port map (
      O     => mgtrefclk0_225_i,
      ODIV2 => mgtrefclk0_225_odiv2,
      CEB   => '0',
      I     => REF_CLK_1_P,
      IB    => REF_CLK_1_N
      );

  -- SI570 clock on KCU105 connect to Quad-227
  u_buf_gth_q3_clk0 : IBUFDS_GTE3
    port map (
      O     => mgtrefclk0_227_i,
      ODIV2 => mgtrefclk0_227_odiv2,
      CEB   => '0',
      I     => REF_CLK_3_P,
      IB    => REF_CLK_3_N
      );

  u_buf_gth_q3_clk1 : IBUFDS_GTE3
    port map (
      O     => mgtrefclk1_227_i,
      ODIV2 => mgtrefclk1_227_odiv2,
      CEB   => '0',
      I     => CLK_125_REF_P,
      IB    => CLK_125_REF_N
      );

  -- SI570 clock on FMC card connect to Quad-228
  u_buf_gth_q4_clk0 : IBUFDS_GTE3
    port map (
      O     => mgtrefclk0_228_i,
      ODIV2 => mgtrefclk0_228_odiv2,
      CEB   => '0',
      I     => REF_CLK_2_P,
      IB    => REF_CLK_2_N
      );

  u_mgtclk0_q227 : BUFG_GT
    port map(
      I       => mgtrefclk0_227_odiv2,
      O       => clk_mgtclk1,
      CE      => '1',
      CEMASK  => '0',
      CLR     => '0',
      CLRMASK => '0',
      DIV     => "000"
      );

  -- -- Using input clock pin as IBERT sysclk <- option 1
  -- u_ibufgds_gp7 : IBUFGDS
  --   generic map (DIFF_TERM => FALSE)
  --   port map (
  --     I => GP_CLK_7_P,
  --     IB => GP_CLK_7_N,
  --     O => clk_gp7
  --   );

  -- u_ibufgds_cms : IBUFGDS
  --   generic map (DIFF_TERM => FALSE)
  --   port map (
  --     I => CMS_CLK_FPGA_P,
  --     IB => CMS_CLK_FPGA_N,
  --     O => clk_cmsclk
  --   );

  u_clk_gen : clockManager
    port map(
      clk_in1_p  => CMS_CLK_FPGA_P,
      clk_in1_n  => CMS_CLK_FPGA_N,
      clk_out160 => clk160,
      clk_out80  => clk80,
      clk_out40  => clk40,
      clk_out20  => clk20,
      clk_out10  => clk10
      );

  gth_sysclk_i <= clk80;
  DAQ_SPY_SEL <= gth_clk_sel;   -- Priority to test the SPY TX

  u_vio_top : vio_0
    port map (
      clk => clk80,                   -- same as IBERT
      probe_out0 => gth_clk_sel,      -- default '0'
      probe_out1 => toggle_button,    -- default '0'
      probe_out2 => sysmon_mux_addr   -- default '???'
      );

  -- SYSMON signals
  SYSMON_MUX_ADDR_LS <= sysmon_mux_addr;
  vauxp <= (0 => SYSMON_AD0_R_P, 2 => SYSMON_AD2_R_P, 8 => SYSMON_AD8_R_P, others => '0'); -- 16 bits
  vauxn <= (0 => SYSMON_AD0_R_N, 2 => SYSMON_AD2_R_N, 8 => SYSMON_AD8_R_N, others => '0'); -- 16 bits

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
      VAUXN => vauxn, -- 16 bits AD[0-15]N
      VAUXP => vauxp, -- 16 bits AD[0-16]P
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

  -- GTH ports
  pin_assign_224 : if NQUAD >= 5 generate 
    -- Quad 225: refclk0
    gth_qrefclk0_i(NQUAD-5) <= '0';
    gth_qnorthrefclk0_i(NQUAD-5) <= '0';
    gth_qsouthrefclk0_i(NQUAD-5) <= mgtrefclk0_225_i;
    gth_qrefclk00_i(NQUAD-5) <= '0';
    gth_qrefclk01_i(NQUAD-5) <= '0';
    gth_qnorthrefclk00_i(NQUAD-5) <= '0';
    gth_qnorthrefclk01_i(NQUAD-5) <= '0';
    gth_qsouthrefclk00_i(NQUAD-5) <= mgtrefclk0_225_i;
    gth_qsouthrefclk01_i(NQUAD-5) <= '0';
  end generate;

  pin_assign_225 : if NQUAD >= 4 generate 
    gth_rxp_i(4*NQUAD-13 downto 4*NQUAD-16) <= DAQ_RX_P(3 downto 0);  -- 4 quads
    gth_rxn_i(4*NQUAD-13 downto 4*NQUAD-16) <= DAQ_RX_N(3 downto 0);  -- 4 quads

    -- Quad 225: refclk0
    gth_qrefclk0_i(NQUAD-4) <= '0';
    gth_qnorthrefclk0_i(NQUAD-4) <= '0';
    gth_qsouthrefclk0_i(NQUAD-4) <= mgtrefclk0_227_i;
    gth_qrefclk00_i(NQUAD-4) <= '0';
    gth_qrefclk01_i(NQUAD-4) <= '0';
    gth_qnorthrefclk00_i(NQUAD-4) <= '0';
    gth_qnorthrefclk01_i(NQUAD-4) <= '0';
    gth_qsouthrefclk00_i(NQUAD-4) <= mgtrefclk0_227_i;
    gth_qsouthrefclk01_i(NQUAD-4) <= '0';
  end generate;

  pin_assign_226 : if NQUAD >= 3 generate 
    gth_rxp_i(4*NQUAD-9 downto 4*NQUAD-12) <= DAQ_RX_P(7 downto 4);  -- 3 quads
    gth_rxn_i(4*NQUAD-9 downto 4*NQUAD-12) <= DAQ_RX_N(7 downto 4);  -- 3 quads
    -- SFP_TX_P <= gth_txp_o(4*NQUAD-10 downto 4*NQUAD-11);
    -- SFP_TX_N <= gth_txn_o(4*NQUAD-10 downto 4*NQUAD-11);

    -- Quad 226: refclk0
    gth_qrefclk0_i(NQUAD-3) <= '0';
    gth_qnorthrefclk0_i(NQUAD-3) <= '0';
    gth_qsouthrefclk0_i(NQUAD-3) <= mgtrefclk0_227_i;
    gth_qrefclk00_i(NQUAD-3) <= '0';
    gth_qrefclk01_i(NQUAD-3) <= '0';
    gth_qnorthrefclk00_i(NQUAD-3) <= '0';
    gth_qnorthrefclk01_i(NQUAD-3) <= '0';
    gth_qsouthrefclk00_i(NQUAD-3) <= mgtrefclk0_227_i;
    gth_qsouthrefclk01_i(NQUAD-3) <= '0';
  end generate;

  -- Quad 227
  pin_assign_227 : if NQUAD >= 2 generate 
    gth_rxp_i(4*NQUAD-6 downto 4*NQUAD-8) <= DAQ_RX_P(10 downto 8); -- 2 quads
    gth_rxn_i(4*NQUAD-6 downto 4*NQUAD-8) <= DAQ_RX_N(10 downto 8); -- 2 quads
    -- SPY_TX_P <= gth_txp_o(4*NQUAD-5);
    -- SPY_TX_N <= gth_txn_o(4*NQUAD-5);
    -- FMC_TX_P <= gth_txp_o(4*NQUAD-6  downto 4*NQUAD-8);
    -- FMC_TX_N <= gth_txn_o(4*NQUAD-6  downto 4*NQUAD-8);
    gth_rxp_i(4*NQUAD-5) <= DAQ_SPY_RX_P;
    gth_rxn_i(4*NQUAD-5) <= DAQ_SPY_RX_N;

    -- Quad 227: refclk0
    gth_qrefclk0_i(NQUAD-2) <= mgtrefclk0_227_i;
    gth_qnorthrefclk0_i(NQUAD-2) <= '0';
    gth_qsouthrefclk0_i(NQUAD-2) <= '0';
    gth_qrefclk00_i(NQUAD-2) <= mgtrefclk0_227_i;
    gth_qrefclk01_i(NQUAD-2) <= '0';
    gth_qnorthrefclk00_i(NQUAD-2) <= '0';
    gth_qnorthrefclk01_i(NQUAD-2) <= '0';
    gth_qsouthrefclk00_i(NQUAD-2) <= '0';
    gth_qsouthrefclk01_i(NQUAD-2) <= '0';
  end generate;

  -- Quad 228
  gth_rxp_i(4*NQUAD-4) <= BCK_PRS_P;
  gth_rxn_i(4*NQUAD-4) <= BCK_PRS_N;
  gth_rxp_i(4*NQUAD-1 downto 4*NQUAD-3) <= B04_RX_P;
  gth_rxn_i(4*NQUAD-1 downto 4*NQUAD-3) <= B04_RX_N;

  DAQ_TX_P <= gth_txp_o;
  DAQ_TX_N <= gth_txn_o;

  -- Refclk connection from each IBUFDS to respective quads depending on the source selected in gui
  -- Quad 228: refclk0
  gth_qrefclk0_i(NQUAD-1) <= mgtrefclk0_228_i;
  gth_qnorthrefclk0_i(NQUAD-1) <= '0';
  gth_qsouthrefclk0_i(NQUAD-1) <= '0';
  gth_qrefclk00_i(NQUAD-1) <= mgtrefclk0_228_i;
  gth_qrefclk01_i(NQUAD-1) <= '0';
  gth_qnorthrefclk00_i(NQUAD-1) <= '0';
  gth_qnorthrefclk01_i(NQUAD-1) <= '0';
  gth_qsouthrefclk00_i(NQUAD-1) <= '0';
  gth_qsouthrefclk01_i(NQUAD-1) <= '0';

  -- Refclk1
  gth_qrefclk1_i <= (others => '0');
  gth_qnorthrefclk1_i <= (others => '0');
  gth_qsouthrefclk1_i <= (others => '0');
  gth_qrefclk10_i <= (others => '0');
  gth_qrefclk11_i <= (others => '0');
  gth_qnorthrefclk10_i <= (others => '0');
  gth_qnorthrefclk11_i <= (others => '0');
  gth_qsouthrefclk10_i <= (others => '0');
  gth_qsouthrefclk11_i <= (others => '0');

  u_ibert_gth_core : ibert_kcu_gth
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

end kcu_inst;
