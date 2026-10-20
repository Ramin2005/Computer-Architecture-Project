LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Control IS
    PORT (
        Opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        Branch : OUT STD_LOGIC;
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        RegSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RegWrite : OUT STD_LOGIC;
        ALUSrc : OUT STD_LOGIC;
        ALUOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Control;

ARCHITECTURE Struct OF Control IS
BEGIN

    PROCESS (Opcode)
    BEGIN

        Branch <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        RegSrc <= "00";
        RegWrite <= '0';
        ALUSrc <= '0';
        ALUOp <= "000";

        CASE Opcode IS

                -- Load
            WHEN "0000011" =>
                MemRead <= '1';
                RegSrc <= "01";
                RegWrite <= '1';
                ALUSrc <= '1';

                -- Store
            WHEN "0100011" =>
                MemWrite <= '1';
                ALUSrc <= '1';

                --
            WHEN "0010011" =>
                RegWrite <= '1';
                ALUSrc <= '1';
                ALUOp <= "011";

                -- 
            WHEN "0011011" =>
                RegWrite <= '1';
                ALUSrc <= '1';
                ALUOp <= "101";

                -- 
            WHEN "0110111" =>
                RegWrite <= '1';
                ALUSrc <= '1';

                -- 
            WHEN "0010111" =>
                RegWrite <= '1';
                ALUSrc <= '1';

                -- 
            WHEN "0110011" =>
                RegWrite <= '1';
                ALUOp <= "010";

                -- 
            WHEN "0111011" =>
                RegWrite <= '1';
                ALUOp <= "100";

                -- 
            WHEN "1100011" =>
                Branch <= '1';
                ALUOp <= "001";

                -- 
            WHEN "1101111" =>
                RegSrc <= "10";
                RegWrite <= '1';
                ALUSrc <= '1';

                -- 
            WHEN "1100111" =>
                RegSrc <= "10";
                RegWrite <= '1';
                ALUSrc <= '1';

                -- 
            WHEN "0001011" =>
                RegWrite <= '1';
                ALUOp <= "110";

                -- 
            WHEN "0101011" =>
                RegWrite <= '1';
                ALUSrc <= '1';
                ALUOp <= "111";

            WHEN OTHERS =>
                NULL;

        END CASE;

    END PROCESS;
END Struct;