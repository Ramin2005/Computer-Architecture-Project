LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Control IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        Branch : OUT STD_LOGIC;
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        MemToReg : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC;
        ALUSrc : OUT STD_LOGIC;
        ALUOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Control;

ARCHITECTURE Struct OF Control IS
BEGIN
END Struct;