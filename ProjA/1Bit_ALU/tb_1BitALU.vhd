-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- tb_1BitALU.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_1BitALU is

end tb_1BitALU;

architecture behavior of tb_1BitALU is

component Ones_Bit_ALU
	port(i_A : in std_logic;
		i_B : in std_logic;
		i_Cin : in std_logic;
		s_Binvert : in std_logic;
		s_OPMux : in std_logic_vector(2 downto 0);
		ALU_Output : out std_logic;
		o_Cout : out std_logic);
end component;

signal s_A, s_B, s_Cin: std_logic;
signal signal_Binvert, s_ALUOut, s_Cout: std_logic;
signal signal_OPMux: std_logic_vector(2 downto 0);

begin

DUT : Ones_Bit_ALU
	port map(i_A => s_A,
		 i_B => s_B,
		 i_Cin => s_Cin,
		 s_Binvert => signal_Binvert,
		 s_OPMux => signal_OPMux,
		 ALU_Output => s_ALUOut,
		 o_Cout => s_Cout);

P_TB: process
    begin

	--- testing AND
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "000";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "000";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "000";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "000";
	wait for 100 ns;

	-- testing OR
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "001";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "001";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "001";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "001";
	wait for 100 ns;

	-- testing NOR
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "010";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "010";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "010";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "010";
	wait for 100 ns;

	-- testing NAND
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "011";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "011";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "011";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "011";
	wait for 100 ns;

	-- testing XOR
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "100";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "100";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "100";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "100";
	wait for 100 ns;

	-- testing ADD
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "101";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "101";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "101";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "101";
	wait for 100 ns;

	-- testing SUB
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '1';
	signal_Binvert<= '1';
	signal_OPMux <= "110";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '1';
	signal_Binvert <= '1';
	signal_OPMux <= "110";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '1';
	signal_Binvert <= '1';
	signal_OPMux <= "110";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '1';
	signal_Binvert <= '1';
	signal_OPMux <= "110";
	wait for 100 ns;

	-- testing SLT
	s_A <= '0';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "111";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '0';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "111";
	wait for 100 ns;

	s_A <= '0';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "111";
	wait for 100 ns;

	s_A <= '1';
	s_B <= '1';
	s_Cin <= '0';
	signal_Binvert <= '0';
	signal_OPMux <= "111";
	wait for 100 ns;
end process;
end behavior;
