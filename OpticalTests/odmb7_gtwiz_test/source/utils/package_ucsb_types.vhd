-- Package with types used by UCSB
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package ucsb_types is

  constant NCFEB : integer range 1 to 7 := 7;
  constant NDEVICE  : integer range 1 to 10 := 9;

  -- For VMECONFREG 
  type cfg_regs_array is array (0 to 15) of std_logic_vector(15 downto 0);

  -- For VMECONFREG 
  type done_cnt_type is array (NCFEB downto 1) of integer range 0 to 3;
  type done_state_type is (DONE_IDLE, DONE_LOW, DONE_COUNTING);
  type done_state_array_type is array (NCFEB downto 1) of done_state_type;

  -- For MGT data quality control
  type fourbit_array_ncfeb is array (1 to NCFEB) of std_logic_vector(3 downto 0);
  type twobyte_array_ndev is array (1 to NDEVICE) of std_logic_vector(15 downto 0);

end ucsb_types;
