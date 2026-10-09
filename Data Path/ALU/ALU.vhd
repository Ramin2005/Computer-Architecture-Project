-- RV64IM Base + Custom ALU Extensions
-- ALUControl: 6-bit operation codes

-- Logic Operations:
-- Buffer       -> opcode: "000000"  -- Pass-through
-- NOT          -> opcode: "000001"  -- Bitwise NOT
-- AND          -> opcode: "000010"  -- Bitwise AND
-- OR           -> opcode: "000011"  -- Bitwise OR
-- XOR          -> opcode: "000100"  -- Bitwise XOR
-- NAND         -> opcode: "000101"  -- NOT (A AND B)
-- NOR          -> opcode: "000110"  -- NOT (A OR B)
-- XNOR         -> opcode: "000111"  -- NOT (A XOR B)

-- Compare Operations:
-- A == B       -> opcode: "001000"  -- Equal
-- A < B        -> opcode: "001001"  -- Signed less-than (SLT)
-- Un A < B     -> opcode: "001010"  -- Unsigned less-than (SLTU)
-- A <= B       -> opcode: "001011"  -- Signed less-or-equal (custom)
-- Un A <= B    -> opcode: "001100"  -- Unsigned less-or-equal (custom)

-- Shift and Rotate Operations:
-- SLL          -> opcode: "010000"  -- 64-bit logical shift left
-- SRL          -> opcode: "010001"  -- 64-bit logical shift right
-- SRA          -> opcode: "010010"  -- 64-bit arithmetic shift right
-- ROL          -> opcode: "010011"  -- 64-bit rotate left (custom)
-- ROR          -> opcode: "010100"  -- 64-bit rotate right (custom)
-- SLLW         -> opcode: "010101"  -- 32-bit shift left, sign-extended result
-- SRLW         -> opcode: "010110"  -- 32-bit logical shift right, sign-extended result
-- SRAW         -> opcode: "010111"  -- 32-bit arithmetic shift right, sign-extended result
-- ROLW         -> opcode: "011000"  -- 32-bit rotate left (custom)
-- RORW         -> opcode: "011001"  -- 32-bit rotate right (custom)

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
-- ADD          -> opcode: "101101"  -- 64-bit addition
-- SUB          -> opcode: "101110"  -- 64-bit subtraction
-- ADDW         -> opcode: "101111"  -- 32-bit addition, sign-extended
-- SUBW         -> opcode: "110000"  -- 32-bit subtraction, sign-extended

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
    SIGNAL ResultNE : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultS : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnS : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultG : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnG : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSE : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnSE : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultGE : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnGE : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Arithmetic result signals
    SIGNAL ResultMUL : STD_LOGIC_VECTOR(2 * 63 DOWNTO 0);
    SIGNAL ResultUnMUL : STD_LOGIC_VECTOR(2 * 63 DOWNTO 0);
    SIGNAL ResultDIV : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnDIV : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMOD : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultUnMOD : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADD : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSUB : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultINC : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDEC : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultNEG : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL CoutADD : STD_LOGIC;
    SIGNAL CoutSUB : STD_LOGIC;
    SIGNAL CoutINC : STD_LOGIC;
    SIGNAL CoutDEC : STD_LOGIC;
    SIGNAL CoutNEG : STD_LOGIC;
    SIGNAL OverflowADD : STD_LOGIC;
    SIGNAL OverflowSUB : STD_LOGIC;
    SIGNAL OverflowINC : STD_LOGIC;
    SIGNAL OverflowDEC : STD_LOGIC;
    SIGNAL OverflowNEG : STD_LOGIC;

    -- Shift and Rotating result signals
    SIGNAL ResultSHL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSHR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultASR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL CoutASR : STD_LOGIC;
    SIGNAL CoutSHL : STD_LOGIC;
    SIGNAL CoutSHR : STD_LOGIC;

    -- Temporary signal
    SIGNAL TempADD : unsigned(64 DOWNTO 0);
    SIGNAL TempSUB : unsigned(64 DOWNTO 0);
    SIGNAL TempINC : unsigned(64 DOWNTO 0);
    SIGNAL TempDEC : unsigned(64 DOWNTO 0);
    SIGNAL TempNEG : unsigned(64 DOWNTO 0);
    SIGNAL USTemp : unsigned(63 DOWNTO 0);

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
    ResultEQ <= (0 => '1', OTHERS => '0') WHEN A = B ELSE
        (OTHERS => '0');

    -- A != B
    ResultNE <= (OTHERS => '0') WHEN A = B ELSE
        (0 => '1', OTHERS => '0');

    -- A < B
    ResultS <= (0 => '1', OTHERS => '0') WHEN signed(A) < signed(B) ELSE
        (OTHERS => '0');

    -- Un A < B
    ResultUnS <= (0 => '1', OTHERS => '0') WHEN unsigned(A) < unsigned(B) ELSE
        (OTHERS => '0');

    -- A > B
    ResultG <= (0 => '1', OTHERS => '0') WHEN signed(A) > signed(B) ELSE
        (OTHERS => '0');

    -- Un A > B
    ResultUnG <= (0 => '1', OTHERS => '0') WHEN unsigned(A) > unsigned(B) ELSE
        (OTHERS => '0');

    -- A <= B
    ResultSE <= (0 => '1', OTHERS => '0') WHEN signed(A) <= signed(B) ELSE
        (OTHERS => '0');

    -- Un A <= B
    ResultUnSE <= (0 => '1', OTHERS => '0') WHEN unsigned(A) <= unsigned(B) ELSE
        (OTHERS => '0');

    -- A >= B
    ResultGE <= (0 => '1', OTHERS => '0') WHEN signed(A) >= signed(B) ELSE
        (OTHERS => '0');

    -- Un A >= B
    ResultUnGE <= (0 => '1', OTHERS => '0') WHEN unsigned(A) >= unsigned(B) ELSE
        (OTHERS => '0');
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Arithmetic operations
    -- MUL
    ResultMUL <= STD_LOGIC_VECTOR(signed(A) * signed(B));

    -- UnMUL
    ResultUnMUL <= STD_LOGIC_VECTOR(unsigned(A) * unsigned(B));

    -- DIV
    ResultDIV <= STD_LOGIC_VECTOR(signed(A) / signed(B));
    ResultMOD <= STD_LOGIC_VECTOR(signed(A) MOD signed(B));

    -- UnDIV
    ResultUnDIV <= STD_LOGIC_VECTOR(unsigned(A) / unsigned(B));
    ResultUnMOD <= STD_LOGIC_VECTOR(unsigned(A) MOD unsigned(B));

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

    -- INC
    TempINC <= unsigned('0' & A) + to_unsigned(1, 65);
    ResultINC <= STD_LOGIC_VECTOR(TempINC)(63 DOWNTO 0);
    CoutINC <= TempINC(64);
    OverflowINC <= (NOT A(63) AND ResultINC(63));

    -- DEC
    USTemp <= (OTHERS => '1');
    TempDEC <= unsigned('0' & A) + unsigned('0' & USTemp);
    ResultDEC <= STD_LOGIC_VECTOR(TempDEC)(63 DOWNTO 0);
    CoutDEC <= TempDEC(64);
    OverflowDEC <= (A(63) AND NOT ResultDEC(63));

    -- NEG
    TempNEG <= unsigned('0' & (NOT A)) + to_unsigned(1, 65);
    ResultNEG <= STD_LOGIC_VECTOR(TempNEG)(63 DOWNTO 0);
    CoutNEG <= TempNEG(64);
    OverflowNEG <= '1' WHEN A = (63 => '1', OTHERS => '0') ELSE
        '0';
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Shift and Rotating operations
    -- SHL
    ResultSHL <= A(62 DOWNTO 0) & '0';
    CoutSHL <= A(63);

    -- SHR
    ResultSHR <= '0' & A(63 DOWNTO 1);
    CoutSHR <= A(0);

    -- ASR
    ResultASR <= A(63) & A(63 DOWNTO 1);
    CoutASR <= A(0);

    -- ROL
    ResultROL <= A(62 DOWNTO 0) & A(63);

    -- ROR
    ResultROR <= A(0) & A(63 DOWNTO 1);
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Enable and Select
    Enable <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 32), to_integer(unsigned(S))))
        WHEN (unsigned(S) <= 12) OR ((unsigned(S) >= 16) AND (unsigned(S) <= 25)) ELSE
        x"80000000";
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Multiplexing
    Result <=
        -- Logic operations
        (ResultNOT AND (63 DOWNTO 0 => Enable(0)))
        OR (ResultAND AND (63 DOWNTO 0 => Enable(1)))
        OR (ResultOR AND (63 DOWNTO 0 => Enable(2)))
        OR (ResultXOR AND (63 DOWNTO 0 => Enable(3)))
        OR (ResultNAND AND (63 DOWNTO 0 => Enable(4)))
        OR (ResultNOR AND (63 DOWNTO 0 => Enable(5)))
        OR (ResultXNOR AND (63 DOWNTO 0 => Enable(6)))
        -- Compare operations
        OR (ResultEQ AND (63 DOWNTO 0 => Enable(7)))
        OR (ResultNE AND (63 DOWNTO 0 => Enable(8)))
        OR (ResultS AND (63 DOWNTO 0 => Enable(9)))
        OR (ResultG AND (63 DOWNTO 0 => Enable(10)))
        OR (ResultSE AND (63 DOWNTO 0 => Enable(11)))
        OR (ResultGE AND (63 DOWNTO 0 => Enable(12)))
        -- Arithmetic operations
        OR (ResultADD AND (63 DOWNTO 0 => Enable(16)))
        OR (ResultSUB AND (63 DOWNTO 0 => Enable(17)))
        OR (ResultINC AND (63 DOWNTO 0 => Enable(18)))
        OR (ResultDEC AND (63 DOWNTO 0 => Enable(19)))
        OR (ResultNEG AND (63 DOWNTO 0 => Enable(20)))
        -- Shift and Rotating operations
        OR (ResultSHL AND (63 DOWNTO 0 => Enable(21)))
        OR (ResultSHR AND (63 DOWNTO 0 => Enable(22)))
        OR (ResultASR AND (63 DOWNTO 0 => Enable(23)))
        OR (ResultROL AND (63 DOWNTO 0 => Enable(24)))
        OR (ResultROR AND (63 DOWNTO 0 => Enable(25)))
        -- Buffer and invalid opcodes
        OR (A AND (63 DOWNTO 0 => Enable(31)));

    -- Multiplexing Cout
    Cout <=
        -- Arithmetic operations
        (CoutADD AND Enable(16))
        OR (CoutSUB AND Enable(17))
        OR (CoutINC AND Enable(18))
        OR (CoutDEC AND Enable(19))
        OR (CoutNEG AND Enable(20))
        -- Shift and Rotating operations
        OR (CoutSHL AND Enable(21))
        OR (CoutSHR AND Enable(22))
        OR (CoutASR AND Enable(23));

    -- Multiplexing Overflow
    Overflow <=
        (OverflowADD AND Enable(16))
        OR (OverflowSUB AND Enable(17))
        OR (OverflowINC AND Enable(18))
        OR (OverflowDEC AND Enable(19))
        OR (OverflowNEG AND Enable(20));

END struct;