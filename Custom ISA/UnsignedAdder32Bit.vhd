LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY UnsignedAdder32Bit IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Sum : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY UnsignedAdder32Bit;

ARCHITECTURE Struct OF UnsignedAdder32Bit IS
    SIGNAL Temp : unsigned(32 DOWNTO 0);
BEGIN

    Temp <= unsigned('0' & A) + unsigned('0' & B);
    Sum <= STD_LOGIC_VECTOR(Temp(31 DOWNTO 0));

END Struct;