LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALUControl IS
    PORT (
            Instruction14to12: in std_logic_vector(14 downto 12);
            Instruction30: in std_logic_vector(30 downto 30);
            ALUOp: in std_logic_vector(5 downto 0);
            ALUSelect : out std_logic_vector(5 downto 0)
    );
END ENTITY ALUControl;

architecture Struct of ALUControl is 
begin
end Struct;