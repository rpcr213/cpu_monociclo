-- banco de 4 registros de 8 bits


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--er: registro seleccionado (Entrada Registro)
--sr: dato de registro que sale (Salida Registro)
--write: si escribimos o no en el registro
--rae: registro a escribir
--wb: datos que se van a escribir (si se escribe en un registro)

entity banco_registros is
Port (
    clk : in std_logic;
    clk_p : in std_logic;
    rst : in std_logic;
    write : in std_logic;
    wb : in std_logic_vector(7 downto 0);
    er1 : in std_logic_vector(1 downto 0);
    er2 : in std_logic_vector(1 downto 0);
    rae : in std_logic_vector(1 downto 0);
    sr1 : out std_logic_vector(7 downto 0);
    sr2 : out std_logic_vector(7 downto 0);
    sr3 : out std_logic_vector(7 downto 0)
);
end banco_registros;

architecture Behavioral of banco_registros is
-- componentes
component registro is
Port (
    clk : in std_logic;
    clk_p : in std_logic;
    rst : in std_logic;
    load : in std_logic;
    E : in std_logic_vector(7 downto 0);
    S : out std_logic_vector(7 downto 0)
);
end component;

component multiplexor4a1_8bits is
Port (
    sel : in std_logic_vector(1 downto 0);
    e1 : in std_logic_vector(7 downto 0);
    e2 : in std_logic_vector(7 downto 0);
    e3 : in std_logic_vector(7 downto 0);
    e4 : in std_logic_vector(7 downto 0);
    s : out std_logic_vector(7 downto 0)
);
end component;

component decodificador2a4 is
Port (
    sel : in std_logic_vector(1 downto 0);
    enable : in std_logic;
    s : out std_logic_vector(3 downto 0)
);
end component;

-- seniales

-- seniales auxiliares de datos de salida de registros
signal asr1 : std_logic_vector(7 downto 0);
signal asr2 : std_logic_vector(7 downto 0);
signal asr3 : std_logic_vector(7 downto 0);
signal asr4 : std_logic_vector(7 downto 0);
-- seniales auxiliares de datos de entrada de registros
signal aer1 : std_logic_vector(7 downto 0);
signal aer2 : std_logic_vector(7 downto 0);
signal aer3 : std_logic_vector(7 downto 0);
signal aer4 : std_logic_vector(7 downto 0);
-- seniales auxiliares de cuando hay que cargar
signal lr : std_logic_vector(3 downto 0);
-- reset global
--signal rst : std_logic;


begin
-- port maps
r1: registro
port map (
    clk => clk,
    clk_p => clk_p,
    rst => rst,
    load => lr(0),
    E => wb,
    S => asr1
);

r2: registro
port map (
    clk => clk,
    clk_p => clk_p,
    rst => rst,
    load => lr(1),
    E => wb,
    S => asr2
);

r3: registro
port map (
    clk => clk,
    clk_p => clk_p,
    rst => rst,
    load => lr(2),
    E => wb,
    S => asr3
);

r4: registro
port map (
    clk => clk,
    clk_p => clk_p,
    rst => rst,
    load => lr(3),
    E => wb,
    S => asr4
);

mux1 : multiplexor4a1_8bits
port map(
    sel => er1,
    e1 => asr1,
    e2 => asr2,
    e3 => asr3,
    e4 => asr4,
    s => sr1
);

mux2 : multiplexor4a1_8bits
port map(
    sel => er2,
    e1 => asr1,
    e2 => asr2,
    e3 => asr3,
    e4 => asr4,
    s => sr2
);

mux3 : multiplexor4a1_8bits
port map(
    sel => "11",
    e1 => asr1,
    e2 => asr2,
    e3 => asr3,
    e4 => asr4,
    s => sr3
);

--  cambio
dec : decodificador2a4
port map (
    sel => er1,
    enable => write,
    s => lr
);

end Behavioral;