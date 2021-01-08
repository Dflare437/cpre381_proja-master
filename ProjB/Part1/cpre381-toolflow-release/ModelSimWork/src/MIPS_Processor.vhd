-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;
	
  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

	signal PCinput, PC_plus_4, branch_addr, shouldBranchMuxOut, shifted_jump_concat, shouldJumpMuxOut, MuxMemToRegOut : std_logic_vector(N-1 downto 0);
	signal ALUSrc,AdderCout, MemtoReg, RegDst, zero_sign, logicArith, Left_Right, Alu_Shifter, LoadUpperImm, VarShift, o_ALUOverflow, o_ALUCout, o_ALUZero, reg_wren, dmem_wren : std_logic;
	signal Branch, Jump, isJal, BranchEq_Ne, isJr, AdderCout2, BranchAndALUZero, BranchAndNOTALUZero, notALUZero, shouldBranch: std_logic;
	signal AluControl : std_logic_vector(3 downto 0);
	signal AluOut, Reg_Data1,Reg_Data2,Extended_Imm, AluB_Input: std_logic_vector(N-1 downto 0);
	signal s_shamt, VarShiftMuxOut, MuxRtOrRdOut : std_logic_vector(4 downto 0);
	signal s_shifted_imm: std_logic_vector(N+1 downto 0);
	signal shifted_jump: std_logic_vector(27 downto 0);
	
	component ProgramCounter is
	generic(N: integer :=  32);
	port(input : in std_logic_vector(N-1 downto 0);
		i_RST : in std_logic;
		i_CLK : in std_logic;
		output : out std_logic_vector(N-1 downto 0));
	end component;
	
	component NBitstruct_FullAdder is
	generic(N: integer:=32);
	port(i_A	:	in std_logic_vector(N-1 downto 0);
		i_B : in std_logic_vector(N-1 downto 0);
		i_C : in std_logic;
		o_C	:	out std_logic;
		o_S : out std_logic_vector(N-1 downto 0));
	end component;
	
	component SingleCycleProcessorControl is
	port(i_OPCode, i_Function : in std_logic_vector(5 downto 0);
		ALUSrc, MemtoReg, s_DMemWr, s_RegWr, RegDst, zero_sign, logicArith, Left_Right, Alu_Shifter, LoadUpperImm, VarShift, Branch, Jump, isJal, BranchEq_Ne, isJr : out std_logic;
		AluControl: out std_logic_vector(3 downto 0)
		);
	end component;
	
	component N_bit_2_1_MUX is
	generic(N : integer);
	port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       i_Sel : in std_logic;
       o_F  : out std_logic_vector(N-1 downto 0));

	end component;
	
	component extender_16_32 is

	port(i_Zero_Sign : std_logic;
       i_input : in std_logic_vector(15 downto 0);
       o_F : out std_logic_vector(31 downto 0));

	end component;
	
	component Register_File is
	generic(N : integer := 32);
	port(Reset  : in std_logic;
       RegWrite  : in std_logic;
       CLK  : in std_logic;
       Data_in  : in  std_logic_vector (N-1 downto 0);
       Write_Register : in std_logic_vector(4 downto 0);
       Read_Register_1 : in std_logic_vector(4 downto 0);
       Read_Register_2 : in std_logic_vector(4 downto 0);
       Read_Data_1 : out std_logic_vector(N-1 downto 0);
       Read_Data_2 : out std_logic_vector(N-1 downto 0);
	   Reg2 : out std_logic_vector(N-1 downto 0));
	end component;
	
	component ALU_W_Barrel is 
	generic(N : integer := 32);
	port(i_A  : in std_logic_vector(N-1 downto 0);
       i_B  : in std_logic_vector(N-1 downto 0);
       s_OPMUX : in std_logic_vector(3 downto 0);
       Logical_Arithmatic : in std_logic;
       Left_Right, alu_shifter : in std_logic;
       i_shamt : in std_logic_vector(4 downto 0);
       o_F : out std_logic_vector(N-1 downto 0);
       o_ALUOverflow: out std_logic;
       o_ALUCout: out std_logic;
       o_ALUZero : out std_logic);
	end component;
	
	component ShiftL_2 is
	generic(N : integer);
	port(i_A : in std_logic_vector(N-1 downto 0);
	   o_F : out std_logic_vector(N+1 downto 0));
	end component;
	
	component andg2 is
	port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
	end component;
	
	component invg is
	port(i_A          : in std_logic;
       o_F          : out std_logic);
	end component;
	
	component two_one_MUX is
	port(i_A  : in std_logic;
       i_B  : in std_logic;
       i_Sel  : in std_logic;
       o_F  : out std_logic);
	end component;
	
begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  s_Halt <='1' when (s_Inst(31 downto 26) = "000000") and (s_Inst(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment! 
	
	adder: NBitstruct_FullAdder
	port map(i_A => x"00000004",
				i_B => s_NextInstAddr,
				i_C => '0',
				o_C => AdderCout,
				o_S => PC_plus_4
				);
				
	shift2_ext_imm: ShiftL_2
	generic map(N => 32)
	port map(i_A => Extended_Imm,
			 o_F => s_shifted_imm
			 );
	
	adder2: NBitstruct_FullAdder
	port map(i_A => PC_plus_4,
				i_B => s_shifted_imm(31 downto 0),
				i_C => '0',
				o_C => AdderCout2,
				o_S => branch_addr
				);
	
	andg_BranchAndALUZero: andg2
	port map(i_A => Branch,
				i_B => o_ALUZero,
				o_F => BranchAndALUZero
			);
	
	invg_NotALUZero: invg
	port map(i_A => o_ALUZero,
				o_F => notALUZero
			);
	
	andg_BranchAndNotALUZero: andg2
	port map(i_A => Branch,
				i_B => notALUZero,
				o_F => BranchAndNOTALUZero
			);
	
	MuxBranchEq_Ne: two_one_MUX
	port map(i_A => BranchAndALUZero,
				i_B => BranchAndNOTALUZero,
				i_Sel => BranchEq_Ne,
				o_F => shouldBranch
			);
	
	MuxPCPlus4OrBranch: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => PC_plus_4,
			i_B => branch_addr,
			i_Sel => shouldBranch,
			o_F => shouldBranchMuxOut
			);
			
	jumpAddrShift2: ShiftL_2
	generic map(N => 26)
	port map(i_A => s_Inst(25 downto 0),
			 o_F => shifted_jump
			 );
	
	shifted_jump_concat <= PC_plus_4(31 downto 28) & shifted_jump;
	
	MuxShouldJump: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => shouldBranchMuxOut,
			i_B => shifted_jump_concat,
			i_Sel => Jump,
			o_F => shouldJumpMuxOut
			);
	
	MuxFinalPCInput: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => shouldJumpMuxOut,
			i_B => Reg_Data1,
			i_Sel => isJr,
			o_F => PCinput
			);
	
	pc:ProgramCounter
	port map(i_CLK => iCLK,
			input => PCinput,
			output => s_NextInstAddr,
			i_RST => iRST
			);
			
	control:SingleCycleProcessorControl	
	port map(i_OPCode => s_Inst(31 downto 26),
			i_Function => s_Inst(5 downto 0),
			ALUSrc => ALUSrc,
			MemtoReg => MemtoReg,
			s_DMemWr => dmem_wren,
			s_RegWr => reg_wren,
			RegDst => RegDst,
			zero_sign => zero_sign,
			logicArith => logicArith,
			Left_Right => Left_Right,
			Alu_Shifter => Alu_Shifter,
			LoadUpperImm => LoadUpperImm,
			VarShift => VarShift,
			AluControl => AluControl,
			Branch => Branch,
			Jump => Jump,
			isJal => isJal,
			BranchEq_Ne => BranchEq_Ne,
			isJr => isJr
			);
			
	MuxMemToReg:N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => AluOut,
			i_B => s_DMemOut,
			i_Sel => MemtoReg,
			o_F => MuxMemToRegOut
			);
			
	MuxJalMemToReg:N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => MuxMemToRegOut,
			i_B => PC_plus_4,
			i_Sel => isJal,
			o_F => s_RegWrData
			);
			
	MuxRegDst: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A => s_Inst(20 downto 16),
			i_B => s_Inst(15 downto 11),
			i_Sel => RegDst,
			o_F => MuxRtOrRdOut
			);
			
	MuxJalRegDst: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A => MuxRtOrRdOut,
			i_B => "11111",
			i_Sel => isJal,
			o_F => s_RegWrAddr
			);

	s_RegWr <= reg_wren and not iRST;
	s_DMemWr <= dmem_wren and not iRST;
	
	RegisterFile: Register_File
	port map(Reset => iRST,
			RegWrite => s_RegWr,
			CLK => iCLK,
			Data_in =>s_RegWrData,
			Write_Register => s_RegWrAddr,
			Read_Register_1 => s_Inst(25 downto 21),
			Read_Register_2 => s_Inst(20 downto 16),
			Read_Data_1 => Reg_Data1,
			Read_Data_2 => Reg_Data2,
			Reg2 => v0
			);
	
	extender:extender_16_32
	port map(i_Zero_Sign =>zero_sign,
			i_input => s_Inst(15 downto 0),
			o_F => Extended_Imm
			);
	
	MuxAluSource: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => Reg_Data2,
			i_B => Extended_Imm,
			i_Sel => ALUSrc,
			o_F => AluB_Input
			);
			
	AluWithBarrel:ALU_W_Barrel 
	port map(i_A => Reg_Data1,
			i_B => AluB_Input,
			s_OPMUX => AluControl,
			Logical_Arithmatic => logicArith,
			Left_Right => Left_Right,
			alu_shifter => Alu_Shifter,
			i_shamt => s_shamt,
			o_F => AluOut,
			o_ALUOverflow => o_ALUOverflow,
			o_ALUCout => o_ALUCout,
			o_ALUZero => o_ALUZero
			);
	oALUOut <= AluOut;
	
	MuxVarShift: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A => s_Inst(10 downto 6),
			i_B => Reg_Data1(4 downto 0),
			i_Sel => VarShift,
			o_F => VarShiftMuxOut
			);
			
	MuxLoadUpperImm: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A =>VarShiftMuxOut,
			i_B => "10000",
			i_Sel => LoadUpperImm,
			o_F => s_shamt
			);
	
	s_DMemData <= Reg_Data2;
	s_DMemAddr <= AluOut;
	
	
end structure;
