-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- Barrel_Shifter.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Barrel_Shifter is
  generic(N : integer := 32);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       Logical_Arithmatic : in std_logic;
       Left_Right : in std_logic;
       i_shamt : in std_logic_vector(4 downto 0);
       o_F : out std_logic_vector(N-1 downto 0));

end Barrel_Shifter;

architecture structure of Barrel_Shifter is

component two_one_MUX
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Sel  : in std_logic;
       o_F  : out std_logic);

end component;

component N_bit_2_1_MUX
  port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Sel : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

signal s_1ShiftMux_Out, s_2ShiftMux_Out, s_4ShiftMux_Out: std_logic_vector(N-1 downto 0);
signal s_8ShiftMux_Out, s_16ShiftMux_Out, s_Altered_Input: std_logic_vector(N-1 downto 0);
signal s_Shift_Bit: std_logic; 
signal s_Flipped_Input, s_Flipped_Output: std_logic_vector(N-1 downto 0);

begin

G8: for i in 0 to N-1 generate
s_Flipped_Input(i) <= i_A(N-1-i);
end generate;

-- Choose Left or Right Shift
two_one_MUX_select_input: N_bit_2_1_MUX
   port MAP(i_A => s_Flipped_Input,
	    i_B => i_A,
	    i_Sel => Left_Right,
	    o_F => s_Altered_Input);

-- Choose what number to shift in
s_Shift_Bit <= i_A(31) and Left_Right and Logical_Arithmatic;

-- One bit shifter
two_one_MUX_1bit_31: two_one_MUX
   port MAP(i_A  => s_Altered_Input(31),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(0),
            o_F  => s_1ShiftMux_Out(31));

G1: for i in 0 to N-2 generate
two_one_MUX_1bit_i: two_one_MUX
   port MAP(i_A  => s_Altered_Input(i),
       	    i_B  => s_Altered_Input(i + 1),
            i_Sel  => i_shamt(0),
            o_F  => s_1ShiftMux_Out(i));
end generate;

-- 2 bit shifter
two_one_MUX_2bit_31: two_one_MUX
   port MAP(i_A  => s_1ShiftMux_Out(31),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(1),
            o_F  => s_2ShiftMux_Out(31));

two_one_MUX_2bit_30: two_one_MUX
   port MAP(i_A  => s_1ShiftMux_Out(30),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(1),
            o_F  => s_2ShiftMux_Out(30));

G2: for i in 0 to N-3 generate
two_one_MUX_2bit_i: two_one_MUX
   port MAP(i_A  => s_1ShiftMux_Out(i),
       	    i_B  => s_1ShiftMux_Out(i + 2),
            i_Sel  => i_shamt(1),
            o_F  => s_2ShiftMux_Out(i));
end generate;

-- 4 bit shifter
two_one_MUX_4bit_31: two_one_MUX
   port MAP(i_A  => s_2ShiftMux_Out(31),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(2),
            o_F  => s_4ShiftMux_Out(31));

two_one_MUX_4bit_30: two_one_MUX
   port MAP(i_A  => s_2ShiftMux_Out(30),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(2),
            o_F  => s_4ShiftMux_Out(30));

two_one_MUX_4bit_29: two_one_MUX
   port MAP(i_A  => s_2ShiftMux_Out(29),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(2),
            o_F  => s_4ShiftMux_Out(29));

two_one_MUX_4bit_28: two_one_MUX
   port MAP(i_A  => s_2ShiftMux_Out(28),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(2),
            o_F  => s_4ShiftMux_Out(28));

G3: for i in 0 to N-5 generate
two_one_MUX_4bit_i: two_one_MUX
   port MAP(i_A  => s_2ShiftMux_Out(i),
       	    i_B  => s_2ShiftMux_Out(i + 4),
            i_Sel  => i_shamt(2),
            o_F  => s_4ShiftMux_Out(i));
end generate;

-- 8 bit shifter
G4: for i in 24 to N-1 generate
two_one_MUX_8bit_i: two_one_MUX
   port MAP(i_A  => s_4ShiftMux_Out(i),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(3),
            o_F  => s_8ShiftMux_Out(i));
end generate;

G5: for i in 0 to N-9 generate
two_one_MUX_8bit_i: two_one_MUX
   port MAP(i_A  => s_4ShiftMux_Out(i),
       	    i_B  => s_4ShiftMux_Out(i + 8),
            i_Sel  => i_shamt(3),
            o_F  => s_8ShiftMux_Out(i));
end generate;

-- 16 bit shifter
G6: for i in 16 to N-1 generate
two_one_MUX_16bit_i: two_one_MUX
   port MAP(i_A  => s_8ShiftMux_Out(i),
       	    i_B  => s_Shift_Bit,
            i_Sel  => i_shamt(4),
            o_F  => s_16ShiftMux_Out(i));
end generate;

G7: for i in 0 to N-17 generate
two_one_MUX_16bit_i: two_one_MUX
   port MAP(i_A  => s_8ShiftMux_Out(i),
       	    i_B  => s_8ShiftMux_Out(i + 16),
            i_Sel  => i_shamt(4),
            o_F  => s_16ShiftMux_Out(i));
end generate;

G9: for i in 0 to N-1 generate
s_Flipped_Output(i) <= s_16ShiftMux_Out(N-1-i);
end generate;

-- Choose Left or Right Shift Output
two_one_MUX_select_output: N_bit_2_1_MUX
   port MAP(i_A => s_Flipped_Output,
	    i_B => s_16ShiftMux_Out,
	    i_Sel => Left_Right,
	    o_F => o_F);



end structure;