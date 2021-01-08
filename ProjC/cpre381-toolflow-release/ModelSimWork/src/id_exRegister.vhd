library IEEE;
use IEEE.std_logic_1164.all;

entity id_exRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
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

end id_exRegister;

architecture structure of id_exRegister is

	component onebitdff is

	port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

	end component;


	component Nbit_dff is
	generic(N:integer);
	port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

	end component;
	
	
	component invg

	port(i_A          : in std_logic;
		o_F          : out std_logic);

	end component;
	
	signal not_id_exStall : std_logic;

	begin
	
	invg1 : invg
	port map(i_A => id_exStall,
			o_F => not_id_exStall);
			
	Nbit_dff1 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => reg_rs_val,
			o_Q => reg_rs_valOut);
			
	Nbit_dff2 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => reg_rt_val,
			o_Q => reg_rt_valOut);
			
	Nbit_dff3 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => zeroSignImm,
			o_Q => zeroSignImmOut);
			
	Nbit_dff4 : Nbit_dff
	generic map(N => 10)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => ex_control,
			o_Q => ex_controlOut);
			
	Nbit_dff5 : Nbit_dff
	generic map(N => 4)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => wb_control,
			o_Q => wb_controlOut);
			
	Nbit_dff6 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => instruction,
			o_Q => instructionOut);	
	
	Nbit_dff7 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => PC_4,
			o_Q => PC_4_out);
			
	onebitdff1 : onebitdff
	port map(i_CLK => i_CLK,
			i_RST => id_exFlush,
			i_WE => not_id_exStall,
			i_D => mem_control,
			o_Q => mem_controlOut);
	
	end structure;		