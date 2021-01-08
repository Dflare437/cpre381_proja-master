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

	signal PCinput, PC_plus_4, branch_addr, shouldBranchMuxOut, shifted_jump_concat, shouldJumpMuxOut, MuxMemToRegOut, if_id_PC_4_out, instruction_out, id_ex_rsVal, id_ex_rtVal, id_ex_ImmVal : std_logic_vector(N-1 downto 0);
	signal ex_mem_ALUOut, ex_mem_rtVal, mem_wb_ALUOut, mem_wb_dmemOut, id_ex_PC_4_out, ex_mem_PC_4_out, mem_wb_PC_4_out, jrMuxOut : std_logic_vector(N-1 downto 0);
	signal ALUSrc,AdderCout, MemtoReg, RegDst, zero_sign, logicArith, Left_Right, Alu_Shifter, LoadUpperImm, VarShift, o_ALUOverflow, o_ALUCout, o_ALUZero : std_logic;
	signal Branch, Jump, isJal, BranchEq_Ne, isJr, AdderCout2, BranchAndComparation, BranchAndNOTComparation, notComparation, shouldBranch: std_logic;
	signal comparation, DMemWr, RegWr, if_id_mem_control, id_ex_mem_control, ex_mem_mem_control, shouldNotPC4: std_logic;
	signal AluControl : std_logic_vector(3 downto 0);
	signal AluOut, Reg_Data1,Reg_Data2,Extended_Imm, AluB_Input: std_logic_vector(N-1 downto 0);
	signal id_ex_instructionOut, ex_mem_instructionOut, mem_wb_instructionOut : std_logic_vector(31 downto 0);
	signal s_shamt, VarShiftMuxOut, MuxRtOrRdOut : std_logic_vector(4 downto 0);
	signal s_shifted_imm: std_logic_vector(N+1 downto 0);
	signal shifted_jump: std_logic_vector(27 downto 0);
	signal if_id_ex_control, id_ex_ex_control: std_logic_vector(9 downto 0);
	signal if_id_wb_control, id_ex_wb_control, ex_mem_wb_control, mem_wb_wb_control: std_logic_vector(3 downto 0);
	
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
	
	component if_idRegister is
	  port(i_CLK        : in std_logic;
			PC_4	: in std_logic_vector(31 downto 0);
			instruction : in std_logic_vector(31 downto 0);
			PC_4_out	: out std_logic_vector(31 downto 0);
			instruction_out : out std_logic_vector(31 downto 0);
			if_idStall : in std_logic;
			if_idFlush : in std_logic);

	end component;
	
	component id_exRegister is
	  port(i_CLK        : in std_logic;
			mem_control : in std_logic;
			wb_control : in std_logic_vector(3 downto 0);
			ex_control : in std_logic_vector(9 downto 0);
			instruction : in std_logic_vector(31 downto 0);
			reg_rs_val	: in std_logic_vector(31 downto 0);
			reg_rt_val : in std_logic_vector(31 downto 0);
			zeroSignImm : in std_logic_vector(31 downto 0);
			PC_4 : in std_logic_vector(31 downto 0);
			reg_rs_valOut	: out std_logic_vector(31 downto 0);
			reg_rt_valOut : out std_logic_vector(31 downto 0);
			zeroSignImmOut : out std_logic_vector(31 downto 0);
			instructionOut : out std_logic_vector(31 downto 0);
			PC_4_out : out std_logic_vector(31 downto 0);
			wb_controlOut : out std_logic_vector(3 downto 0);		
			ex_controlOut : out std_logic_vector(9 downto 0);
			mem_controlOut : out std_logic;
			id_exStall : in std_logic;
			id_exFlush : in std_logic);

	end component;
	
	component ex_memRegister is
	  port(i_CLK        : in std_logic;
			mem_control : in std_logic;
			wb_control : in std_logic_vector(3 downto 0); 
			ALUOutput	: in std_logic_vector(31 downto 0);
			reg_rt_val : in std_logic_vector(31 downto 0);
			instruction : in std_logic_vector(31 downto 0);
			PC_4 : in std_logic_vector(31 downto 0);
			ALUOutputOut	: out std_logic_vector(31 downto 0);
			reg_rt_valOut : out std_logic_vector(31 downto 0);
			PC_4_out : out std_logic_vector(31 downto 0);
			instructionOut : out std_logic_vector(31 downto 0);
			wb_controlOut : out std_logic_vector(3 downto 0);
			mem_controlOut : out std_logic;
			ex_memStall : in std_logic;
			ex_memFlush : in std_logic);

	end component;
	
	component mem_wbRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
			wb_control : in std_logic_vector(3 downto 0);
			instruction : in std_logic_vector(31 downto 0);
			ALUOutput	: in std_logic_vector(31 downto 0);
			dmem	: in std_logic_vector(31 downto 0);
			PC_4 : in std_logic_vector(31 downto 0);
			ALUOutputOut	: out std_logic_vector(31 downto 0);
			dmemOut	: out std_logic_vector(31 downto 0);
			PC_4_out : out std_logic_vector(31 downto 0);
			instructionOut : out std_logic_vector(31 downto 0);
			wb_controlOut : out std_logic_vector(3 downto 0); 
			mem_wbStall : in std_logic;
			mem_wbFlush : in std_logic);

	end component;
	
	component comparator is
	port(i_A : in std_logic_vector(31 downto 0);
		 i_B : in std_logic_vector(31 downto 0);
		 comparation : out std_logic);
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

  s_Halt <='1' when (mem_wb_instructionOut(31 downto 26) = "000000") and (mem_wb_instructionOut(5 downto 0) = "001100") and (v0 = "00000000000000000000000000001010") else '0';

  -- TODO: Implement the rest of your processor below this comment!
  
	shouldNotPC4 <= shouldBranch or Jump or isJr;
  
	MuxOneCyclePC4: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => PC_plus_4,
			i_B => jrMuxOut,
			i_Sel => shouldNotPC4,
			o_F => PCinput
			);
  
  	pc:ProgramCounter
	port map(i_CLK => iCLK,
			input => PCinput,
			output => s_NextInstAddr,
			i_RST => iRST
			);
	
	adder: NBitstruct_FullAdder
	port map(i_A => x"00000004",
				i_B => s_NextInstAddr,
				i_C => '0',
				o_C => AdderCout,
				o_S => PC_plus_4
				);
				
	if_idRegister1: if_idRegister
	port map(i_CLK => iCLK,
			PC_4 => PC_plus_4,
			instruction => s_Inst,
			PC_4_out => if_id_PC_4_out,
			instruction_out => instruction_out,
			if_idStall => '0',
			if_idFlush => iRST
			);

	extender:extender_16_32
	port map(i_Zero_Sign => zero_sign,
			i_input => instruction_out(15 downto 0),
			o_F => Extended_Imm
			);
				
	shift2_ext_imm: ShiftL_2
	generic map(N => 32)
	port map(i_A => Extended_Imm,
			 o_F => s_shifted_imm
			 );
	
	adder2: NBitstruct_FullAdder
	port map(i_A => if_id_PC_4_out,
				i_B => s_shifted_imm(31 downto 0),
				i_C => '0',
				o_C => AdderCout2,
				o_S => branch_addr
				);
	
	comparator1: comparator
	port map(i_A => Reg_Data1,
		 i_B => Reg_Data2,
		 comparation => comparation);
	
	andg_BranchAndComparation: andg2
	port map(i_A => Branch,
				i_B => comparation,
				o_F => BranchAndComparation
			);
	
	invg_NotALUZero: invg
	port map(i_A => comparation,
				o_F => notComparation
			);
	
	andg_BranchAndNotComparation: andg2
	port map(i_A => Branch,
				i_B => notComparation,
				o_F => BranchAndNOTComparation
			);
	
	MuxBranchEq_Ne: two_one_MUX
	port map(i_A => BranchAndComparation,
				i_B => BranchAndNOTComparation,
				i_Sel => BranchEq_Ne,
				o_F => shouldBranch
			);
	
	MuxPCPlus4OrBranch: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => if_id_PC_4_out,
			i_B => branch_addr,
			i_Sel => shouldBranch,
			o_F => shouldBranchMuxOut
			);
			
	jumpAddrShift2: ShiftL_2
	generic map(N => 26)
	port map(i_A => instruction_out(25 downto 0),
			 o_F => shifted_jump
			 );
	
	shifted_jump_concat <= if_id_PC_4_out(31 downto 28) & shifted_jump;
	
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
			o_F => jrMuxOut
			);
			
	control:SingleCycleProcessorControl	
	port map(i_OPCode => instruction_out(31 downto 26),
			i_Function => instruction_out(5 downto 0),
			ALUSrc => ALUSrc,
			MemtoReg => MemtoReg,
			s_DMemWr => DMemWr,
			s_RegWr => RegWr,
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
	
	if_id_ex_control <= ALUSrc & Alu_Shifter & Left_Right & logicArith & AluControl & VarShift & LoadUpperImm;
	if_id_wb_control <= isJal & MemtoReg & RegDst & RegWr;
	if_id_mem_control <= DMemWr;
	
	RegisterFile: Register_File
	port map(Reset => iRST,
			RegWrite => s_RegWr,
			CLK => iCLK,
			Data_in =>s_RegWrData,
			Write_Register => s_RegWrAddr,
			Read_Register_1 => instruction_out(25 downto 21),
			Read_Register_2 => instruction_out(20 downto 16),
			Read_Data_1 => Reg_Data1,
			Read_Data_2 => Reg_Data2,
			Reg2 => v0
			);
			
	id_exRegister1: id_exRegister
	  port map(i_CLK => iCLK,
			mem_control => if_id_mem_control,
			wb_control => if_id_wb_control,
			instruction => instruction_out,
			ex_control => if_id_ex_control,
			reg_rs_val => Reg_Data1,
			reg_rt_val => Reg_Data2,
			zeroSignImm => Extended_Imm,
			PC_4 => if_id_PC_4_out,
			reg_rs_valOut => id_ex_rsVal,
			reg_rt_valOut => id_ex_rtVal,
			zeroSignImmOut => id_ex_ImmVal,
			PC_4_out => id_ex_PC_4_out,
			wb_controlOut => id_ex_wb_control,
			instructionOut => id_ex_instructionOut,			
			ex_controlOut => id_ex_ex_control,
			mem_controlOut => id_ex_mem_control,
			id_exStall => '0',
			id_exFlush => iRST
			);
	
	MuxAluSource: N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => id_ex_rtVal,
			i_B => id_ex_ImmVal,
			i_Sel => id_ex_ex_control(9),
			o_F => AluB_Input
			);
			
	AluWithBarrel:ALU_W_Barrel 
	port map(i_A => id_ex_rsVal,
			i_B => AluB_Input,
			s_OPMUX => id_ex_ex_control(5 downto 2),
			Logical_Arithmatic => id_ex_ex_control(6),
			Left_Right => id_ex_ex_control(7),
			alu_shifter => id_ex_ex_control(8),
			i_shamt => s_shamt,
			o_F => AluOut,
			o_ALUOverflow => o_ALUOverflow,
			o_ALUCout => o_ALUCout,
			o_ALUZero => o_ALUZero
			);
	oALUOut <= AluOut;
	
	MuxVarShift: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A => id_ex_instructionOut(10 downto 6),
			i_B => id_ex_rsVal(4 downto 0),
			i_Sel => id_ex_ex_control(1),
			o_F => VarShiftMuxOut
			);
			
	MuxLoadUpperImm: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A =>VarShiftMuxOut,
			i_B => "10000",
			i_Sel => id_ex_ex_control(0),
			o_F => s_shamt
			);
	
	ex_memRegister1: ex_memRegister
	port map(i_CLK => iCLK,
			 mem_control => id_ex_mem_control,
			 wb_control => id_ex_wb_control,
			 instruction => id_ex_instructionOut,
			 ALUOutput => AluOut,
			 reg_rt_val => id_ex_rtVal,
			 PC_4 => id_ex_PC_4_out,
			 ALUOutputOut => ex_mem_ALUOut,
			 reg_rt_valOut => ex_mem_rtVal,
			 PC_4_out => ex_mem_PC_4_out,
			 wb_controlOut => ex_mem_wb_control,
			 instructionOut => ex_mem_instructionOut,
			 mem_controlOut => ex_mem_mem_control,
			 ex_memStall => '0',
			 ex_memFlush => iRST
			 );
	
	s_DMemData <= ex_mem_rtVal;
	s_DMemAddr <= ex_mem_ALUOut;
	s_DMemWr <= ex_mem_mem_control and not iRST;
	
	mem_wbRegister1: mem_wbRegister
	port map(i_CLK => iCLK,
			 wb_control => ex_mem_wb_control,
			 instruction => ex_mem_instructionOut,
			 ALUOutput => ex_mem_ALUOut,
			 dmem => s_DMemOut,
			 PC_4 => ex_mem_PC_4_out,
			 ALUOutputOut => mem_wb_ALUOut,
			 dmemOut => mem_wb_dmemOut,
			 PC_4_out => mem_wb_PC_4_out,
			 wb_controlOut => mem_wb_wb_control,
			 instructionOut => mem_wb_instructionOut,
			 mem_wbStall => '0',
			 mem_wbFlush => iRST
			 );
	
	MuxMemToReg:N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => mem_wb_ALUOut,
			i_B => mem_wb_dmemOut,
			i_Sel => mem_wb_wb_control(2),
			o_F => MuxMemToRegOut
			);
			
	MuxRegDst: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A => mem_wb_instructionOut(20 downto 16),
			i_B => mem_wb_instructionOut(15 downto 11),
			i_Sel => mem_wb_wb_control(1),
			o_F => MuxRtOrRdOut
			);
	
	MuxJalMemToReg:N_bit_2_1_MUX
	generic map(N => 32)
	port map(i_A => MuxMemToRegOut,
			i_B => mem_wb_PC_4_out,
			i_Sel => mem_wb_wb_control(3),
			o_F => s_RegWrData
			);
	
	MuxJalRegDst: N_bit_2_1_MUX
	generic map(N => 5)
	port map(i_A => MuxRtOrRdOut,
			i_B => "11111",
			i_Sel => mem_wb_wb_control(3),
			o_F => s_RegWrAddr
			);
	
	s_RegWr <= mem_wb_wb_control(0) and not iRST;
	
end structure;
