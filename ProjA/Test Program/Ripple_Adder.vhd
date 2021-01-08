-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- Ripple_Adder.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Ripple_Adder is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_carry  : in std_logic;
       o_sum  : out  std_logic_vector (N-1 downto 0);
       o_carry : out std_logic);

end Ripple_Adder;

architecture structure of Ripple_Adder is

component Full_Adder
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_carry  : in std_logic;
       o_sum  : out std_logic;
       o_carry : out std_logic);

end component;

signal sVECTOR_carries: std_logic_vector(N downto 0);

begin

sVECTOR_carries(0) <= i_carry;
o_carry <= sVECTOR_carries(N);

G1: for i in 0 to N-1 generate
  Full_Adder_i: Full_Adder
    port map(i_A  => i_A(i),
             i_B  => i_B(i),
	     i_carry => sVECTOR_carries(i),
             o_sum => o_sum(i),
  	     o_carry => sVECTOR_carries(i + 1));
end generate;

end structure;