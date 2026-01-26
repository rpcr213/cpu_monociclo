
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity multiplexor4a1_8bits is
Port (
    sel : in std_logic_vector(1 downto 0);
    e1 : in std_logic_vector(7 downto 0);
    e2 : in std_logic_vector(7 downto 0);
    e3 : in std_logic_vector(7 downto 0);
    e4 : in std_logic_vector(7 downto 0);
    s : out std_logic_vector(7 downto 0)
);
end multiplexor4a1_8bits;

architecture Behavioral of multiplexor4a1_8bits is

begin
s <= e1 when sel = "00" else
     e2 when sel = "01" else
     e3 when sel = "10" else
     e4;

end Behavioral;
