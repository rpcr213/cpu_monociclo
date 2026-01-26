library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity controller is
Port (
    data : in std_logic_vector(4 downto 0);
    ctrl : out std_logic_vector(10 downto 0)
);
end controller;

architecture Behavioral of controller is



-- alias
-- ctrl
alias sel_mux2a1_1 : std_logic is ctrl(0);
alias write_banco_regs : std_logic is ctrl(1);
alias sel_mux2a1_2 : std_logic is ctrl(2);
alias ctrl_alu : std_logic_vector(2 downto 0) is ctrl(5 downto 3);
alias we_ram : std_logic is ctrl(6);
alias sel_mux2a1_3 : std_logic is ctrl(7);
alias sel_mux2a1_4 : std_logic is ctrl(8);
alias sel_mux2a1_5 : std_logic is ctrl(9);
alias sel_mux2a1_51 : std_logic is ctrl(10);
-- data
alias opcode : std_logic_vector(3 downto 0) is data(3 downto 0);
alias z_value : std_logic is data(4);


begin

process (opcode, z_value)
begin
    -- valores por defecto
    ctrl <= (others => '0');
    
    case opcode is
    -- ADD
    -- R1 <- R1 + R2
        when "0000" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- SUB
    -- R1 <- R1 - R2
        when "0001" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "001";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- AND
    -- R1 <- R1 & R2 (bit a bit)
        when "0010" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "010";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- OR
    -- R1 <- R1 | R2 (bit a bit)
        when "0011" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "011";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- XOR
    -- R1 <- R1 XOR R2 (bit a bit)
        when "0100" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "100";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- NOT
    -- R1 <- not(R1) (bit a bit)
        when "0101" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "101";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- LOAD
    -- carga el valor almacenado en la direccion R2 en R1
        when "0110" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '0';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- STORE
    -- guarda el valor almacenado en R2 en dir(R1)
    -- !!
        when "0111" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '0';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '1';
            sel_mux2a1_3     <= '0';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '0';
    -- BNE
    -- tanto BNE como BEQ saltaran hacia la direccion guardada en R3
        when "1000" =>
            sel_mux2a1_1     <= not(z_value);
            write_banco_regs <= '0';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '0';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '0';
            sel_mux2a1_51    <= '1';
    -- BEQ
        when "1001" =>
            sel_mux2a1_1     <= z_value;
            write_banco_regs <= '0';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '0';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '1';
            sel_mux2a1_51    <= '0';
    -- JUMP
    -- instruccion que solo saltara hacia atras, desde 0 hasta 15 instrucciones (ideal para bucles)
        when "1010" =>
            sel_mux2a1_1     <= '1';
            write_banco_regs <= '0';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '0';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '0';
    -- SR
    -- shift right
        when "1011" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '1';
            ctrl_alu         <= "110";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
    -- SL 
    -- shift left
        when "1100" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '1';
            ctrl_alu         <= "111";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
    -- ADDI
    -- R1 <- R1 + imm (imm = [1:0] rom_output)
        when "1101" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '1';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '1';
            sel_mux2a1_5     <= '0';
    -- NOP
    -- no hace nada
        when "1110" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '0';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '0';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '0';
    -- LI
    -- R1 <- imm (imm = [1:0] rom_output)
        when "1111" =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '1';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '0';
            
        when others =>
            sel_mux2a1_1     <= '0';
            write_banco_regs <= '1';
            sel_mux2a1_2     <= '0';
            ctrl_alu         <= "000";
            we_ram           <= '0';
            sel_mux2a1_3     <= '1';
            sel_mux2a1_4     <= '0';
            sel_mux2a1_5     <= '0';
            
    end case;




end process;




end Behavioral;
