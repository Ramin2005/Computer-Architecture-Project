-- Arithmetic Operations:
-- ADD          -> opcode: "000000"(0)
-- SUB          -> opcode: "000001"(1)
-- ADDH         -> opcode: "000010"(2)
-- SUBH         -> opcode: "000011"(3)
-- INC          -> opcode: "000100"(4)
-- DEC          -> opcode: "000101"(5)

-- Logic Operations:
-- AND          -> opcode: "010100"(6)
-- OR           -> opcode: "010101"(7)
-- XOR          -> opcode: "010110"(8)

-- Compare Operations:
-- BEQ          -> opcode: "011101"(10)
-- SLT          -> opcode: "011111"(11)
-- SLTU         -> opcode: "100000"(12)

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
    SIGNAL ResultADD, ResultSUB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ResultADDH, ResultSUBH : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL INC, DEC : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Logic result signals
    SIGNAL ResultAND, ResultOR, ResultXOR : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Compare result signals
    SIGNAL ResultEQ, : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ResultSLT, ResultSLTU : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Shift and Rotating result signals
    SIGNAL ResultSLL, ResultSRL, ResultSRA : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Temporary signals
    -- 5 Low bit unsigned temps
    SIGNAL TempBN5 : unsigned(5 DOWNTO 0);

    -- 16 Low bits temps
    SIGNAL TempAL, TempBL : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Signed and Unsigned of A, B, AL, BL temps
    SIGNAL TempSA, TempSB : signed (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempUA, TempUB : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempSAL, TempSBL : signed (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempUAL, TempUBL : unsigned (15 DOWNTO 0) := (OTHERS => '0');

    -- Arithmetic temps
    SIGNAL TempADD, TempSUB : unsigned(32 DOWNTO 0);
    SIGNAL TempADDH, TempSUBH : unsigned(16 DOWNTO 0);
    SIGNAL TempINC, TempDEC : unsigned(32 DOWNTO 0);

    -- Result temp
    SIGNAL TempResult : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Enable and Select Signals
    SIGNAL Enable : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Constants
    CONSTANT ConstantZero : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    CONSTANT ConstantFull : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '1');
BEGIN

    TempBN5 <= unsigned(B(4 DOWNTO 0));
    TempAL <= A(15 DOWNTO 0);
    TempBL <= B(15 DOWNTO 0);
    TempSA <= signed(A);
    TempSB <= signed(B);
    TempUA <= unsigned(A);
    TempUB <= unsigned(B);
    TempSAL <= signed(TempAL);
    TempSBL <= signed(TempBL);
    TempUAL <= unsigned(TempAL);
    TempUBL <= unsigned(TempBL);

    ------------------------------------------------------------------------------------------
    
    ------------------------------------------------------------------------------------------
    -- ADD
    TempADD <= unsigned('0' & A) + unsigned('0' & B);
    ResultADD <= STD_LOGIC_VECTOR(TempADD(31 DOWNTO 0));

    -- SUB
    TempSUB <= unsigned('0' & A) + unsigned('0' & (NOT B)) + to_unsigned(1, 65);
    ResultSUB <= STD_LOGIC_VECTOR(TempSUB(63 DOWNTO 0));

    -- ADDH
    TempADDH <= unsigned('0' & TempAL) + unsigned('0' & TempBL);
    ResultADDH <= (31 DOWNTO 0 => TempADDH(31)) & STD_LOGIC_VECTOR(TempADDH(31 DOWNTO 0));

    -- SUBH
    TempSUBH <= unsigned('0' & TempAL) + unsigned('0' & (NOT TempBL)) + to_unsigned(1, 33);
    ResultSUBH <= (31 DOWNTO 0 => TempSUBH(31)) & STD_LOGIC_VECTOR(TempSUBH(31 DOWNTO 0));
    ------------------------------------------------------------------------------------------
    
    ------------------------------------------------------------------------------------------
    -- Logic Operations
    -- AND
    ResultAND <= A AND B;
    -- OR
    ResultOR <= A OR B;
    -- XOR
    ResultXOR <= A XOR B;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Compare operations
    -- A = B
    ResultEQ <= (0 => '1', OTHERS => '0') WHEN A = B ELSE
        ConstantZero;

    -- A < B
    ResultSLT <= (0 => '1', OTHERS => '0') WHEN TempSA < TempSB ELSE
        ConstantZero;

    -- Un A < B
    ResultSLTU <= (0 => '1', OTHERS => '0') WHEN TempUA < TempUB ELSE
        ConstantZero;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Shift and Rotating operations
    -- SLL
    ResultSLL <= STD_LOGIC_VECTOR(SHIFT_LEFT(TempUA, to_integer(TempBN5)));

    -- SRL
    ResultSRL <= STD_LOGIC_VECTOR(SHIFT_RIGHT(TempUA, to_integer(TempBN5)));

    -- SRA
    ResultSRA <= STD_LOGIC_VECTOR(SHIFT_RIGHT(TempSA, to_integer(TempBN5)));
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Enable and Select
    Enable <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 16), to_integer(unsigned(S))));
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Multiplexing
    TempResult <= ;

    Result <= TempResult;

    Zero <= '1' WHEN TempResult = ConstantZero ELSE
        '0';

END struct;