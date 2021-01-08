library IEEE;
use IEEE.std_logic_1164.all;

entity if_idRegister is
	  port(i_CLK        : in std_logic;     -- Clock input
			PC_4	: in std_logic_vector(31 downto 0);
			instruction : in std_logic_vector(31 downto 0);
			PC_4_out	: out std_logic_vector(31 downto 0);
			instruction_out : out std_logic_vector(31 downto 0);
			if_idStall : in std_logic;
			if_idFlush : in std_logic);

end if_idRegister;

architecture structure of if_idRegister is

	component Nbit_dff is
	generic(N : integer := 32);
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
	
	signal not_if_idStall : std_logic;
	
	begin
	
	invg1 : invg
	port map(i_A => if_idStall,
			o_F => not_if_idStall);
			
	Nbit_dff1 : Nbit_dff
	port map(i_CLK => i_CLK,
			i_RST => if_idFlush,
			i_WE => not_if_idStall,
			i_D => PC_4,
			o_Q => PC_4_out);
			
	Nbit_dff2 : Nbit_dff
	port map(i_CLK => i_CLK,
			i_RST => if_idFlush,
			i_WE => not_if_idStall,
			i_D => instruction,
			o_Q => instruction_out);
			
	end structure;		
	
		
	