LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Control IS
    PORT (
        Opcode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC;
        RegSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PCSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUSrcA, ALUSrcB : OUT STD_LOGIC;
        ALUOpcode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Control;

ARCHITECTURE Struct OF Control IS
BEGIN

END Struct;