-- RAM
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
Port (
    we : in std_logic;
    rst : in std_logic;
    clk : in std_logic;
    clk_p : in std_logic;
    dir : in std_logic_vector(7 downto 0);
    din : in std_logic_vector(7 downto 0); 
    dout : out std_logic_vector(7 downto 0)
);
end RAM;

architecture Behavioral of RAM is
    type ram_array is array (0 to 255) of std_logic_vector(7 downto 0);
    signal ram_content : ram_array := (others => (others => '0'));
begin

process (clk, rst)
begin
    if rst = '1' then
        ram_content <= (others => (others => '0'));
    elsif rising_edge(clk) then
        if clk_p = '1' then
            if we = '1' then
                ram_content(to_integer(unsigned(dir))) <= din;
            end if;
        end if;
    end if;
end process;

-- lectura combinacional
dout <= ram_content(to_integer(unsigned(dir)));

end Behavioral;
