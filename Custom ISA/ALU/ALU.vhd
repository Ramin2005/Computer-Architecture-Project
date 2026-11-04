-- RV64IM Base + Custom ALU Extensions

-- Arithmetic Operations:
-- ADD          -> opcode: "000000"(0)
-- SUB          -> opcode: "000001"(1)
-- ADDW         -> opcode: "000010"(2)
-- SUBW         -> opcode: "000011"(3)
-- ABS          -> opcode: "000100"(4)  -- Outside: Custom
-- ABSW         -> opcode: "000101"(5)  -- Outside: Custom

-- Logic Operations:
-- AND          -> opcode: "010100"(6)
-- OR           -> opcode: "010101"(7)
-- XOR          -> opcode: "010110"(8)

-- Compare Operations:
-- A == B       -> opcode: "011101"(10) -- BEQ
-- A < B        -> opcode: "011111"(11) -- SLT
-- Un A < B     -> opcode: "100000"(12) -- SLTU

-- Shift and Rotate Operations:
-- SLL          -> opcode: "100011"(13)
-- SRL          -> opcode: "100100"(14)
-- SRA          -> opcode: "100101"(15)

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        S : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Zero : OUT STD_LOGIC
    );
END ENTITY ALU;

-- Architecture of ALU
ARCHITECTURE struct OF ALU IS

    -- Arithmetic result signals
    SIGNAL ResultADD, ResultSUB : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADDW, ResultSUBW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultABS, ResultABSW : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Logic result signals
    SIGNAL ResultAND, ResultOR, ResultXOR : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Compare result signals
    SIGNAL ResultEQ,: STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultL, ResultUnL : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Shift and Rotating result signals
    SIGNAL ResultSLL, ResultSRL, ResultSRA : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Temporary signals
    -- 5, 6 Low bit unsigned temps
    SIGNAL TempBN5 : unsigned(4 DOWNTO 0);
    SIGNAL TempBN6 : unsigned(5 DOWNTO 0);
    SIGNAL TempBS : STD_LOGIC_VECTOR(63 DOWNTO 0);
    
    -- 32 Low bits temps
    SIGNAL TempAL, TempBL : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    -- Signed and Unsigned of A, B, AL, BL temps
    SIGNAL TempSA, TempSB : signed (63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempUA, TempUB : unsigned (63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempSAL, TempSBL : signed (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempUAL, TempUBL : unsigned (31 DOWNTO 0) := (OTHERS => '0');

    -- Abs of Signed of A, B, AL, BL temps
    SIGNAL TempAbsA, TempAbsB : signed (63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempAbsAL, TempAbsBL : signed (31 DOWNTO 0) := (OTHERS => '0');

    -- Arithmetic temps
    SIGNAL TempADD, TempSUB : unsigned(64 DOWNTO 0);
    SIGNAL TempADDW, TempSUBW : unsigned(32 DOWNTO 0);

    -- Result temp
    SIGNAL TempResult : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Enable and Select Signals
    SIGNAL Enable : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Constants
    CONSTANT ConstantZero : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    CONSTANT ConstantFull : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '1');
BEGIN

    TempBN5 <= unsigned(B(4 DOWNTO 0));
    TempBN6 <= unsigned(B(5 DOWNTO 0));
    TempAL <= A(31 DOWNTO 0);
    TempBL <= B(31 DOWNTO 0);
    TempSA <= signed(A);
    TempSB <= signed(B);
    TempUA <= unsigned(A);
    TempUB <= unsigned(B);
    TempSAL <= signed(TempAL);
    TempSBL <= signed(TempBL);
    TempUAL <= unsigned(TempAL);
    TempUBL <= unsigned(TempBL);
    TempAbsA <= ABS(TempSA);
    TempAbsB <= ABS(TempSB);
    TempAbsAL <= ABS(TempSAL);
    TempAbsBL <= ABS(TempSBL);

    ------------------------------------------------------------------------------------------
    -- 
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Enable and Select
    Enable <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 16), to_integer(unsigned(S))));
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Multiplexing
    TempResult <=;

    Result <= TempResult;

    Zero <= '1' WHEN TempResult = ConstantZero ELSE
        '0';

END struct;