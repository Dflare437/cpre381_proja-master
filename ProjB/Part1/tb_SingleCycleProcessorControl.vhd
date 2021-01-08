library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_SingleCycleProcessorControl is

end tb_SingleCycleProcessorControl;

architecture structure of tb_SingleCycleProcessorControl is

	component SingleCycleProcessorControl is
	port(i_OPCode, i_Function : in std_logic_vector(5 downto 0);
		ALUSrc, MemtoReg, s_DMemWr, s_RegWr, RegDst, zero_sign, logicArith, Left_Right, Alu_Shifter, LoadUpperImm, VarShift : out std_logic;
		AluControl: out std_logic_vector(3 downto 0)
		);
	end component;
	
	signal i_OPCode, i_Function : std_logic_vector(5 downto 0);
	signal ALUSrc, MemtoReg, s_DMemWr, s_RegWr, RegDst, zero_sign, logicArith, Left_Right, Alu_Shifter, LoadUpperImm, VarShift : std_logic;
	signal AluControl: std_logic_vector(3 downto 0);
	
	begin
	
	processor: SingleCycleProcessorControl
	port map(i_OPCode => i_OPCode,
				i_Function => i_Function,
				ALUSrc => ALUSrc,
				MemtoReg => MemtoReg,
				s_DMemWr => s_DMemWr,
				s_RegWr => s_RegWr,
				RegDst => RegDst,
				zero_sign => zero_sign,
				logicArith => logicArith,
				Left_Right => Left_Right,
				Alu_Shifter => Alu_Shifter,
				LoadUpperImm => LoadUpperImm,
				VarShift => VarShift,
				AluControl => AluControl
				);
				
	process 
	begin
	
	wait for 50 ns;
	--add
	i_OPCode <= "000000";
	i_Function <= "100000";
	wait for 50 ns;
	--addu
	i_Function <= "100001";
	wait for 50 ns;
	--and
	i_Function <= "100100";
	wait for 50 ns;
	--nor
	i_Function <= "100111";
	wait for 50 ns;
	--xor
	i_Function <= "100110";
	wait for 50 ns;
	--or
	i_Function <= "100101";
	wait for 50 ns;
	--slt
	i_Function <= "101010";
	wait for 50 ns;
	--sltu
	i_Function <= "101011";
	wait for 50 ns;
	--sll
	i_Function <= "000000";
	wait for 50 ns;
	--srl
	i_Function <= "000010";
	wait for 50 ns;
	--sra
	i_Function <= "000011";
	wait for 50 ns;
	--sllv
	i_Function <= "000100";
	wait for 50 ns;
	--srlv
	i_Function <= "000110";
	wait for 50 ns;
	--srav
	i_Function <= "000111";
	wait for 50 ns;
	--sub
	i_Function <= "000111";
	wait for 50 ns;
	--subu
	i_Function <= "100011";
	wait for 50 ns;
	--end of R-type instructions
	
	--addi
	i_OPCode <= "001000";
	wait for 50 ns;
	--addiu
	i_OPCode <= "001001";
	wait for 50 ns;
	--andi
	i_OPCode <= "001100";
	wait for 50 ns;
	--lui
	i_OPCode <= "001111";
	wait for 50 ns;
	--lw
	i_OPCode <= "100011";
	wait for 50 ns;
	--xori
	i_OPCode <= "001110";
	wait for 50 ns;
	--ori 
	i_OPCode <= "001101";
	wait for 50 ns;
	--slti 
	i_OPCode <= "001010";
	wait for 50 ns;
	--sltiu
	i_OPCode <= "001011";
	wait for 50 ns;
	--sw
	i_OPCode <= "101011";
	wait for 50 ns;
	
	end process;
end structure;
	