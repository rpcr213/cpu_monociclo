library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_core is
end tb_core;

architecture Behavioral of tb_core is

component controller is
Port (
    data : in std_logic_vector(4 downto 0);
    ctrl : out std_logic_vector(10 downto 0)
);
end component;

component data_path is
Port (
    clk : in std_logic;
    rst : in std_logic;
    ctrl : in std_logic_vector(10 downto 0);
    data : out std_logic_vector(4 downto 0);
    leds : out std_logic_vector(15 downto 0);
    numero_instruccion : out std_logic_vector(7 downto 0)
);
end component;

signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '0';
signal ctrl_tb : std_logic_vector(10 downto 0);
signal data_tb : std_logic_vector(4 downto 0);
signal leds_tb : std_logic_vector(15 downto 0);
signal numero_instruccion_tb : std_logic_vector(7 downto 0);

constant CLK_PERIOD : time := 10 ns;

begin

controlador: controller
port map (
    data => data_tb,
    ctrl => ctrl_tb
);

ruta_datos: data_path
port map (
    clk => clk_tb,
    rst => rst_tb,
    ctrl => ctrl_tb,
    data => data_tb,
    leds => leds_tb,
    numero_instruccion => numero_instruccion_tb
);

clk_process: process
begin
    clk_tb <= '0';
    wait for CLK_PERIOD/2;
    clk_tb <= '1';
    wait for CLK_PERIOD/2;
end process;

stimulus: process
begin
    rst_tb <= '1';
    wait for 20 ns;
    rst_tb <= '0';
    
    wait for CLK_PERIOD * 130;
    
    wait;
end process;

end Behavioral;