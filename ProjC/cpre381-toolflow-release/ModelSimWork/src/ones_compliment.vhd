-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- ones_compliment.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ones_compliment is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));

end ones_compliment;

architecture structure of ones_compliment is

component invg
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;

begin

-- We loop through and instantiate and connect N invg modules
G1: for i in 0 to N-1 generate
  invg_i: invg
    port map(i_A  => i_A(i),
  	          o_F  => o_F(i));
end generate;

end structure;