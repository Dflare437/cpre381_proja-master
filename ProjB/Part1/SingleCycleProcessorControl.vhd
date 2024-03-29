library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SingleCycleProcessorControl is
	port(i_OPCode, i_Function : in std_logic_vector(5 downto 0);
		ALUSrc, MemtoReg, s_DMemWr, s_RegWr, RegDst, zero_sign, logicArith, Left_Right, Alu_Shifter, LoadUpperImm, VarShift : out std_logic;
		AluControl: out std_logic_vector(3 downto 0)
		);
end SingleCycleProcessorControl;

architecture mixed of SingleCycleProcessorControl is

begin

process(i_OPCode, i_Function)
	begin
		if(i_OPCode = "000000") then
			if(i_Function = "100000") then
			ALUSrc <= '0';
			AluControl <= "0101";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			elsif(i_Function = "100001") then
			ALUSrc <= '0';
			AluControl <= "1101";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "100100") then
			ALUSrc <= '0';
			AluControl <= "0000";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "100111") then
			ALUSrc <= '0';
			AluControl <= "0010";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "100110") then
			ALUSrc <= '0';
			AluControl <= "0100";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "100101") then
			ALUSrc <= '0';
			AluControl <= "0001";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "101010") then
			ALUSrc <= '0';
			AluControl <= "0111";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "101011") then
			ALUSrc <= '0';
			AluControl <= "1111";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			elsif(i_Function = "000000") then
			ALUSrc <= '0';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			logicArith <= '0';
			Left_Right <= '0';
			Alu_Shifter <= '1';
			LoadUpperImm <= '0';
			VarShift <= '0';
			
			elsif(i_Function = "000010") then
			ALUSrc <= '0';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			logicArith <= '0';
			Left_Right <= '1';
			Alu_Shifter <= '1';
			LoadUpperImm <= '0';
			VarShift <= '0';
			
			elsif(i_Function = "000011") then
			ALUSrc <= '0';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			logicArith <= '1';
			Left_Right <= '1';
			Alu_Shifter <= '1';
			LoadUpperImm <= '0';
			VarShift <= '0';
			
			elsif(i_Function = "000100") then
			ALUSrc <= '0';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			logicArith <= '0';
			Left_Right <= '0';
			Alu_Shifter <= '1';
			LoadUpperImm <= '0';
			VarShift <= '1';
			
			elsif(i_Function = "000110") then
			ALUSrc <= '0';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			logicArith <= '0';
			Left_Right <= '1';
			Alu_Shifter <= '1';
			LoadUpperImm <= '0';
			VarShift <= '1';
			
			elsif(i_Function = "000111") then
			ALUSrc <= '0';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			logicArith <= '1';
			Left_Right <= '1';
			Alu_Shifter <= '1';
			LoadUpperImm <= '0';
			VarShift <= '1';
			
			elsif(i_Function = "100010") then
			ALUSrc <= '0';
			AluControl <= "0110";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			else
			ALUSrc <= '0';
			AluControl <= "1110";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '1';
			Alu_Shifter <= '0';
			
			end if;
		elsif(i_OPCode = "001000") then
			ALUSrc <= '1';
			AluControl <= "0101";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '1';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001001") then
			ALUSrc <= '1';
			AluControl <= "1101";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '1';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001100") then
			ALUSrc <= '1';
			AluControl <= "0000";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '0';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001111") then
			ALUSrc <= '1';
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			logicArith <= '0';
			Left_Right <= '0';
			Alu_Shifter <= '1';
			LoadUpperImm <= '1';
		
		elsif(i_OPCode = "100011") then
			ALUSrc <= '1';
			AluControl <= "0101";
			MemtoReg <= '1';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '1';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001110") then
			ALUSrc <= '1';
			AluControl <= "0100";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '0';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001101") then
			ALUSrc <= '1';
			AluControl <= "0001";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '0';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001010") then
			ALUSrc <= '1';
			AluControl <= "0111";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '1';
			Alu_Shifter <= '0';
		
		elsif(i_OPCode = "001011") then
			ALUSrc <= '1';
			AluControl <= "1111";
			MemtoReg <= '0';
			s_DMemWr <= '0';
			s_RegWr <= '1';
			RegDst <= '0';
			zero_sign <= '1';
			Alu_Shifter <= '0';
		
		else
			ALUSrc <= '1';
			AluControl <= "0101";
			s_DMemWr <= '1';
			s_RegWr <= '0';
			zero_sign <= '1';
			Alu_Shifter <= '0';
		
		end if;
end process;
end mixed;