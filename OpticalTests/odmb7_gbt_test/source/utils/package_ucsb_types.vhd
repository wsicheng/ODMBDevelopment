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

  -- For various counter
  type t_twobyte_arr is array (integer range <>) of std_logic_vector(15 downto 0);
  type t_devdata_arr is array (integer range <>) of std_logic_vector(17 downto 0);
  type t_fourbyte_arr is array (integer range <>) of std_logic_vector(31 downto 0);
  type t_eightbyte_arr is array (integer range <>) of std_logic_vector(63 downto 0);

  type t_mgt_16b_rxdata is record
    rxdata          : std_logic_vector(15 downto 0);
    rxd_valid       : std_logic;
    crc_valid       : std_logic;
    bad_rx          : std_logic;
  end record;

  type t_mgt_16b_rxconfig is record
    fifo_full       : std_logic;
    fifo_afull      : std_logic;
    prbs_en         : std_logic;
  end record;

  type t_mgt_16b_rxdata_arr is array(integer range <>) of t_mgt_16b_rxdata;

end ucsb_types;
