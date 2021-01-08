-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- N_bit_2_1_MUX.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity N_bit_2_1_MUX is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Sel : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end N_bit_2_1_MUX;

architecture structure of N_bit_2_1_MUX is

component two_one_MUX
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Sel  : in std_logic;
       o_F  : out std_logic);
end component;


begin

G1: for i in 0 to N-1 generate
  two_one_MUX_i: two_one_MUX
    port map(i_A  => i_A(i),
             i_B  => i_B(i),
             i_Sel => i_Sel,
  	     o_F  => o_F(i));
end generate;

end structure;
