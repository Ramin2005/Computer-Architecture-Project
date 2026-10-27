LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ImmGen IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Immediate : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY ImmGen;

ARCHITECTURE Struct OF ImmGen IS
BEGIN

    PROCESS (Instruction)
    BEGIN

        CASE Instruction(6 DOWNTO 0) IS

            WHEN "0000011" =>
                Immediate <= (63 DOWNTO 12 => Instruction(31)) & Instruction(31 DOWNTO 20);

            WHEN "0100011" =>
                Immediate <= (OTHERS => '0');

            WHEN OTHERS =>
                Immediate <= (OTHERS => '0');

        END CASE;

    END PROCESS;

END Struct;