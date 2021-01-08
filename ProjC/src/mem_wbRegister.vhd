library IEEE;
use IEEE.std_logic_1164.all;

entity mem_wbRegister is
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

end mem_wbRegister;

architecture structure of mem_wbRegister is

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
	
	signal not_mem_wbStall : std_logic;
	
	begin
	
	invg1 : invg
	port map(i_A => mem_wbStall,
			o_F => not_mem_wbStall);
			
	Nbit_dff1 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => mem_wbFlush,
			i_WE => not_mem_wbStall,
			i_D => ALUOutput,
			o_Q => ALUOutputOut);
			
	Nbit_dff2 : Nbit_dff
	generic map(N => 32)
	port map(i_CLK => i_CLK,
			i_RST => mem_wbFlush,
			i_WE => not_mem_wbStall,
			i_D => dmem,
			o_Q => dmemOut);
			
	Nbit_dff3 : Nbit_dff
	generic map(N => 3)
	port map(i_CLK => i_CLK,
			i_RST => mem_wbFlush,
			i_WE => not_mem_wbStall,
			i_D => wb_control,
			o_Q => wb_controlOut);
			
	Nbit_dff4 : Nbit_dff
	generic map(N => 5)
	port map(i_CLK => i_CLK,
			i_RST => mem_wbFlush,
			i_WE => not_mem_wbStall,
			i_D => rdAddr,
			o_Q => rdAddrOut);		
			
	Nbit_dff5 : Nbit_dff
	generic map(N => 5)
	port map(i_CLK => i_CLK,
			i_RST => mem_wbFlush,
			i_WE => not_mem_wbStall,
			i_D => rtAddr,
			o_Q => rtAddrOut);			
			
	
	end structure;		