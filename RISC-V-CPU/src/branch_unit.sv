// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Branch Unit
//
// Descripción:
// Evalúa la condición de las instrucciones de bifurcación
// (beq, blt y bge) a partir de los operandos rs1 y rs2 y del
// campo funct3. Genera BranchTaken = 1 cuando la bifurcación
// debe tomarse. La comparación blt/bge interpreta los
// operandos como enteros de 32 bits CON signo. Se usa un
// comparador propio (no la resta de la ALU) porque el signo
// del resultado de A - B es incorrecto cuando hay desbordamiento
// (ej.: 0x80000000 - 1 = 0x7FFFFFFF).
//
// Autor / Developer: Pablo Cabrera
// Nombre: branch_unit.sv
// Fecha de primera versión: 24/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 24/11/2026  | Pablo Cabrera      | Primera versión
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// RD1          : Operando rs1 (32 bits, leído del banco de registros).
// RD2          : Operando rs2 (32 bits, leído del banco de registros).
// funct3       : Instr[14:12]. Selecciona la condición:
//                000 = beq (rs1 == rs2)
//                100 = blt (rs1 <  rs2, con signo)
//                101 = bge (rs1 >= rs2, con signo)
// Branch       : Viene de la unidad de control. 1 = la instrucción
//                actual es una bifurcación.
//
// SALIDAS
// ------------------------------------------------------------
// BranchTaken  : 1 = la condición se cumple y se debe saltar
//                (PCNext = PC + inmediato B).
//                0 = ejecución secuencial (PCNext = PC + 4), también
//                cuando Branch = 0 o funct3 no está soportado.
// ============================================================

module branch_unit (
    input  logic [31:0] RD1,
    input  logic [31:0] RD2,
    input  logic [ 2:0] funct3,
    input  logic        Branch,
    output logic        BranchTaken
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  // Comparaciones entre rs1 y rs2
  logic eq;  // rs1 == rs2
  logic lt;  // rs1 <  rs2 (con signo)

  assign eq = (RD1 == RD2);
  assign lt = ($signed(RD1) < $signed(RD2));

  // Selección de la condición según funct3.
  // Valor por defecto = 0: sin bifurcación (evita latches y saltos
  // espurios con funct3 no soportado).
  always_comb begin
    BranchTaken = 1'b0;
    if (Branch) begin
      case (funct3)
        3'b000:  BranchTaken = eq;  // beq
        3'b100:  BranchTaken = lt;  // blt
        3'b101:  BranchTaken = ~lt;  // bge
        default: BranchTaken = 1'b0;
      endcase
    end
  end

endmodule