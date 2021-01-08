-------------------------------------------------------------------------
-- Curt Lengemann

-- ShiftL_2.vhd
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity ShiftL_2 is
  generic(N : integer := 32);
  port(i_A : in std_logic_vector(N-1 downto 0);
	   o_F : out std_logic_vector(N+1 downto 0));
end ShiftL_2;

architecture dataflow of ShiftL_2 is
begin

o_F <= i_A & "00";

end dataflow;