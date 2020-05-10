library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

use work.Firmware_pkg.all;

entity Firmware_tb is
  PORT ( 
    -- 300 MHz clk_in
    CLK_IN_P : in std_logic;
    CLK_IN_N : in std_logic;
    -- 40 MHz clk out
    J36_USER_SMA_GPIO_P : out std_logic
  );      
end Firmware_tb;

architecture Behavioral of Firmware_tb is
  component clockManager is
  port (
    CLK_IN300  : in std_logic := '0';
    CLK_OUT40  : out std_logic := '0';
    CLK_OUT10  : out std_logic := '0';
    CLK_OUT80  : out std_logic := '0';
    CLK_OUT160 : out std_logic := '0'
  );
  end component;
  component ila is
  port (
    clk : in std_logic := '0';
    probe0 : in std_logic_vector(255 downto 0) := (others=> '0');
    probe1 : in std_logic_vector(4095 downto 0) := (others => '0')
  );
  end component;
  component lut_input1 is
  port (
    clka : in std_logic := '0';
    addra : in std_logic_vector(6 downto 0) := (others=> '0');
    douta : out std_logic_vector(11 downto 0) := (others => '0')
  );
  end component;
  component lut_input2 is
  port (
    clka : in std_logic := '0';
    addra : in std_logic_vector(6 downto 0) := (others=> '0');
    douta : out std_logic_vector(11 downto 0) := (others => '0')
  );
  end component;

  -- Clock signals
  signal clk_in_buf : std_logic := '0';
  signal sysclk : std_logic := '0';
  signal sysclkQuarter : std_logic := '0'; 
  signal sysclkDouble : std_logic := '0';
  signal sysclkQuad : std_logic := '0';
  signal intime_s: std_logic := '0';
  -- Constants
  constant bw_input1 : integer := 12;
  constant bw_input2 : integer := 12;
  constant bw_output : integer := 20;
  constant bw_addr : integer := 7;
  constant bw_fifo : integer := 18;
  constant bw_count : integer := 16;
  constant nclocksrun : integer := 512;
  -- Counters
  signal waitCounter  : unsigned(bw_count-1 downto 0) := (others=> '0');
  signal inputCounter : unsigned(bw_count-1 downto 0) := (others=> '0');
  signal readCounter  : unsigned(bw_count-1 downto 0) := (others=> '0');
  -- Intermediate input to the fifo
  signal input_dav : std_logic := '0';
  signal input1_s  : std_logic_vector(bw_fifo-3 downto 0) := (others=> '0');
  signal input2_s  : std_logic_vector(bw_fifo-3 downto 0) := (others=> '0');
  -- Output to firmware signals
  signal output_s : std_logic_vector(bw_output-1 downto 0) := (others=> '0');
  -- ILA
  signal trig0 : std_logic_vector(255 downto 0) := (others=> '0');
  signal data  : std_logic_vector(4095 downto 0) := (others=> '0');
  -- LUT input
  signal lut_input_addr1_s : unsigned(bw_addr-1 downto 0) := (others=> '1');
  signal lut_input_addr2_s : unsigned(bw_addr-1 downto 0) := (others=> '1');
  signal lut_input1_dout_c : std_logic_vector(bw_input1-1 downto 0) := (others=> '0');
  signal lut_input2_dout_c : std_logic_vector(bw_input2-1 downto 0) := (others=> '0');
  -- Data FIFO
  signal rst_fifo : std_logic := '0';
  signal fifo_rd  : std_logic := '0';
  signal fifo_dav : std_logic := '0';
  signal fifo_out : std_logic_vector(bw_fifo-1 downto 0) := (others=> '0');
  signal fifo_err : std_logic_vector(3 downto 0) := (others=> '0');
  -- Checker bit
  signal checker  : std_logic := '0';

begin

  input_clk_simulation_i : if in_simulation generate
    process
      constant clk_period_by_2 : time := 1.666 ns;
      begin
      while 1=1 loop
        clk_in_buf <= '0';
        wait for clk_period_by_2;
        clk_in_buf <= '1';
        wait for clk_period_by_2;
      end loop;
    end process;
  end generate input_clk_simulation_i;
  input_clk_synthesize_i : if in_synthesis generate
    ibufg_i : IBUFGDS
    port map (
               I => CLK_IN_P,
               IB => CLK_IN_N,
               O => clk_in_buf
             );
  end generate input_clk_synthesize_i;

  ClockManager_i : clockManager
  port map(
            CLK_IN300 => clk_in_buf,
            CLK_OUT40 => sysclk,
            CLK_OUT10 => sysclkQuarter,
            CLK_OUT80 => sysclkDouble,
            CLK_OUT160 => sysclkQuad
          );

  J36_USER_SMA_GPIO_P <= sysclk;

  i_ila : ila
  port map(
    clk => sysclk,
    probe0 => trig0,
    probe1 => data
  );
  trig0(0) <= intime_s;
  trig0(13 downto 2) <= lut_input1_dout_c;
  trig0(25 downto 14) <= lut_input2_dout_c;
  data(15 downto 0) <= input1_s;
  data(31 downto 16) <= input2_s;
  data(51 downto 32) <= output_s;
  data(52) <= sysclkQuad;


  waitGenerator_i: process (sysclk) is
    variable init_input1: unsigned(bw_input1-1 downto 0):= (others => '1');
  begin

    -- Simulate data coming out every fourth clock
    if sysclk'event and sysclk='1' then

      waitCounter <= waitCounter + 1;
      -- Set the intime to 1 only after 7 clk cycles
      if waitCounter = 1 then
        intime_s <= '0';
        -- inputCounter <= to_unsigned(0,bw_count);
        -- readCounter <= to_unsigned(0,bw_count);
      elsif waitCounter = 7 then
        intime_s <= '1';
      elsif waitCounter >= (nclocksrun+7) then
        intime_s <= '0';
        -- input_dav <= '0';
        waitCounter <= (others => '0');
        -- inputCounter <= (others => '0');
        -- readCounter <= (others => '0');
      end if;
    end if;
  end process;


  -- Simulation process ?
  -- Read input from input1 and pass it to the fifo
  inputGenerator_i: process (sysclkQuad) is
    variable init_input1: unsigned(bw_fifo-3 downto 0):= (others => '1');
  begin

    -- Simulate data coming out every fourth clock
    if sysclkQuad'event and sysclkQuad='1' then
      rst_fifo <= '0';
      if intime_s = '1' and fifo_err(0) /= '1' then
        inputCounter <= inputCounter + 1;
        -- Initalize lut_input_addr_s
        if inputCounter = 0 then
          lut_input_addr1_s <= to_unsigned(0,bw_addr);
          input1_s <= std_logic_vector(init_input1);
          input_dav <= '0';
        else
          lut_input_addr1_s <= lut_input_addr1_s + 1;
          -- The output is PRNS { rnd |= 1; rnd ^= (rnd << (i % 11 + 1)); }
          input1_s <= std_logic_vector(lut_input_addr1_s(3 downto 0)) & std_logic_vector(lut_input1_dout_c);
          input_dav <= '1';
        end if;
      else
        inputCounter <= to_unsigned(0,bw_count);
        input_dav <= '0';
      end if;
    end if;

  end process;

  -- Read input from input2 compare it to the output of the fifo
  -- Input1.coe and Input2.coe shall be exactly the same
  readoutChecker_i: process (sysclkDouble) is
    --Values
    variable init_input2: unsigned(bw_fifo-3 downto 0):= (others => '1');
  begin

    if sysclkDouble'event and sysclkDouble='1' then
      rst_fifo <= '0';
      if intime_s = '1' then
        input2_s <= std_logic_vector(lut_input_addr2_s(3 downto 0)) & std_logic_vector(lut_input2_dout_c);

        if fifo_dav = '1' then
          readCounter <= readCounter + 1;

          if input2_s = fifo_out(bw_fifo-3 downto 0) then
            checker <= '1';
          else
            checker <= '0';
          end if;

          if readCounter = 0 then
            lut_input_addr2_s <= to_unsigned(0,bw_addr);
            input2_s <= std_logic_vector(init_input2);
          else
            lut_input_addr2_s <= lut_input_addr2_s + 1;
            fifo_rd <= '1';
          end if;
        end if;
      else
        readCounter <= (others => '0');
        fifo_rd <= '0';
      end if;
    end if;

  end process;

  -- Input LUTs
  lut_input1_i: lut_input1
  port map(
            clka=> sysclkQuad,
            addra=> std_logic_vector(lut_input_addr1_s),
            douta=> lut_input1_dout_c
          );
  lut_input2_i: lut_input2
  port map(
            clka=> sysclkDouble,
            addra=> std_logic_vector(lut_input_addr2_s),
            douta=> lut_input2_dout_c
          );

  -- Firmware process
  firmware_i: entity work.Firmware
  port map(
            CLKIN=> sysclk,
            RDCLK=> sysclkDouble,
            WRCLK=> sysclkQuad,
            RESET=> rst_fifo,
            WRDAV=> input_dav,
            RDNEXT=> fifo_rd,
            INPUT1=> input1_s,
            INPUT2=> input2_s,
            OUTPUT=> output_s,
            FIFODAV=> fifo_dav,
            FIFOOUT=> fifo_out,
            FIFOERR=> fifo_err
          );

end Behavioral;
