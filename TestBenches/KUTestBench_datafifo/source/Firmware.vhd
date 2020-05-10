library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library UNISIM;
use UNISIM.VComponents.all;

use work.Firmware_pkg.all;

entity Firmware is
  PORT (
    CLKIN   : in std_logic;
    RDCLK   : in std_logic;
    WRCLK   : in std_logic;
    RESET   : in std_logic;
    WRDAV   : in std_logic;
    RDNEXT  : in std_logic;
    INPUT1  : in std_logic_vector(15 downto 0);
    INPUT2  : in std_logic_vector(15 downto 0);
    OUTPUT  : out std_logic_vector(19 downto 0);
    FIFODAV : out std_logic;
    FIFOOUT : out std_logic_vector(17 downto 0);
    FIFOERR : out std_logic_vector(3 downto 0)
    );
end Firmware;

architecture Behavioral of Firmware is
  -- Constants
  constant bw_fifo  : integer := 18;
  constant bw_add   : integer := 16;
  constant bw_out   : integer := 20;

  component datafifo_dcfeb_top is
    port (
      wr_clk                    : in  std_logic := '0';
      rd_clk                    : in  std_logic := '0';
      srst                      : in  std_logic := '0';
      prog_full                 : out std_logic := '0';
      wr_rst_busy               : out std_logic := '0';
      rd_rst_busy               : out std_logic := '0';
      wr_en                     : in  std_logic := '0';
      rd_en                     : in  std_logic := '0';
      din                       : in  std_logic_vector(bw_fifo-1 downto 0) := (others => '0');
      dout                      : out std_logic_vector(bw_fifo-1 downto 0) := (others => '0');
      full                      : out std_logic := '0';
      empty                     : out std_logic := '1');
  end component;

  -- Signals for simple addition
  signal input1_buf : std_logic_vector(bw_add-1 downto 0) := (others=> '0');
  signal input2_buf : std_logic_vector(bw_add-1 downto 0) := (others=> '0');
  signal add_res : unsigned(bw_add-1 downto 0) := (others=> '0');
  signal output_buf : std_logic_vector(bw_out-1 downto 0) := (others=> '0');

  -- fifo state
  signal st_fifo  : FSM_FIFO := STANDBY;
  signal counter  : unsigned(15 downto 0) := (others => '0');
  signal wr_en_i  : std_logic := '0';    -- the enable of enable
  signal rd_en_i  : std_logic := '0';    -- the enable of enable
  signal wr_dav   : std_logic := '0';    -- data available
  signal rd_dav   : std_logic := '0';    -- data available
  signal fifo_err : std_logic_vector(3 downto 0) := (others => '0');

  -- fifo signals
  signal wr_clk_i                       :   std_logic := '0';
  signal rd_clk_i                       :   std_logic := '0';
  signal srst                           :   std_logic := '0';
  signal prog_full                      :   std_logic := '0';
  signal wr_rst_busy                    :   std_logic := '0';
  signal rd_rst_busy                    :   std_logic := '0';
  signal wr_en                          :   std_logic := '0';
  signal rd_en                          :   std_logic := '0';
  signal din                            :   std_logic_vector(bw_fifo-1 downto 0) := (others => '0');
  signal dout                           :   std_logic_vector(bw_fifo-1 downto 0) := (others => '0');
  signal full                           :   std_logic := '0';
  signal empty                          :   std_logic := '1';

begin

-- Start of the simple addition algorithm
  logic: process (CLKIN)
  begin
    if WRCLK'event and WRCLK='1' then
      -- Pipeline 0 (Buffer for input)
      input1_buf <= INPUT1;
      input2_buf <= INPUT2;
      -- Pipeline 1
      add_res <= unsigned(input1_buf) + unsigned(input2_buf);
      -- Pipeline 2
      output_buf <= std_logic_vector(resize(add_res,bw_out));
      -- Pipeline 3 (Buffer for output)
      OUTPUT <= output_buf;
    end if;
  end process;

------------------

  -- Assign the input to fifo as the result of addition as well
  din <= "10" & INPUT1; -- 2 bits + input 16 bits
  -- wr_dav <= din(0);

  wr_clk_i <= WRCLK;
  rd_clk_i <= RDCLK;

  wr_dav <= WRDAV;
  rd_dav <= not empty;

  wr_en <= wr_dav and wr_en_i and not full and not wr_rst_busy;
  rd_en <= rd_dav and rd_en_i and not empty and not rd_rst_busy;

  fifo_err(0) <= full;

  wr_en_i <= '1';
  rd_en_i <= RDNEXT;

  srst <= RESET;
  FIFOOUT <= dout;
  FIFODAV <= rd_dav;
  FIFOERR <= fifo_err;

  datafifo_dcfeb_inst : datafifo_dcfeb_top
    PORT MAP (
      WR_CLK                    => wr_clk_i,
      RD_CLK                    => rd_clk_i,
      SRST                      => srst,
      PROG_FULL                 => prog_full,
      --SLEEP                     => sleep,
      wr_rst_busy               => wr_rst_busy,
      rd_rst_busy               => rd_rst_busy,
      WR_EN                     => wr_en,
      RD_EN                     => rd_en,
      DIN                       => din,
      DOUT                      => dout,
      FULL                      => full,
      EMPTY                     => empty);

end Behavioral;
