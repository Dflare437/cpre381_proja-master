-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- Full_Adder.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Full_Adder is
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_carry  : in std_logic;
       o_sum  : out std_logic;
       o_carry : out std_logic);

end Full_Adder;

architecture structure of Full_Adder is

component xorg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

signal sVALUE_A_XOR_B, sVALUE_A_XOR_B_AND_Carry, sVALUE_A_AND_B : std_logic;

begin
  ---------------------------------------------------------------------------
  -- o_sum calculator
  ---------------------------------------------------------------------------
g_xor1: xorg2
    port MAP(i_A    => i_A,
             i_B    => i_B,
             o_F    => sVALUE_A_XOR_B);

g_xor2: xorg2
    port MAP(i_A    => sVALUE_A_XOR_B,
             i_B    => i_carry,
             o_F    => o_sum);

  ---------------------------------------------------------------------------
  -- o_carry calculator
  ---------------------------------------------------------------------------

g_and1: andg2
    port MAP(i_A    => sVALUE_A_XOR_B,
             i_B    => i_carry,
             o_F    => sVALUE_A_XOR_B_AND_Carry);

g_and2: andg2
    port MAP(i_A    => i_A,
             i_B    => i_B,
             o_F    => sVALUE_A_AND_B);

g_or1: org2
    port MAP(i_A    => sVALUE_A_XOR_B_AND_Carry,
             i_B    => sVALUE_A_AND_B,
             o_F    => o_carry);

end structure;
