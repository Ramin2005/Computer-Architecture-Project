-- 64-bit Program Counter Register
-- Stores program counter state with reset, load and increment controls
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PCRegister IS
    PORT (
        CLK : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        S : IN STD_LOGIC;
        Offset : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY PCRegister;

-- Architecture of Program Counter Register
ARCHITECTURE Struct OF PCRegister IS

    SIGNAL QR : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

    PROCESS (CLK)
    BEGIN

        IF rising_edge(CLK) AND Reset = '1' THEN
            QR <= (OTHERS => '0');

        ELSIF rising_edge(CLK) AND S = '0' THEN
            QR <= STD_LOGIC_VECTOR(unsigned(QR) + to_unsigned(4, 64));

        ELSIF rising_edge(CLK) AND S = '1' THEN
            QR <= STD_LOGIC_VECTOR(unsigned(QR) + unsigned(Offset));

        END IF;

    END PROCESS;

    Q <= QR;

END Struct;