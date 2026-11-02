LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    PORT (
        -- Reset & Clock Signal
        CLK : IN STD_LOGIC;
        Reset : IN STD_LOGIC;

        -- Data Memory
        MemoryAddress : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryMask : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MemoryWriteEnable : OUT STD_LOGIC;
        MemoryWriteData : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryReadEnable : OUT STD_LOGIC;
        MemoryReadData : IN STD_LOGIC_VECTOR(63 DOWNTO 0);

        -- Instruction Memory
        InstructionAddress : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        InstructionIn : IN STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY CPU;

ARCHITECTURE Struct OF CPU IS

    -- Control Unit Signals
    SIGNAL SigBranch : STD_LOGIC;
    SIGNAL SigMemRead : STD_LOGIC;
    SIGNAL SigMemWrite : STD_LOGIC;
    SIGNAL SigRegWrite : STD_LOGIC;
    SIGNAL SigRegSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigPCSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigALUSrcA : STD_LOGIC;
    SIGNAL SigALUSrcB : STD_LOGIC;
    SIGNAL SigALUSelect : STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN

    -- Control Unit
    ControlUnit : ENTITY work.MainControl
        PORT MAP(
            Instruction => InstructionIn,
            Branch => SigBranch,
            MemRead => SigMemRead,
            MemWrite => SigMemWrite,
            RegWrite => SigRegWrite,
            RegSrc => SigRegSrc,
            PCSrc => SigPCSrc,
            ALUSrcA => SigALUSrcA,
            ALUSrcB => SigALUSrcB,
            ALUSelect => SigALUSelect
        );

END Struct;