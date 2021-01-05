library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

entity clock_counting is
  generic (
    NBITS : integer range 1 to 64 := 41;   -- Number of bits for the counter
    BITOUT : integer range 0 to 63 := 26  -- i'th bits out for the LED
    );
  port (
    clk_i : in std_logic;
    led_o : out std_logic
    );
end clock_counting;

architecture inst of clock_counting is
  signal cntr_clk  : unsigned(NBITS-1 downto 0) := (others => '0');

begin
  process (CLK_i)
  begin
    if (rising_edge(CLK_i)) then
      cntr_clk <= cntr_clk + 1;
      LED_o <= std_logic(cntr_clk(BITOUT));
    end if;
  end process;

end inst;
