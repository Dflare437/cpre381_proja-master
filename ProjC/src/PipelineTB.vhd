library IEEE;
use IEEE.std_logic_1164.all;

entity PipelineTB is
		 generic(gCLK_HPER   : time := 50 ns);
end PipelineTB;

architecture structure of PipelineTB is

	component if_idRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
			PC_4	: in std_logic_vector(31 downto 0);
			instruction : in std_logic_vector(31 downto 0);
			PC_4_out	: out std_logic_vector(31 downto 0);
			instruction_out : out std_logic_vector(31 downto 0);
			if_idStall : in std_logic;
			if_idFlush : in std_logic);

	end component;
	
	component id_exRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
			mem_control : in std_logic;
			wb_control : in std_logic_vector(2 downto 0);
			rdAddr : in std_logic_vector(4 downto 0);
			rtAddr : in std_logic_vector(4 downto 0);
			shamt : in std_logic_vector(4 downto 0);
			ex_control : in std_logic_vector(9 downto 0);
			reg_rs_val	: in std_logic_vector(31 downto 0);
			reg_rt_val : in std_logic_vector(31 downto 0);
			zeroSignImm : in std_logic_vector(31 downto 0);
			reg_rs_valOut	: out std_logic_vector(31 downto 0);
			reg_rt_valOut : out std_logic_vector(31 downto 0);
			zeroSignImmOut : out std_logic_vector(31 downto 0);
			wb_controlOut : out std_logic_vector(2 downto 0);
			rdAddrOut : out std_logic_vector(4 downto 0);
			rtAddrOut : out std_logic_vector(4 downto 0);
			shamtOut : out std_logic_vector(4 downto 0);
			ex_controlOut : out std_logic_vector(9 downto 0);
			mem_controlOut : out std_logic;
			id_exStall : in std_logic;
			id_exFlush : in std_logic);

	end component;
	
	component ex_memRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
			mem_control : in std_logic;
			wb_control : in std_logic_vector(2 downto 0);
			rdAddr : in std_logic_vector(4 downto 0);
			rtAddr : in std_logic_vector(4 downto 0); 
			ALUOutput	: in std_logic_vector(31 downto 0);
			reg_rt_val : in std_logic_vector(31 downto 0);
			ALUOutputOut	: out std_logic_vector(31 downto 0);
			reg_rt_valOut : out std_logic_vector(31 downto 0);
			wb_controlOut : out std_logic_vector(2 downto 0);
			rdAddrOut : out std_logic_vector(4 downto 0);
			rtAddrOut : out std_logic_vector(4 downto 0); 
			mem_controlOut : out std_logic;
			ex_memStall : in std_logic;
			ex_memFlush : in std_logic);

	end component;
	
	component mem_wbRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
			wb_control : in std_logic_vector(2 downto 0);
			rdAddr : in std_logic_vector(4 downto 0);
			rtAddr : in std_logic_vector(4 downto 0); 
			ALUOutput	: in std_logic_vector(31 downto 0);
			dmem	: in std_logic_vector(31 downto 0);
			ALUOutputOut	: out std_logic_vector(31 downto 0);
			dmemOut	: out std_logic_vector(31 downto 0);
			wb_controlOut : out std_logic_vector(2 downto 0);
			rdAddrOut : out std_logic_vector(4 downto 0);
			rtAddrOut : out std_logic_vector(4 downto 0); 
			mem_wbStall : in std_logic;
			mem_wbFlush : in std_logic);

	end component;
	
	signal i_CLK, if_idFlush, if_idStall, id_exStall, id_exFlush, ex_memFlush, ex_memStall, mem_wbFlush, mem_wbStall, id_ex_mem_controlOut, ex_mem_mem_controlOut : std_logic;
	signal if_id_PC_4, if_id_PC_4_out, if_id_instruction, if_id_instruction_out, id_ex_reg_rs_val, id_ex_reg_rs_valOut, id_ex_reg_rt_val, id_ex_reg_rt_valOut, id_ex_zeroSignImm, id_ex_zeroSignImmOut : std_logic_vector(31 downto 0);
	signal ex_mem_ALUOutput, ex_mem_ALUOutputOut, ex_mem_reg_rt_val, ex_mem_reg_rt_valOut, mem_wb_ALUOutput, mem_wb_ALUOutputOut, mem_wb_dmem, mem_wb_dmemOut : std_logic_vector(31 downto 0);
	signal id_ex_wb_controlOut, ex_mem_wb_controlOut, mem_wb_wb_controlOut : std_logic_vector(2 downto 0);
	signal id_ex_rdAddrOut, id_ex_rtAddrOut, ex_mem_rdAddrOut, ex_mem_rtAddrOut, mem_wb_rdAddrOut, mem_wb_rtAddrOut, id_ex_shamtOut: std_logic_vector(4 downto 0);
	signal id_ex_ex_controlOut : std_logic_vector(9 downto 0);
	
	begin
	
	register1 : if_idRegister
	port map(i_CLK => i_CLK,
			PC_4 => if_id_PC_4,
			instruction => if_id_instruction,
			PC_4_out => if_id_PC_4_out,
			instruction_out => if_id_instruction_out,
			if_idStall => if_idStall,
			if_idFlush => if_idFlush);
	
	-- We made mem_control most signaficant bit of the instruction
	-- We made wb_control the 3 most significant bits of the instruction
	-- We made ex_control the 10 most significant bits of the instruction
	-- We made the reg_rs_val, reg_rt_val, and zeroSignImm all the PC+4 out.
	-- rdAddr and rtAddr corrospond to where it would in instruction
	
	register2 : id_exRegister
	port map(i_CLK => i_CLK,
			mem_control => if_id_instruction_out(31),
			wb_control => if_id_instruction_out(31 downto 29),
			rdAddr => if_id_instruction_out(15 downto 11),
			rtAddr => if_id_instruction_out(20 downto 16),
			shamt => if_id_instruction_out(10 downto 6),
			ex_control => if_id_instruction_out(31 downto 22),
			reg_rs_val => if_id_PC_4_out,
			reg_rt_val => if_id_PC_4_out,
			zeroSignImm => if_id_PC_4_out,
			reg_rs_valOut => id_ex_reg_rs_valOut,
			reg_rt_valOut => id_ex_reg_rt_valOut,
			wb_controlOut => id_ex_wb_controlOut,
			rdAddrOut => id_ex_rdAddrOut,
			rtAddrOut => id_ex_rtAddrOut,
			shamtOut => id_ex_shamtOut,
			zeroSignImmOut => id_ex_zeroSignImmOut,
			ex_controlOut => id_ex_ex_controlOut,
			mem_controlOut => id_ex_mem_controlOut,
			id_exStall => id_exStall,
			id_exFlush => id_exFlush);
	
	register3 : ex_memRegister
	port map(i_CLK => i_CLK,
			mem_control => id_ex_mem_controlOut,
			wb_control => id_ex_wb_controlOut,
			rdAddr => id_ex_rdAddrOut,
			rtAddr => id_ex_rtAddrOut,
			ALUOutput => ex_mem_ALUOutput,
			reg_rt_val => id_ex_reg_rt_valOut,
			reg_rt_valOut => ex_mem_reg_rt_valOut,
			wb_controlOut => ex_mem_wb_controlOut,
			rdAddrOut => ex_mem_rdAddrOut,
			rtAddrOut => ex_mem_rtAddrOut,
			ALUOutputOut => ex_mem_ALUOutputOut,
			mem_controlOut => ex_mem_mem_controlOut,
			ex_memStall => ex_memStall,
			ex_memFlush => ex_memFlush);
			
	-- ALUOutput and dmem are signal we're manually driving		
	
	register4 : mem_wbRegister
	port map(i_CLK => i_CLK,
			wb_control => ex_mem_wb_controlOut,
			rdAddr => ex_mem_rdAddrOut,
			rtAddr => ex_mem_rtAddrOut,
			ALUOutput => ex_mem_ALUOutputOut,
			dmem => mem_wb_dmem,
			ALUOutputOut => mem_wb_ALUOutputOut,
			dmemOut => mem_wb_dmemOut,
			wb_controlOut => mem_wb_wb_controlOut,
			rdAddrOut => mem_wb_rdAddrOut,
			rtAddrOut => mem_wb_rtAddrOut,
			mem_wbStall => mem_wbStall,
			mem_wbFlush => mem_wbFlush);
			
	P_CLK: process
	begin
	i_CLK <= '0';
	wait for gCLK_HPER;
	i_CLK <= '1';
	wait for gCLK_HPER;
	end process;
	
	test: process
	begin
	if_idFlush <= '1';
	id_exFlush <= '1';
	ex_memFlush <= '1';
	mem_wbFlush <= '1';
	if_idStall <= '0';
	id_exStall <= '0';
	ex_memStall <= '0';
	mem_wbStall <= '0';
	wait for gCLK_HPER;
	wait for gCLK_HPER;
	
	if_idFlush <= '0';
	id_exFlush <= '0';
	ex_memFlush <= '0';
	mem_wbFlush <= '0';
	if_id_PC_4 <= x"00001111";
	if_id_instruction <= x"00001111";
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	if_id_PC_4 <= x"00002222";
	if_id_instruction <= x"00002222";
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	if_id_PC_4 <= x"00003333";
	if_id_instruction <= x"00003333";
	ex_mem_ALUOutput <= x"00003333";
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	if_id_PC_4 <= x"00004444";
	if_id_instruction <= x"00004444";
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	if_idStall <= '1';
	id_exStall <= '1';
	ex_memStall <= '1';
	mem_wbStall <= '1';
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	if_idFlush <= '1';
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	id_exFlush <= '1';
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	ex_memFlush <= '1';
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	mem_wbFlush <= '1';
	wait for gCLK_HPER;	
	wait for gCLK_HPER;
	
	end process;
end structure;
	