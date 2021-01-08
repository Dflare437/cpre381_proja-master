library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity OnesBit_ALU is 
	port(i_A : in std_logic;
		i_B : in std_logic;
		s_Binvert : in std_logic;
		i_Less : in std_logic;
		i_Cin : in std_logic;
		s_OPMux : in std_logic_vector(2 downto 0);
		ALU_Output : out std_logic;
		o_Cout : out std_logic
		);
		
end OnesBit_ALU;

architecture mixed of OnesBit_ALU is 
	
	
	component struct_FullAdder is
	port(i_A	:	in std_logic;
		i_B : in std_logic;
		i_C : in std_logic;
		o_C	:	out std_logic;
		o_S : out std_logic);
	end component;
	
	signal invert_B, alu_AND, alu_OR, alu_NOR, alu_NAND, alu_XOR, alu_FullAdder, alu_SLT : std_logic;
	
	begin
	
	invert_B <= not i_B when s_Binvert = '1' else
	i_B;

	alu_SLT <= i_Less;
			
	alu_AND <= i_A and invert_B;
			
	alu_OR <= i_A or invert_B;
			
	alu_NOR <= i_A nor invert_B;
	alu_NAND <= i_A nand invert_B;

	alu_XOR <= i_A xor invert_B;

	alu_FullAdder1 : struct_FullAdder
	port map(i_A => i_A,
			i_B => invert_B,
			i_C => i_Cin,
			o_C => o_Cout,
			o_S => alu_FullAdder);
	with s_OPMUX select
		ALU_Output <= alu_AND when "000",
			      alu_OR when "001",
			      alu_NOR when "010",
			      alu_NAND when "011",
			      alu_XOR when "100",
			      alu_FullAdder when "101",
			      alu_FullAdder when "110",
			      alu_SLT when "111",
			      alu_AND when others;
	
end mixed;
	