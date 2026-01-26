library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador2a4 is
Port (
    sel : in std_logic_vector(1 downto 0);
    enable : in std_logic;
    s : out std_logic_vector(3 downto 0)
);
end decodificador2a4;

architecture Behavioral of decodificador2a4 is

begin
    process (sel, enable)
    begin
        if (enable = '0') then
            s <= (others => '0');
        else
            case sel is
                when "00" => s <= "0001";
                when "01" => s <= "0010";
                when "10" => s <= "0100";
                when "11" => s <= "1000";
                when others => s <= (others => '1');
            end case;
        end if;
    end process;
end Behavioral;
