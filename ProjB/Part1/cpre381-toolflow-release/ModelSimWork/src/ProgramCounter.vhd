library IEEE;
use IEEE.std_logic_1164.all;

entity ProgramCounter is
	generic(N: integer :=  32);
	port(input : in std_logic_vector(N-1 downto 0);
		i_RST : in std_logic;
		i_CLK : in std_logic;
		output : out std_logic_vector(N-1 downto 0));
end ProgramCounter;

architecture mixed of ProgramCounter is
	signal s_D : std_logic_vector(N-1 downto 0);
	signal s_Q : std_logic_vector(N-1 downto 0);
	
begin

	output <= s_Q;
	
	process (i_CLK,i_RST)
	begin
		if(i_RST = '1') then
		s_Q <= x"00400000";
		elsif(rising_edge(i_CLK)) then
		s_Q <= input;
		end if;
		
	end process;
end mixed;