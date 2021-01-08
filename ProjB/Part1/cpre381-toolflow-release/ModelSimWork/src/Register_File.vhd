-------------------------------------------------------------------------
-- Curt Lengemann
-------------------------------------------------------------------------


-- Register_File.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.reg_package.all;

entity Register_File is
   generic(N : integer := 32);
  port(Reset  : in std_logic;
       RegWrite  : in std_logic;
       CLK  : in std_logic;
	   Reg2 : out std_logic_vector(N-1 downto 0);
       Data_in  : in  std_logic_vector (N-1 downto 0);
       Write_Register : in std_logic_vector(4 downto 0);
       Read_Register_1 : in std_logic_vector(4 downto 0);
       Read_Register_2 : in std_logic_vector(4 downto 0);
       Read_Data_1 : out std_logic_vector(N-1 downto 0);
       Read_Data_2 : out std_logic_vector(N-1 downto 0));
end Register_File;

architecture structure of Register_File is

component decoder_5_32
    port ( i_Sel : in  std_logic_vector(4 downto 0);
	   o_F : out std_logic_vector(31 downto 0));
end component;

component Mux_32_1
    port ( i_Sel : in  std_logic_vector(4 downto 0);
	   i_1 : in std_logic_vector(N-1 downto 0);
	   i_2 : in std_logic_vector(N-1 downto 0);
   	   i_3 : in std_logic_vector(N-1 downto 0);
	   i_4 : in std_logic_vector(N-1 downto 0);
	   i_5 : in std_logic_vector(N-1 downto 0);
	   i_6 : in std_logic_vector(N-1 downto 0);
	   i_7 : in std_logic_vector(N-1 downto 0);
	   i_8 : in std_logic_vector(N-1 downto 0);

	   i_9 : in std_logic_vector(N-1 downto 0);
	   i_10 : in std_logic_vector(N-1 downto 0);
   	   i_11 : in std_logic_vector(N-1 downto 0);
	   i_12 : in std_logic_vector(N-1 downto 0);
	   i_13 : in std_logic_vector(N-1 downto 0);
	   i_14 : in std_logic_vector(N-1 downto 0);
	   i_15 : in std_logic_vector(N-1 downto 0);
	   i_16 : in std_logic_vector(N-1 downto 0);

	   i_17 : in std_logic_vector(N-1 downto 0);
	   i_18 : in std_logic_vector(N-1 downto 0);
   	   i_19 : in std_logic_vector(N-1 downto 0);
	   i_20 : in std_logic_vector(N-1 downto 0);
	   i_21 : in std_logic_vector(N-1 downto 0);
	   i_22 : in std_logic_vector(N-1 downto 0);
	   i_23 : in std_logic_vector(N-1 downto 0);
	   i_24 : in std_logic_vector(N-1 downto 0);

	   i_25 : in std_logic_vector(N-1 downto 0);
	   i_26 : in std_logic_vector(N-1 downto 0);
   	   i_27 : in std_logic_vector(N-1 downto 0);
	   i_28 : in std_logic_vector(N-1 downto 0);
	   i_29 : in std_logic_vector(N-1 downto 0);
	   i_30 : in std_logic_vector(N-1 downto 0);
	   i_31 : in std_logic_vector(N-1 downto 0);
	   i_32 : in std_logic_vector(N-1 downto 0);
	   o_F : out std_logic_vector(N-1 downto 0));
end component;

component Nbit_dff
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end component;

component andg2

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

signal s_decoder_out, s_WE_array: std_logic_vector(N-1 downto 0);
signal s_reg_array: reg_array;

begin

-- Output of 5:32 decoder
decoder_5_32_1 : decoder_5_32
port MAP(i_Sel => Write_Register,
	 o_F => s_decoder_out);

-- Creates 32 AND gates for the WE for the DFFs
G1: for i in 0 to N-1 generate
  and_i: andg2 
    port map(i_A  => s_decoder_out(i),
             i_B  => RegWrite,
  	          o_F  => s_WE_array(i));
end generate;

--Creates Register 0
Nbit_dff_0 : Nbit_dff
port map(i_CLK => CLK,
	 i_RST => '1',
	 i_WE => s_WE_array(0),
	 i_D => Data_in,
	 o_Q => s_reg_array(0));

--Creates the rest of the Registers
G2: for i in 1 to N-1 generate
  Nbit_dff_i: Nbit_dff
    port map(i_CLK => CLK,
	     i_RST => Reset,
	     i_WE => s_WE_array(i),
	     i_D => Data_in,
	     o_Q => s_reg_array(i));
end generate;

Mux_32_1_1 : Mux_32_1
port map( i_Sel => Read_Register_1,
	   i_1 => s_reg_array(0),
	   i_2 => s_reg_array(1),
   	   i_3 => s_reg_array(2),
	   i_4 => s_reg_array(3),
	   i_5 => s_reg_array(4),
	   i_6 => s_reg_array(5),
	   i_7 => s_reg_array(6),
	   i_8 => s_reg_array(7),
	   i_9 => s_reg_array(8),
	   i_10 => s_reg_array(9),
   	   i_11 => s_reg_array(10),
	   i_12 => s_reg_array(11),
	   i_13 => s_reg_array(12),
	   i_14 => s_reg_array(13),
	   i_15 => s_reg_array(14),
	   i_16 => s_reg_array(15),
	   i_17 => s_reg_array(16),
	   i_18 => s_reg_array(17),
   	   i_19 => s_reg_array(18),
	   i_20 => s_reg_array(19),
	   i_21 => s_reg_array(20),
	   i_22 => s_reg_array(21),
	   i_23 => s_reg_array(22),
	   i_24 => s_reg_array(23),
	   i_25 => s_reg_array(24),
	   i_26 => s_reg_array(25),
   	   i_27 => s_reg_array(26),
	   i_28 => s_reg_array(27),
	   i_29 => s_reg_array(28),
	   i_30 => s_reg_array(29),
	   i_31 => s_reg_array(30),
	   i_32 => s_reg_array(31),
	   o_F => Read_Data_1);

Mux_32_1_2 : Mux_32_1
port map( i_Sel => Read_Register_2,
	   i_1 => s_reg_array(0),
	   i_2 => s_reg_array(1),
   	   i_3 => s_reg_array(2),
	   i_4 => s_reg_array(3),
	   i_5 => s_reg_array(4),
	   i_6 => s_reg_array(5),
	   i_7 => s_reg_array(6),
	   i_8 => s_reg_array(7),
	   i_9 => s_reg_array(8),
	   i_10 => s_reg_array(9),
   	   i_11 => s_reg_array(10),
	   i_12 => s_reg_array(11),
	   i_13 => s_reg_array(12),
	   i_14 => s_reg_array(13),
	   i_15 => s_reg_array(14),
	   i_16 => s_reg_array(15),
	   i_17 => s_reg_array(16),
	   i_18 => s_reg_array(17),
   	   i_19 => s_reg_array(18),
	   i_20 => s_reg_array(19),
	   i_21 => s_reg_array(20),
	   i_22 => s_reg_array(21),
	   i_23 => s_reg_array(22),
	   i_24 => s_reg_array(23),
	   i_25 => s_reg_array(24),
	   i_26 => s_reg_array(25),
   	   i_27 => s_reg_array(26),
	   i_28 => s_reg_array(27),
	   i_29 => s_reg_array(28),
	   i_30 => s_reg_array(29),
	   i_31 => s_reg_array(30),
	   i_32 => s_reg_array(31),
	   o_F => Read_Data_2);

	Reg2 <= s_reg_array(2);
end structure;

