library IEEE;
use IEEE.std_logic_1164.all;

entity comparator is
	port(i_A : in std_logic_vector(31 downto 0);
		 i_B : in std_logic_vector(31 downto 0);
		 comparation : out std_logic);
end comparator;

architecture behavior of comparator is
begin
	process(i_A, i_B)
	begin
		if(i_A = i_B) then
			comparation <= '1';
		else
			comparation <= '0';
		end if;
	end process;
end behavior;