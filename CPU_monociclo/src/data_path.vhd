library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity data_path is
Port (
    clk : in std_logic;
    rst : in std_logic;
    ctrl : in std_logic_vector(10 downto 0);
    data : out std_logic_vector(4 downto 0);
    leds : out std_logic_vector(15 downto 0);
    numero_instruccion : out std_logic_vector(7 downto 0)
);
end data_path;

architecture Behavioral of data_path is

-- componentes
component registro is
Port (
    clk : in std_logic;
    rst : in std_logic;
    load : in std_logic;
    E : in std_logic_vector(7 downto 0);
    S : out std_logic_vector(7 downto 0)
);
end component;

component multiplexor2a1_8bits is
Port (
    sel : in std_logic;
    e1 : in std_logic_vector(7 downto 0);
    e2 : in std_logic_vector(7 downto 0);
    s : out std_logic_vector(7 downto 0)
);
end component;

component ROM is
Port (
    dir : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0)
);
end component;


component banco_registros is
Port (
    clk : in std_logic;
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
end component;

component ALU is
Port (
ctrl : in std_logic_vector(2 downto 0);
e1 : in std_logic_vector(7 downto 0);
e2 : in std_logic_vector(7 downto 0);
s : out std_logic_vector(7 downto 0);
Z : out std_logic
);
end component;

component RAM is
Port (
    we : in std_logic;
    clk : in std_logic;
    dir : in std_logic_vector(7 downto 0);
    din : in std_logic_vector(7 downto 0); 
    dout : out std_logic_vector(7 downto 0)
);
end component;

-- seniales
-- la dir que calcula la ALU y entra al PC
signal entrada_pc : std_logic_vector(7 downto 0);
signal dir_salida_pc : std_logic_vector(7 downto 0);
signal codigo_salida_rom : std_logic_vector(7 downto 0);
signal salida_sumador : std_logic_vector(7 downto 0);
-- esto son los valores que valdran el primer y segundo registro (salen del banco)
signal valor_primer_registro : std_logic_vector(7 downto 0);
signal valor_segundo_registro : std_logic_vector(7 downto 0);
signal valor_tercer_registro : std_logic_vector(7 downto 0);
signal imm_extendido : std_logic_vector(7 downto 0);
--signal entrada_ALU_1 : std_logic_vector(7 downto 0);
signal salida_mux2a1_2 : std_logic_vector(7 downto 0);
signal salida_alu : std_logic_vector(7 downto 0);
signal salida_ram : std_logic_vector(7 downto 0);
signal salida_mux2a1_3 : std_logic_vector(7 downto 0);
signal salida_restador : std_logic_vector(7 downto 0);
signal z_value : std_logic;
signal entrada_extendida_restador : std_logic_vector(7 downto 0);
signal salida_mux2a1_4 : std_logic_vector(7 downto 0);
signal salida_mux2a1_5 : std_logic_vector(7 downto 0);
signal branch : std_logic := '0';
--signal send_data : std_logic_vector(4 downto 0);

-- alias de la senial que envia el controlador
alias sel_mux2a1_1 : std_logic is ctrl(0);
alias write_banco_regs : std_logic is ctrl(1);
alias sel_mux2a1_2 : std_logic is ctrl(2);
alias ctrl_alu : std_logic_vector(2 downto 0) is ctrl(5 downto 3);
alias we_ram : std_logic is ctrl(6);
alias sel_mux2a1_3 : std_logic is ctrl(7);
alias sel_mux2a1_4 : std_logic is ctrl(8);
alias sel_mux2a1_5 : std_logic is ctrl(9);
alias sel_mux2a1_51 : std_logic is ctrl(10);

begin

-- portmaps
-- este es el mux que filtra entre si saltar o avanzar 1 en la rom
mux2a1_1 : multiplexor2a1_8bits
port map (
    sel => sel_mux2a1_1,
    e1 => salida_sumador,
    e2 => salida_restador,
    s => entrada_pc
);

-- esto es el registro que va a la rom, osea el registro del pc
PC : registro
port map (
    clk => clk,
    rst => rst,
    load => '1',
    E => salida_mux2a1_5,
    S => dir_salida_pc
);

-- memoria que contiene las instrucciones
c_rom : ROM
port map (
    dir => dir_salida_pc,
    data_out => codigo_salida_rom
);

-- sumador que va sumando de uno en uno para pasar a la siguiente instruccion
sumador_instrucciones : ALU
port map (
    ctrl => "000",
    e1 => dir_salida_pc,
    e2 => "00000001",
    s => salida_sumador,
    Z => open
);


banco_regs : banco_registros
port map (
    clk => clk,
    rst => rst,
    write => write_banco_regs,
    wb => salida_mux2a1_4,
    er1 => codigo_salida_rom(3 downto 2),
    er2 => codigo_salida_rom(1 downto 0),
    rae => codigo_salida_rom(3 downto 2),
    sr1 => valor_primer_registro,
    sr2 => valor_segundo_registro,
    sr3 => valor_tercer_registro
);

-- esto se encarga de pillar el valor inmediato o el valor del registro para las operaciones como add
mux2a1_2 : multiplexor2a1_8bits
port map (
    sel => sel_mux2a1_2,
    e1 => valor_segundo_registro,
    e2 => imm_extendido,
    s => salida_mux2a1_2
);

c_alu : ALU
port map (
    ctrl => ctrl_alu,
    e1 => valor_primer_registro,
    e2 => salida_mux2a1_2,
    s => salida_alu,
    Z => z_value
);

-- se dedica a restar las instrucciones que le diga el jump
restador_instrucciones : ALU
port map (
    ctrl => "001",
    e1 => dir_salida_pc,
    e2 => entrada_extendida_restador,
    s => salida_restador,
    Z => open
);

-- !! difiere del esquema !!
c_ram : RAM
port map (
    we => we_ram,
    clk => clk,
    dir => valor_segundo_registro,
    din => valor_primer_registro,
    dout => salida_ram
);

mux2a1_3 : multiplexor2a1_8bits
port map (
    sel => sel_mux2a1_3,
    e1 => salida_ram,
    e2 => salida_alu,
    s => salida_mux2a1_3
);

-- es el que se va a encargar de filtrar entre un inmediato o el valor de la ALU
mux2a1_4 : multiplexor2a1_8bits
port map (
    sel => sel_mux2a1_4,
    e1 => imm_extendido,
    e2 => salida_mux2a1_3,
    s => salida_mux2a1_4
);

mux2a1_5 : multiplexor2a1_8bits
port map (
    sel => branch,
    e1 => entrada_pc,
    e2 => valor_tercer_registro,
    s => salida_mux2a1_5
);

-- extension de 2 bits a 8 bits
imm_extendido <= "000000" & codigo_salida_rom(1 downto 0);
entrada_extendida_restador <= "0000" & codigo_salida_rom(3 downto 0);
-- datos que se envian al controlador
data <= z_value & codigo_salida_rom(7 downto 4);

-- operaciones
-- esto nos dice si beq o bne quieren saltar
branch <= (sel_mux2a1_5 and z_value) or (sel_mux2a1_51 and not(z_value));



-- salida de leds
-- los 8 leds de la izquierda muestran la instruccion en ejecucion, los 8 leds de la derecha el resultado de la operacion
leds <= codigo_salida_rom & salida_mux2a1_3;
-- por los 7 segmentos, muestra el numero de instruccion que se va a ejecutar
numero_instruccion <= dir_salida_pc;



end Behavioral;
