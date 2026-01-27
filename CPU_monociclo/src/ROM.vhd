-- ROM de 256 bytes

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ROM is
Port (
    dir : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0)
);
end ROM;

architecture rtl of ROM is
-- creamos un array que contiene muchos std_logic_vector dentro
type rom_array is array (0 to 255) of std_logic_vector(7 downto 0);

-- definimos el contenido de dentro del array
constant ROM_CONTENT : rom_array := (
0 => b"11100000",
1 => b"11100000",
2 => b"11100000",
3 => b"11100000",
4 => b"11111011",
5 => b"11001010",
6 => b"11011001",
7 => b"11110100",
8 => b"11110000",
9 => b"11111111",
10 => b"11001110",
11 => b"11011111",
12 => b"11011110",
13 => b"10010110",
14 => b"11010101",
15 => b"00000010",
16 => b"10100011",
17 => b"11111100",
18 => b"01110011",
19 => b"11100000",
20 => b"11100000",
21 => b"11110100",
22 => b"11100000",
23 => b"11100000",
24 => b"01100111",
25 => b"11100000",
26 => b"11010101",
27 => b"11010101",
28 => b"11010101",
29 => b"11100000",
30 => b"11100000",
others => (others => '0')
);


begin
-- adaptamos la salida para lo que especifiquemos en la entrada, haciendo las transformaciones correspondientes para los indices
data_out <= ROM_CONTENT(to_integer(unsigned(dir)));

end rtl;
