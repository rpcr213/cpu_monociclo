library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity core is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        led : out std_logic_vector(15 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
    );
end core;

architecture Behavioral of core is
    -- componentes
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
    
    component divisor is
        port (
            rst: in STD_LOGIC;
            clk_entrada: in STD_LOGIC;
            clk_salida: out STD_LOGIC
        );
    end component;
    
    component conv_7seg is
        Port ( 
            x : in STD_LOGIC_VECTOR(3 downto 0);
            display : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    -- seniales
    signal a_ctrl : std_logic_vector(10 downto 0);
    signal a_data : std_logic_vector(4 downto 0);
    signal clk_1hz : std_logic;
    signal numero_instruccion : std_logic_vector(7 downto 0);
    
    signal contador : unsigned(16 downto 0) := (others => '0');
    signal digito_actual : STD_LOGIC_VECTOR(1 downto 0);
    signal digito_bcd : STD_LOGIC_VECTOR(3 downto 0);
    signal centenas : STD_LOGIC_VECTOR(3 downto 0);
    signal decenas : STD_LOGIC_VECTOR(3 downto 0);
    signal unidades : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    -- port maps
    divisor_frecuencia : divisor
    port map (
        rst => rst,
        clk_entrada => clk,
        clk_salida => clk_1hz
    );
    
    controlador : controller
    port map (
        data => a_data,
        ctrl => a_ctrl
    );
    
    ruta_de_datos : data_path
    port map (
        clk => clk_1hz,
        rst => rst,
        ctrl => a_ctrl,
        data => a_data,
        leds => led,
        numero_instruccion => numero_instruccion
    );
    
    conv: conv_7seg 
    port map(
        x => digito_bcd,
        display => seg
    );
    
    process(numero_instruccion)
        variable temp : unsigned(7 downto 0);
        variable temp_calc : unsigned(7 downto 0);
        variable uni, dec, cen : unsigned(3 downto 0);
    begin
        temp := unsigned(numero_instruccion);
        
        cen := resize(temp / 100, 4);
        temp_calc := temp mod 100;
        
        dec := resize(temp_calc / 10, 4);
        uni := resize(temp_calc mod 10, 4);
        
        centenas <= std_logic_vector(cen);
        decenas <= std_logic_vector(dec);
        unidades <= std_logic_vector(uni);
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            contador <= contador + 1;
        end if;
    end process;
    
    digito_actual <= std_logic_vector(contador(16 downto 15));
    
    process(digito_actual, unidades, decenas, centenas)
    begin
        case digito_actual is
            when "00" =>
                an <= "1110";
                digito_bcd <= unidades;
            when "01" =>
                an <= "1101";
                digito_bcd <= decenas;
            when "10" =>
                an <= "1011";
                digito_bcd <= centenas;
            when others =>
                an <= "0111";
                digito_bcd <= "0000";
        end case;
    end process;
    
end Behavioral;