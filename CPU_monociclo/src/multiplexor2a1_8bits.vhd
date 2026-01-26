library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexor2a1_8bits is
Port (
    sel : in std_logic;
    e1 : in std_logic_vector(7 downto 0);
    e2 : in std_logic_vector(7 downto 0);
    s : out std_logic_vector(7 downto 0)
);
end multiplexor2a1_8bits;

architecture Behavioral of multiplexor2a1_8bits is

begin
s <= e1 when sel = '0' else e2;

end Behavioral;
