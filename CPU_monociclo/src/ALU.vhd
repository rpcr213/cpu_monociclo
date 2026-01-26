-- unidad aritmetico logica de 8 bits
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ALU is
Port (
ctrl : in std_logic_vector(2 downto 0);
e1 : in std_logic_vector(7 downto 0);
e2 : in std_logic_vector(7 downto 0);
s : out std_logic_vector(7 downto 0);
Z : out std_logic
);
end ALU;

architecture Behavioral of ALU is
signal sl : std_logic_vector(7 downto 0);
signal sr : std_logic_vector(7 downto 0);


begin


process (ctrl, e1, e2)
begin
case ctrl is 
    when "000" =>
        s <= std_logic_vector(unsigned(e1) + unsigned(e2)); 
    when "001" =>
        s <= std_logic_vector(unsigned(e1) - unsigned(e2));
    when "010" =>
        s <= e1 and e2;
    when "011" =>
        s <= e1 or e2;
    when "100" =>
        s <= e1 xor e2;
    when "101" =>
        s <= not(e1);
    when "110" =>
        s <= std_logic_vector(shift_right(unsigned(e1), to_integer(unsigned(e2))));
    when "111" =>
        s <= std_logic_vector(shift_left(unsigned(e1), to_integer(unsigned(e2))));
    when others => 
        s <= e1;
end case;
end process;

Z <= '1' when e1 = e2 else '0';


end Behavioral;
