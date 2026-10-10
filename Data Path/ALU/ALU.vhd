-- RV64IM Base + Custom ALU Extensions
-- ALUControl: 6-bit operation codes

-- Logic Operations:
-- Buffer       -> opcode: "000000"
-- NOT          -> opcode: "000001" -- Extended
-- AND          -> opcode: "000010"
-- OR           -> opcode: "000011"
-- XOR          -> opcode: "000100"
-- NAND         -> opcode: "000101" -- Extended
-- NOR          -> opcode: "000110" -- Extended
-- XNOR         -> opcode: "000111" -- Extended

-- Compare Operations:
-- A == B       -> opcode: "001000" -- Equal
-- A < B        -> opcode: "001001" -- SLT
-- Un A < B     -> opcode: "001010" -- SLTU
-- A <= B       -> opcode: "001011" -- Extended
-- Un A <= B    -> opcode: "001100" -- Extended

-- Shift and Rotate Operations:
-- SLL          -> opcode: "010000"
-- SRL          -> opcode: "010001"
-- SRA          -> opcode: "010010"
-- ROL          -> opcode: "010011" -- Extended
-- ROR          -> opcode: "010100" -- Extended
-- SLLW         -> opcode: "010101"
-- SRLW         -> opcode: "010110"
-- SRAW         -> opcode: "010111" 
-- ROLW         -> opcode: "011000" -- Extended
-- RORW         -> opcode: "011001" -- Extended

-- Arithmetic Operations:
-- MUL          -> opcode: "100000"  -- Low 64 bits of product
-- MULH         -> opcode: "100001"  -- High 64 bits, signed x signed
-- MULHSU       -> opcode: "100010"  -- High 64 bits, signed x unsigned
-- MULHU        -> opcode: "100011"  -- High 64 bits, unsigned x unsigned
-- MULW         -> opcode: "100100"  -- Low 32-bit product, sign-extended
-- DIV          -> opcode: "100101"  -- Signed 64-bit quotient
-- DIVU         -> opcode: "100110"  -- Unsigned 64-bit quotient
-- DIVUW        -> opcode: "100111"  -- Unsigned 32-bit quotient, sign-extended
-- REM          -> opcode: "101000"  -- Signed 64-bit remainder
-- REMU         -> opcode: "101001"  -- Unsigned 64-bit remainder
-- DIVW         -> opcode: "101010"  -- Signed 32-bit quotient, sign-extended
-- REMW         -> opcode: "101011"  -- Signed 32-bit remainder, sign-extended
-- REMUW        -> opcode: "101100"  -- Unsigned 32-bit remainder, sign-extended
-- ADD          -> opcode: "101101"
-- SUB          -> opcode: "101110"
-- ADDW         -> opcode: "101111"
-- SUBW         -> opcode: "110000"

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        A : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        S : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        Result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        Cout : OUT STD_LOGIC;
        Overflow : OUT STD_LOGIC;
        Zero : OUT STD_LOGIC
    );
END ENTITY ALU;

-- Architecture of ALU
ARCHITECTURE struct OF ALU IS
    -- Logic result signals
    SIGNAL ResultNOT : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultAND : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultOR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultXOR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultNAND : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultNOR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultXNOR : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Compare result signals
    SIGNAL ResultEQ : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultLE : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnLE : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Shift and Rotating result signals
    SIGNAL ResultSLL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSRL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSRA : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSLLW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSRLW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSRAW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROLW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultRORW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL CoutSLL : STD_LOGIC;
    SIGNAL CoutSRL : STD_LOGIC;
    SIGNAL CoutSRA : STD_LOGIC;
    SIGNAL CoutSLLW : STD_LOGIC;
    SIGNAL CoutSRLW : STD_LOGIC;
    SIGNAL CoutSRAW : STD_LOGIC;

    -- Arithmetic result signals
    SIGNAL ResultMUL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULH : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULHSU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULHU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIV : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIVU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIVUW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREM : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIVW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMUW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADD : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSUB : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADDW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSUBW : STD_LOGIC_VECTOR(63 DOWNTO 0);

    SIGNAL CoutADD : STD_LOGIC;
    SIGNAL CoutSUB : STD_LOGIC;
    SIGNAL OverflowADD : STD_LOGIC;
    SIGNAL OverflowSUB : STD_LOGIC;
    SIGNAL CoutADDW : STD_LOGIC;
    SIGNAL CoutSUBW : STD_LOGIC;
    SIGNAL OverflowADDW : STD_LOGIC;
    SIGNAL OverflowSUBW : STD_LOGIC;

    -- Temporary signal
    SIGNAL TempADD : unsigned(64 DOWNTO 0);
    SIGNAL TempSUB : unsigned(64 DOWNTO 0);

    -- Enable and Select Signals
    SIGNAL Enable : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

    ------------------------------------------------------------------------------------------
    -- Logic Operations
    -- NOT
    ResultNOT <= NOT A;
    -- AND
    ResultAND <= A AND B;
    -- OR
    ResultOR <= A OR B;
    -- XOR
    ResultXOR <= A XOR B;
    -- NAND
    ResultNAND <= A NAND B;
    -- NOR
    ResultNOR <= A NOR B;
    -- XNOR
    ResultXNOR <= A XNOR B;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Compare operations
    -- A = B
    ResultEQ <= (OTHERS => '0') WHEN A = B ELSE
        (OTHERS => '1');

    -- A < B
    ResultS <= (OTHERS => '0') WHEN signed(A) < signed(B) ELSE
        (OTHERS => '1');

    -- Un A < B
    ResultUnS <= (OTHERS => '0') WHEN unsigned(A) < unsigned(B) ELSE
        (OTHERS => '1');

    -- A <= B
    ResultSE <= (OTHERS => '0') WHEN signed(A) <= signed(B) ELSE
        (OTHERS => '1');

    -- Un A <= B
    ResultUnSE <= (OTHERS => '0') WHEN unsigned(A) <= unsigned(B) ELSE
        (OTHERS => '1');
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Shift and Rotating operations
    -- SLL
    ResultSLL <= A(62 DOWNTO 0) & '0';
    CoutSLL <= A(63);

    -- SRL
    ResultSRL <= '0' & A(63 DOWNTO 1);
    CoutSRL <= A(0);

    -- SRA
    ResultSRA <= A(63) & A(63 DOWNTO 1);
    CoutSRA <= A(0);

    -- ROL
    ResultROL <= A(62 DOWNTO 0) & A(63);

    -- ROR
    ResultROR <= A(0) & A(63 DOWNTO 1);

    -- SLLW
    ResultSLLW <= A(63 downto 32) & A(30 DOWNTO 0) & '0';
    CoutSLLW <= A(31);

    -- SRLW
    ResultSRLW <=  A(63 downto 32) & '0' & A(31 DOWNTO 1);
    CoutSRLW <= A(0);

    -- SRAW
    ResultSRAW <=  A(63 downto 32) & A(31) & A(31 DOWNTO 1);
    CoutSRAW <= A(0);

    -- ROLW
    ResultROLW <= A(63 downto 32) & A(30 DOWNTO 0) & A(31);

    -- RORW
    ResultRORW <= A(63 downto 32) & A(0) & A(31 DOWNTO 1);
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Arithmetic operations
    -- MUL
    ResultMUL <= STD_LOGIC_VECTOR(signed(A) * signed(B))(63 DOWNTO 0);

    -- MULH
    ResultMULH <= STD_LOGIC_VECTOR(signed(A) * signed(B))(127 DOWNTO 64);

    -- MULHSU
    ResultMULHSU <= STD_LOGIC_VECTOR(signed(A) * unsigned(B))(127 DOWNTO 64);
    
    -- MULHU
    ResultMULHU <= STD_LOGIC_VECTOR(unsigned(A) * unsigned(B))(127 DOWNTO 64);

    -- DIV
    ResultDIV <= STD_LOGIC_VECTOR(signed(A) / signed(B));
    
    -- DIVU
    ResultDIVU <= STD_LOGIC_VECTOR(unsigned(A) / unsigned(B));

    -- ADD
    TempADD <= unsigned('0' & A) + unsigned('0' & B);
    ResultADD <= STD_LOGIC_VECTOR(TempADD)(63 DOWNTO 0);
    CoutADD <= TempADD(64);
    OverflowADD <= (NOT A(63) AND NOT B(63) AND ResultADD(63))
        OR (A(63) AND B(63) AND NOT ResultADD(63));

    -- SUB
    TempSUB <= unsigned('0' & A) + unsigned('0' & (NOT B)) + to_unsigned(1, 65);
    ResultSUB <= STD_LOGIC_VECTOR(TempSUB)(63 DOWNTO 0);
    CoutSUB <= TempSUB(64);
    OverflowSUB <= (NOT A(63) AND B(63) AND ResultSUB(63))
        OR (A(63) AND NOT B(63) AND NOT ResultSUB(63));
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Enable and Select
    Enable <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 32), to_integer(unsigned(S))))
        WHEN (unsigned(S) <= 12) OR ((unsigned(S) >= 16) AND (unsigned(S) <= 25)) ELSE
        x"80000000";
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Multiplexing

END struct;