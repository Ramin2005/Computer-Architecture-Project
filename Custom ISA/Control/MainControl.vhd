LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MainControl IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC;
        RegSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PCSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUSrcA, ALUSrcB : OUT STD_LOGIC;
        ALUSelect : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY MainControl;

ARCHITECTURE Struct OF MainControl IS
    SIGNAL SigMemRead : STD_LOGIC;
    SIGNAL SigMemWrite : STD_LOGIC;
    SIGNAL SigRegWrite : STD_LOGIC;
    SIGNAL SigRegSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigPCSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigALUSrcA, SigALUSrcB : STD_LOGIC;
    SIGNAL SigALUSelect : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL SigALUOpcode : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

    Control : ENTITY work.Control
        PORT MAP(
            Opcode => SigOpcode,
            MemRead => SigMemRead,
            MemWrite => SigMemWrite,
            RegWrite => SigRegWrite,
            RegSrc => SigRegSrc,
            PCSrc => SigPCSrc,
            ALUSrcA => SigALUSrcA,
            ALUSrcB => SigALUSrcB,
            ALUOpcode => SigALUOpcode
        );

    ALUControl : ENTITY work.ALUControl
        PORT MAP(
        );

    MemRead <= SigMemRead;
    MemWrite <= SigMemWrite;
    RegWrite <= SigRegWrite;
    RegSrc <= SigRegSrc;
    PCSrc <= SigPCSrc;
    ALUSrcA <= SigALUSrcA;
    ALUSrcB <= SigALUSrcB;
    ALUSelect <= SigALUSelect;
END Struct;