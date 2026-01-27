-- registro de 8 bits, la CPU tendra 4

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity registro is
Port (
    clk : in std_logic;
    clk_p : in std_logic;
    rst : in std_logic;
    load : in std_logic;
    E : in std_logic_vector(7 downto 0);
    S : out std_logic_vector(7 downto 0)
);
end registro;

architecture Behavioral of registro is

begin

process (clk, rst)
begin
    if rst = '1' then
        S <= (others => '0');
    elsif rising_edge(clk) then
        if (load = '1' and clk_p = '1') then
            S <= E;
        end if;
    end if;
end process;


end Behavioral;
