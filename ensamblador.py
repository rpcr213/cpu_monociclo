# ED con opcodes
OPCODES = {
    "add":  "0000",
    "sub":  "0001",
    "and":  "0010",
    "or":   "0011",
    "xor":  "0100",
    "not":  "0101",
    "ld":   "0110",
    "st":   "0111",
    "bne":  "1000",
    "beq":  "1001",
    "j":    "1010",
    "sr":   "1011",
    "sl":   "1100",
    "addi": "1101",
    "nop":  "1110",
    "li":   "1111"
}

def reg_to_bits(reg):
    reg = reg.upper()
    if reg not in ["R0", "R1", "R2", "R3"]:
        return None
    return format(int(reg[1]), "02b")

def parse_line(line):
    line = line.strip()

    if line == "":
        return None, None

    if line.lower() == "nop":
        return "11100000", None

    if " " not in line:
        return None, f"Error: instruccion mal formada -> {line}"

    instr, args = line.split(" ", 1)
    instr = instr.lower()

    if instr not in OPCODES:
        return None, f"Error: instruccion desconocida -> {line}"

    opcode = OPCODES[instr]

    if instr in ["add", "sub", "and", "or", "xor", "ld", "st", "bne", "beq"]:
        if ", " not in args:
            return None, f"Error: formato invalido' -> {line}"

        r0, r1 = args.split(", ")
        b0 = reg_to_bits(r0)
        b1 = reg_to_bits(r1)
        if b0 is None or b1 is None:
            return None, f"Error: registro invalido -> {line}"

        return opcode + b0 + b1, None

    elif instr == "not":
        r0 = args
        b0 = reg_to_bits(r0)
        if b0 is None:
            return None, f"Error: registro invalido -> {line}"
        return opcode + b0 + "00", None

    elif instr in ["sr", "sl", "addi", "li"]:
        if ", " not in args:
            return None, f"Error: formato invalido' -> {line}"

        r0, imm = args.split(", ")
        b0 = reg_to_bits(r0)
        if b0 is None:
            return None, f"Error: registro invalido -> {line}"

        if not imm.isdigit():
            return None, f"Error: inmediato no decimal -> {line}"

        imm_val = int(imm)
        if not (0 <= imm_val <= 3):
            return None, f"Error: inmediato fuera de rango (0-3) -> {line}"

        bimm = format(imm_val, "02b")
        return opcode + b0 + bimm, None

    elif instr == "j":
        if not args.isdigit():
            return None, f"Error: inmediato no decimal -> {line}"

        imm_val = int(args)
        if not (0 <= imm_val <= 15):
            return None, f"Error: inmediato fuera de rango (0-15) -> {line}"

        bimm = format(imm_val, "04b")
        return opcode + bimm, None

    else:
        return None, f"Error: instruccion no soportada -> {line}"

def main():
    filename = input("Nombre del archivo: ")

    try:
        with open(filename, "r") as f:
            lines = f.readlines()
    except FileNotFoundError:
        print("Error: archivo no encontrado")
        return

    maquina = []

    for line in lines:
        line = line.rstrip("\n")

        if line.strip() == "":
            break

        code, err = parse_line(line)
        if err:
            print(err)
            continue

        maquina.append(code)

    with open("codigo_maquina.txt", "w") as out:
        for i, code in enumerate(maquina):
            out.write(f'{i} => b"{code}",\n')

    print("codigo_maquina.txt generado con exito")

if __name__ == "__main__":
    main()
