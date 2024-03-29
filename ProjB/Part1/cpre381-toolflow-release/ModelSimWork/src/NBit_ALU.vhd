library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NBit_ALU is
	generic(N : integer := 32);
	port(i_A : in std_logic_vector(N-1 downto 0);
			i_B: in std_logic_vector(N-1 downto 0);
			s_OPMUX : in std_logic_vector(3 downto 0);
			ALU_Output: out std_logic_vector(N-1 downto 0);
			o_ALUOverflow: out std_logic;
			o_ALUCout: out std_logic;
			o_ALUZero : out std_logic
			);
end NBit_ALU;

architecture mixed of NBit_ALU is
	
component OnebitMux is
	port(i_A : in std_logic;
		i_B	: in std_logic;
		i_S	: in std_logic;
		o_X : out std_logic);
		
end component;
	
	component norG is
	port(i_A : in std_logic;
			i_B: in std_logic;
			o_S: out std_logic
			);
	end component;
	
	component OnesBit_ALU is 
	port(i_A : in std_logic;
		i_B : in std_logic;
		s_Binvert : in std_logic;
		i_Less : in std_logic;
		i_Cin : in std_logic;
		s_OPMux : in std_logic_vector(2 downto 0);
		ALU_Output : out std_logic;
		o_Cout : out std_logic
		);
		
	end component;
	
	component OnesBit_ALU32 is 
	port(i_A : in std_logic;
		i_B : in std_logic;
		s_Binvert : in std_logic;
		i_Less : in std_logic;
		i_Cin : in std_logic;
		s_OPMux : in std_logic_vector(2 downto 0);
		i_unsigned : in std_logic;
		ALU_Output : out std_logic;
		o_Cout : out std_logic;
		o_Set : out std_logic
		);
		
	end component;
	
	signal i_C, TempAlu_Output : std_logic_vector(N-1 downto 0);
	signal alu_Set, Inv_SLT, TempAlu_Overflow : std_logic;
	signal alu_Zero : std_logic_vector(N-2 downto 0);
	begin
	
	with s_OPMUX select
		Inv_SLT <= '1' when "0111",
					'1' when "0110",
					'1' when "1111",
					'1' when "1110",
					'0' when others;
	
	ob_alu0 : OnesBit_ALU
		port map(i_A => i_A(0),
				i_B => i_B(0),
				i_Less => alu_Set,
				s_Binvert => Inv_SLT,
				i_Cin => Inv_SLT,
				s_OPMUX => s_OPMUX(2 downto 0),
				ALU_Output => TempAlu_Output(0),
				o_Cout => i_C(0)
			);
				
	
	G1: for i in 1 to N-2 generate
		ob_alu : OnesBit_ALU
		port map(i_A => i_A(i),
				i_B => i_B(i),
				i_Less => '0',
				s_Binvert => Inv_SLT,
				i_Cin => i_C(i-1),
				s_OPMUX => s_OPMUX(2 downto 0),
				ALU_Output => TempAlu_Output(i),
				o_Cout => i_C(i)
				);
	end generate;
	
	ob_alu1 : OnesBit_ALU32
		port map(i_A => i_A(N-1),
				i_B => i_B(N-1),
				s_Binvert => Inv_SLT,
				i_Less => '0',
				i_Cin => i_C(N-2),
				o_Cout => i_C(N-1),
				s_OPMUX => s_OPMux(2 downto 0),
				i_unsigned => s_OPMux(3),
				ALU_Output => TempAlu_Output(N-1),
				o_Set => alu_Set
				);
	
	o_ALUCout <= i_C(N-1);
	
	TempAlu_Overflow <=  i_C(N-1) xor i_C(N-2);
	
	G2: for i in 0 to N-2 generate
		norg2: norG
		port map(i_A => TempAlu_Output(i),
				i_B => TempAlu_Output(i+1),
				o_S => alu_Zero(i)
				);
	end generate;
	
	ALU_Output <= TempAlu_Output;
	
	o_ALUZero <= '1' when alu_Zero = "1111111111111111111111111111111" else
		'0';
	
	g_mux : OnebitMux
        port map(i_A => TempAlu_Overflow,
                i_B => '0',
                i_S => s_OPMUX(3),
                o_X => o_ALUOverflow);

	end mixed;