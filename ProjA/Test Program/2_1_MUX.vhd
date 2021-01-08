-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- 2_1_MUX.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity two_one_MUX is
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Sel  : in std_logic;
       o_F  : out std_logic);

end two_one_MUX;

architecture structure of two_one_MUX is

component invg
  port(i_A          : in std_logic;
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

signal sVALUE_notSel, sVALUE_notSelANDiA, sVALUE_SelANDiB : std_logic;

begin
  ---------------------------------------------------------------------------
  -- Level 1
  ---------------------------------------------------------------------------
g_invg1: invg
    port MAP(i_A    => i_Sel,
             o_F    => sVALUE_notSel);

  ---------------------------------------------------------------------------
  -- Level 2
  ---------------------------------------------------------------------------
g_and1: andg2
    port MAP(i_A    => i_A,
             i_B    => sVALUE_notSel,
             o_F    => sVALUE_notSelANDiA);

g_and2: andg2
    port MAP(i_A    => i_Sel,
             i_B    => i_B,
             o_F    => sVALUE_SelANDiB);

  ---------------------------------------------------------------------------
  -- Level 3
  ---------------------------------------------------------------------------

g_or1: org2
    port MAP(i_A    => sVALUE_notSelANDiA,
             i_B    => sVALUE_SelANDiB,
             o_F    => o_F);

end structure;