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
-- SLL          -> opcode: "001101"
-- SRL          -> opcode: "001110"
-- SRA          -> opcode: "001111"
-- ROL          -> opcode: "010000" -- Extended
-- ROR          -> opcode: "010001" -- Extended
-- SLLW         -> opcode: "010010"
-- SRLW         -> opcode: "010011"
-- SRAW         -> opcode: "010100" 
-- ROLW         -> opcode: "010101" -- Extended
-- RORW         -> opcode: "010110" -- Extended

-- Arithmetic Operations:
-- MUL          -> opcode: "010111"  -- Low 64 bits of product
-- MULH         -> opcode: "011000"  -- High 64 bits, signed x signed
-- MULHSU       -> opcode: "011001"  -- High 64 bits, signed x unsigned
-- MULHU        -> opcode: "011010"  -- High 64 bits, unsigned x unsigned
-- MULW         -> opcode: "011011"  -- Low 32-bit product, sign-extended
-- DIV          -> opcode: "011100"  -- Signed 64-bit quotient
-- DIVU         -> opcode: "011101"  -- Unsigned 64-bit quotient
-- DIVW         -> opcode: "011110"  -- Signed 32-bit quotient, sign-extended
-- DIVUW        -> opcode: "011111"  -- Unsigned 32-bit quotient, sign-extended
-- REM          -> opcode: "100000"  -- Signed 64-bit remainder
-- REMU         -> opcode: "100001"  -- Unsigned 64-bit remainder
-- REMW         -> opcode: "100010"  -- Signed 32-bit remainder, sign-extended
-- REMUW        -> opcode: "100011"  -- Unsigned 32-bit remainder, sign-extended
-- ADD          -> opcode: "100100"
-- SUB          -> opcode: "100101"
-- ADDW         -> opcode: "100110"
-- SUBW         -> opcode: "100111"

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
    SIGNAL ResultDIVW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIVUW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREM : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMUW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADD : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSUB : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADDW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSUBW : STD_LOGIC_VECTOR(63 DOWNTO 0);

    SIGNAL CoutADD : STD_LOGIC;
    SIGNAL CoutSUB : STD_LOGIC;
    SIGNAL CoutADDW : STD_LOGIC;
    SIGNAL CoutSUBW : STD_LOGIC;
    SIGNAL OverflowADD : STD_LOGIC;
    SIGNAL OverflowSUB : STD_LOGIC;
    SIGNAL OverflowADDW : STD_LOGIC;
    SIGNAL OverflowSUBW : STD_LOGIC;

    -- Temporary signal
    SIGNAL TempResult : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL TempMULSS : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL TempMULSU : STD_LOGIC_VECTOR(129 DOWNTO 0);
    SIGNAL TempMULUU : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL TempADD : unsigned(64 DOWNTO 0);
    SIGNAL TempSUB : unsigned(64 DOWNTO 0);
    SIGNAL TempADDW : unsigned(32 DOWNTO 0);
    SIGNAL TempSUBW : unsigned(32 DOWNTO 0);

    -- Enable and Select Signals
    SIGNAL Enable : STD_LOGIC_VECTOR(39 DOWNTO 0);

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
    ResultL <= (OTHERS => '0') WHEN signed(A) < signed(B) ELSE
        (OTHERS => '1');

    -- Un A < B
    ResultUnL <= (OTHERS => '0') WHEN unsigned(A) < unsigned(B) ELSE
        (OTHERS => '1');

    -- A <= B
    ResultLE <= (OTHERS => '0') WHEN signed(A) <= signed(B) ELSE
        (OTHERS => '1');

    -- Un A <= B
    ResultUnLE <= (OTHERS => '0') WHEN unsigned(A) <= unsigned(B) ELSE
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
    ResultSLLW <= A(63 DOWNTO 32) & A(30 DOWNTO 0) & '0';
    CoutSLLW <= A(31);

    -- SRLW
    ResultSRLW <= A(63 DOWNTO 32) & '0' & A(31 DOWNTO 1);
    CoutSRLW <= A(0);

    -- SRAW
    ResultSRAW <= A(63 DOWNTO 32) & A(31) & A(31 DOWNTO 1);
    CoutSRAW <= A(0);

    -- ROLW
    ResultROLW <= A(63 DOWNTO 32) & A(30 DOWNTO 0) & A(31);

    -- RORW
    ResultRORW <= A(63 DOWNTO 32) & A(0) & A(31 DOWNTO 1);
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Arithmetic operations
    TempMULSS <= STD_LOGIC_VECTOR(signed(A) * signed(B));
    TempMULSU <= STD_LOGIC_VECTOR(signed(A(63) & A) * signed('0' & B));
    TempMULUU <= STD_LOGIC_VECTOR(unsigned(A) * unsigned(B));
    -- MUL
    ResultMUL <= TempMULSS(63 DOWNTO 0);

    -- MULH
    ResultMULH <= TempMULSS(127 DOWNTO 64);

    -- MULHSU
    ResultMULHSU <= TempMULSU(127 DOWNTO 64);

    -- MULHU
    ResultMULHU <= TempMULUU(127 DOWNTO 64);

    -- DIV
    ResultDIV <= STD_LOGIC_VECTOR(signed(A) / signed(B));

    -- DIVU
    ResultDIVU <= STD_LOGIC_VECTOR(unsigned(A) / unsigned(B));

    -- DIVW
    ResultDIVW <= STD_LOGIC_VECTOR(signed((31 DOWNTO 0 => A(31)) & A(31 DOWNTO 0)) / signed((31 DOWNTO 0 => B(31)) & B(31 DOWNTO 0)));

    -- DIVUW
    ResultDIVUW <= STD_LOGIC_VECTOR(unsigned((31 DOWNTO 0 => A(31)) & A(31 DOWNTO 0)) / unsigned((31 DOWNTO 0 => B(31)) & B(31 DOWNTO 0)));

    -- REM
    ResultREM <= STD_LOGIC_VECTOR(signed(A) MOD signed(B));

    -- REMU
    ResultREMU <= STD_LOGIC_VECTOR(unsigned(A) MOD unsigned(B));

    -- REMW
    ResultREMW <= STD_LOGIC_VECTOR(signed((31 DOWNTO 0 => A(31)) & A(31 DOWNTO 0)) MOD signed((31 DOWNTO 0 => B(31)) & B(31 DOWNTO 0)));

    -- REMUW
    ResultREMUW <= STD_LOGIC_VECTOR(unsigned((31 DOWNTO 0 => A(31)) & A(31 DOWNTO 0)) MOD unsigned((31 DOWNTO 0 => B(31)) & B(31 DOWNTO 0)));

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

    -- ADDW
    TempADDW <= unsigned('0' & A(31 DOWNTO 0)) + unsigned('0' & B(31 DOWNTO 0));
    ResultADDW <= (31 DOWNTO 0 => TempADDW(31)) & STD_LOGIC_VECTOR(TempADDW)(31 DOWNTO 0);
    CoutADDW <= TempADDW(32);
    OverflowADDW <= (NOT A(31) AND NOT B(31) AND ResultADDW(31))
        OR (A(31) AND B(31) AND NOT ResultADDW(31));

    -- SUBW
    TempSUBW <= unsigned('0' & A(31 DOWNTO 0)) + unsigned('0' & (NOT B(31 DOWNTO 0))) + to_unsigned(1, 33);
    ResultSUBW <= (31 DOWNTO 0 => TempSUBW(31)) & STD_LOGIC_VECTOR(TempSUBW)(31 DOWNTO 0);
    CoutSUBW <= TempSUBW(32);
    OverflowSUBW <= (NOT A(31) AND B(31) AND ResultSUBW(31))
        OR (A(31) AND NOT B(31) AND NOT ResultSUBW(31));
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Enable and Select
    Enable <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 40), to_integer(unsigned(S))))
        WHEN (unsigned(S) <= 39) ELSE
        (0 => '1', OTHERS => '0');
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Multiplexing
    TempResult <=
        -- Logic operations
        (A AND (63 DOWNTO 0 => Enable(0)))
        OR (ResultNOT AND (63 DOWNTO 0 => Enable(1)))
        OR (ResultAND AND (63 DOWNTO 0 => Enable(2)))
        OR (ResultOR AND (63 DOWNTO 0 => Enable(3)))
        OR (ResultXOR AND (63 DOWNTO 0 => Enable(4)))
        OR (ResultNAND AND (63 DOWNTO 0 => Enable(5)))
        OR (ResultNOR AND (63 DOWNTO 0 => Enable(6)))
        OR (ResultXNOR AND (63 DOWNTO 0 => Enable(7)))
        -- Compare operations
        OR (ResultEQ AND (63 DOWNTO 0 => Enable(8)))
        OR (ResultL AND (63 DOWNTO 0 => Enable(9)))
        OR (ResultUnL AND (63 DOWNTO 0 => Enable(10)))
        OR (ResultLE AND (63 DOWNTO 0 => Enable(11)))
        OR (ResultUnLE AND (63 DOWNTO 0 => Enable(12)))
        -- Shift and Rotating operations
        OR (ResultSLL AND (63 DOWNTO 0 => Enable(13)))
        OR (ResultSRL AND (63 DOWNTO 0 => Enable(14)))
        OR (ResultSRA AND (63 DOWNTO 0 => Enable(15)))
        OR (ResultROL AND (63 DOWNTO 0 => Enable(16)))
        OR (ResultROR AND (63 DOWNTO 0 => Enable(17)))
        OR (ResultSLLW AND (63 DOWNTO 0 => Enable(18)))
        OR (ResultSRLW AND (63 DOWNTO 0 => Enable(19)))
        OR (ResultSRAW AND (63 DOWNTO 0 => Enable(20)))
        OR (ResultROLW AND (63 DOWNTO 0 => Enable(21)))
        OR (ResultRORW AND (63 DOWNTO 0 => Enable(22)))
        -- Arithmetic operations
        OR (ResultMUL AND (63 DOWNTO 0 => Enable(23)))
        OR (ResultMULH AND (63 DOWNTO 0 => Enable(24)))
        OR (ResultMULHSU AND (63 DOWNTO 0 => Enable(25)))
        OR (ResultMULHU AND (63 DOWNTO 0 => Enable(26)))
        OR (ResultMULW AND (63 DOWNTO 0 => Enable(27)))
        OR (ResultDIV AND (63 DOWNTO 0 => Enable(28)))
        OR (ResultDIVU AND (63 DOWNTO 0 => Enable(29)))
        OR (ResultDIVW AND (63 DOWNTO 0 => Enable(30)))
        OR (ResultDIVUW AND (63 DOWNTO 0 => Enable(31)))
        OR (ResultREM AND (63 DOWNTO 0 => Enable(32)))
        OR (ResultREMU AND (63 DOWNTO 0 => Enable(33)))
        OR (ResultREMW AND (63 DOWNTO 0 => Enable(34)))
        OR (ResultREMUW AND (63 DOWNTO 0 => Enable(35)))
        OR (ResultADD AND (63 DOWNTO 0 => Enable(36)))
        OR (ResultSUB AND (63 DOWNTO 0 => Enable(37)))
        OR (ResultADDW AND (63 DOWNTO 0 => Enable(38)))
        OR (ResultSUBW AND (63 DOWNTO 0 => Enable(39)));

    Cout <=
        (CoutSLL AND Enable(13))
        OR (CoutSRL AND Enable(14))
        OR (CoutSRA AND Enable(15))
        OR (CoutSLLW AND Enable(18))
        OR (CoutSRLW AND Enable(19))
        OR (CoutSRAW AND Enable(20))
        OR (CoutADD AND Enable(36))
        OR (CoutSUB AND Enable(37))
        OR (CoutADDW AND Enable(38))
        OR (CoutSUBW AND Enable(39));

    Overflow <=
        (OverflowADD AND Enable(36))
        OR (OverflowSUB AND Enable(37))
        OR (OverflowADDW AND Enable(38))
        OR (OverflowSUBW AND Enable(39));

    Result <= TempResult;

    Zero <= '1' WHEN TempResult = (63 DOWNTO 0 => '0') ELSE
        '0';

END struct;