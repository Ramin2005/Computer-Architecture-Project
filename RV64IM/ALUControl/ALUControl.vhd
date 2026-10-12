LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALUControl IS
    PORT (
            Instruction: in std_logic_vector(3 downto 0);
            ALUOp: in std_logic_vector(5 downto 0);
            ALUSelect : out std_logic_vector(5 downto 0)
    );
END ENTITY ALUControl;

architecture Struct of ALUControl is 
begin
    
end Struct;