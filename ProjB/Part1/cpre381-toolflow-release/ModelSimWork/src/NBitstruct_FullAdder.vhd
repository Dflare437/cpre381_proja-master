library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity NBitstruct_FullAdder is
	generic(N: integer:=32);
   port(i_A	:	in std_logic_vector(N-1 downto 0);
		i_B : in std_logic_vector(N-1 downto 0);
		i_C : in std_logic;
		o_C	:	out std_logic;
		o_S : out std_logic_vector(N-1 downto 0));
end NBitstruct_FullAdder;

architecture structure of NBitstruct_FullAdder is

	component struct_FullAdder
	 port(i_A : in std_logic;
			i_B : in std_logic;
			i_C : in std_logic;
			o_C : out std_logic;
			o_S : out std_logic);
	end component;
	
	signal ripple : std_logic_vector(N downto 0);
begin

	ripple(0) <= i_C;	
	g_FA: for i in 0 to N-1 generate
	FA1: struct_FullAdder
	 port map(i_A => i_A(i),
				i_B => i_B(i),
				i_C	=> ripple(i),
				o_C => ripple(i+1),
				o_S => o_S(i));
		
end generate;		

o_C <= ripple(N);

			
end structure;
