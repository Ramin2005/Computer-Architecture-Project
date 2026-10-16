LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    PORT (
        CLK : IN STD_LOGIC;
        MemoryReadData : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryWriteData : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryReadAddress : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryWriteEnable : OUT STD_LOGIC
    );
END ENTITY CPU;

ARCHITECTURE Struct OF CPU IS
BEGIN

    PROCESS (CLK)
        -- Control Signals
        SIGNAL Branch : STD_LOGIC;
        SIGNAL MemRead : STD_LOGIC;
        SIGNAL MemWrite : STD_LOGIC;
        SIGNAL MemToReg : STD_LOGIC;
        SIGNAL RegWrite : STD_LOGIC;
        SIGNAL ALUSrc : STD_LOGIC;
        SIGNAL ALUOp : STD_LOGIC_VECTOR(5 DOWNTO 0);
        SIGNAL ALUSelect : STD_LOGIC_VECTOR(5 DOWNTO 0);
        SIGNAL ZeroFlag : STD_LOGIC;

        -- Data Lines
        SIGNAL Instruction : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL PCRegisterOut : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL RegisterDataInput : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL RegisterDataOutA : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL RegisterDataOutB : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL ImmData : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL ALUInputB : STD_LOGIC_VECTOR(63 DOWNTO 0);
        SIGNAL ALUOutput : STD_LOGIC_VECTOR(63 DOWNTO 0);

    BEGIN

    END PROCESS;

END Struct;