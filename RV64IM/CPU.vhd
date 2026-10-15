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
END Struct;