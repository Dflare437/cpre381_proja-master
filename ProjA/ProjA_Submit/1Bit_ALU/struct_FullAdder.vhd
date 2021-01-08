library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity struct_FullAdder is
   port(i_A	:	in std_logic;
		i_B : in std_logic;
		i_C : in std_logic;
		o_C	:	out std_logic;
		o_S : out std_logic);
end struct_FullAdder;

architecture structure of struct_FullAdder is

	component xorg2
	  port(i_A          : in std_logic;
			i_B			: in std_logic;
			o_F          : out std_logic);
	end component;
	
	
	component org2
	 port(i_A	: in std_logic;
			i_B : in std_logic;
			o_F	:	out std_logic);
	end component;
	
	component andg2
	 port(i_A : in std_logic;
		i_B : in std_logic;
		o_F : out std_logic);
	end component;
	
	signal xXORy, xyXORcin, xyAndcin, xAndY : std_logic;
begin
	xor1: xorg2
	 port map(i_A => i_A,
				i_B => i_B,
				o_F	=> xXORy);
		
	xor2: xorg2
	 port map(i_A => xXORy,
		i_B => i_C,
		o_F => o_S);
	
	and1: andg2
	 port map(i_A => xXORy,
				i_B => i_C,
				o_F => xyAndcin);
	
	and2:andg2
	 port map(i_A => i_A,
				i_B => i_B,
				o_F => xAndY);
				
	org1: org2
	 port map(i_A => xAndY,
				i_B => xyAndcin,
				o_F => o_C);


			
end structure;