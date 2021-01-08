library IEEE;
use IEEE.std_logic_1164.all;

entity nbit_mux_dataflow is
  generic(N : integer := 32);
   port(i_A	:	in std_logic_vector(N-1 downto 0);
		i_B :	in std_logic_vector(N-1 downto 0);
		i_S :	in std_logic;
		o_C	:	out std_logic_vector(N-1 downto 0));
end nbit_mux_dataflow;

architecture dataflow of nbit_mux_dataflow is

	signal S, notS, aAndnotS, bAndS, AorB : std_logic_vector(N-1 downto 0);
	
begin

	mux_G: for i in 0 to N-1 generate
	S(i) <= i_S;
	end generate;
	
	notS <= not S;
	aAndnotS <= i_A and notS;
	bAndS <= i_B and S;
	o_C <= bAndS or aAndnotS;

end dataflow;