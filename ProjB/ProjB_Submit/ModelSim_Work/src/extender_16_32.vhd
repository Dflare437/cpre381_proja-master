-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- extender_16_32.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity extender_16_32 is

  port(i_Zero_Sign : std_logic;
       i_input : in std_logic_vector(15 downto 0);
       o_F : out std_logic_vector(31 downto 0));

end extender_16_32;

architecture dataflow of extender_16_32 is

begin

o_F(31 downto 16) <= x"0000" when i_Zero_Sign = '0' or i_input(15) = '0' else x"FFFF";
o_F(15 downto 0) <= i_input;

end dataflow;	