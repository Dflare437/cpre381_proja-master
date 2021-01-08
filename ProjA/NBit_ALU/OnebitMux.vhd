library IEEE;
use IEEE.std_logic_1164.all;

entity OnebitMux is
	port(i_A : in std_logic;
		i_B	: in std_logic;
		i_S	: in std_logic;
		o_X : out std_logic);
		
end OnebitMux;

architecture structure of OnebitMux is

	component invg
	port(i_A : in std_logic;

		o_F	: out std_logic);
	end component;
	
	component org2
	port(i_A :	in std_logic;
		i_B :	in std_logic;
		o_F :	out std_logic);
	end component;
	
	component andg2
	port(i_A :	in std_logic;
		i_B :	in std_logic;
		o_F :	out std_logic);
	end component;
	
	signal notG : std_logic;
	signal andGA : std_logic;
	signal andGB : std_logic;
	signal orG : std_logic;
	
	begin
	
	inv1: invg
		port map(i_A => i_S,
				o_F => notG);
				
	and1: andg2
		port map(i_A => notG,
				i_B => i_A,
				o_F => andGA);
	
	and2: andg2
		port map(i_A => i_S,
				i_B => i_B,
				o_F => andGB);
				
	or1 : org2
		port map(i_A => andGA,
				i_B => andGB,
				o_F => o_X);
				
end structure;