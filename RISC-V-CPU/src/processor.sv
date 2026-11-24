// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Processor (Datapath)
//
// Descripción:
// Módulo top. Integra el datapath y la unidad de control
// Conectando los modulos disponibles funcionando a una
// instruccion por ciclo de reloj. Soporta instrucciones
// tipo R, I, S, B (beq, blt, bge) y J (jal).
//
// Autor / Developer:
// Nombre: Pablo Cabrera
// Fecha de primera versión: 13/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 13/11/2026  | Pablo Cabrera      | Primera versión
// 15/11/2026  | Pablo Cabrera      | Correccion typo y eliminacion de INIT_FILE por crashes
// 24/11/2026  | Pablo Cabrera      | lógica de siguiente PC (PC+4 / PC+inmediato),
//             |                    | branch_unit y ruta PC+4 -> rd (jal) con mux3to1
// ____/____/  | _________________  | ________________________
//
// ============================================================
// ------------------------------------------------------------
//
// ENTRADAS
// ------------------------------------------------------------
// clk          : El PC, el banco de registros y la memoria
//                de datos se actualizan en el flanco positivo.
// reset        : Reinicio síncrono, activo en alto.
//
// SALIDAS
// ------------------------------------------------------------
// PC           : Dirección de la instrucción actual.
// Instr        : Instrucción actual de 32 bits.
// ============================================================

module processor (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] PC,
    output logic [31:0] Instr
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  // Señales internas
  logic [31:0] PCNext;  // siguiente PC (salida del mux de PC)
  logic [31:0] PCPlus4;  // PC + 4
  logic [31:0] PCTarget;  // PC + inmediato (destino de beq/blt/bge/jal)
  logic [31:0] RD1, RD2;  // datos leídos de rs1 y rs2
  logic [31:0] ImmExt;  // inmediato extendido a 32 bits
  logic [31:0] SrcB;  // selección del 2do operando de la ALU
  logic [31:0] ALUResult;  // resultado
  logic [31:0] ReadData;  // dato de la memoria de datos
  logic [31:0] Result;  // dato a escribir en rd
  logic        Zero;  // flag de la ALU (no se usa para decidir bifurcaciones)

  // Señales de control de control_unit
  logic        RegWrite, ALUSrc, MemWrite;
  logic [ 1:0] ResultSrc;  // 00 = ALU, 01 = memoria, 10 = PC + 4
  logic [ 1:0] ImmSrc;  // 00 = I, 01 = S, 10 = B, 11 = J
  logic [ 3:0] ALUControl;
  logic        Branch, Jump;

  // Señales de la lógica de siguiente PC
  logic        BranchTaken;  // condición de bifurcación cumplida (branch_unit)
  logic        PCSrc;  // 0 = PC + 4, 1 = PC + inmediato

  // --------------------------------------------------------
  // Siguiente PC:
  //   PCPlus4  = PC + 4
  //   PCTarget = PC + ImmExt (desplazamiento relativo al PC actual)
  //   PCSrc    = jal siempre salta; B-type salta si se cumple la condición
  //   PCSrc = 0 -> PC + 4, PCSrc = 1 -> PC + inmediato.
  // --------------------------------------------------------
  assign PCPlus4  = PC + 32'd4;
  assign PCTarget = PC + ImmExt;
  assign PCSrc    = Jump | BranchTaken;

  mux2to1 #(
      .WIDTH(32)
  ) mux_pcnext (
      .A     (PCPlus4),
      .B     (PCTarget),
      .Select(PCSrc),
      .Y     (PCNext)
  );

  program_counter pc_reg (
      .clk   (clk),
      .reset (reset),
      .PCNext(PCNext),
      .PC    (PC)
  );

  // --------------------------------------------------------
  // Memoria de instrucciones: entrega la instrucción en la
  // dirección PC
  // --------------------------------------------------------
  instruction_memory imem (
      .A (PC),
      .RD(Instr)
  );

  // --------------------------------------------------------
  // Unidad de control. Instrucciones
  //   Instr[6:0]   = opcode
  //   Instr[14:12] = funct3
  //   Instr[31:25] = funct7
  // --------------------------------------------------------
  control_unit cu (
      .opcode    (Instr[6:0]),
      .funct3    (Instr[14:12]),
      .funct7    (Instr[31:25]),
      .RegWrite  (RegWrite),
      .ALUSrc    (ALUSrc),
      .ALUControl(ALUControl),
      .ImmSrc    (ImmSrc),
      .MemWrite  (MemWrite),
      .ResultSrc (ResultSrc),
      .Branch    (Branch),
      .Jump      (Jump)
  );

  // --------------------------------------------------------
  // Banco de registros. Campos de la instrucción:
  //   Instr[19:15] = rs1
  //   Instr[24:20] = rs2
  //   Instr[11:7]  = rd
  // --------------------------------------------------------
  register_file rf (
      .clk     (clk),
      .A1      (Instr[19:15]),
      .A2      (Instr[24:20]),
      .A3      (Instr[11:7]),
      .WD3     (Result),
      .RegWrite(RegWrite),
      .RD1     (RD1),
      .RD2     (RD2)
  );

  // --------------------------------------------------------
  // Unidad de bifurcación: evalúa la condición de beq/blt/bge
  // comparando rs1 y rs2 según funct3 (blt/bge con signo).
  // Solo actúa si el control activa Branch.
  // --------------------------------------------------------
  branch_unit bu (
      .RD1        (RD1),
      .RD2        (RD2),
      .funct3     (Instr[14:12]),
      .Branch     (Branch),
      .BranchTaken(BranchTaken)
  );

  // --------------------------------------------------------
  // Generador de inmediatos
  // --------------------------------------------------------
  imm_gen immgen (
      .Instr (Instr),
      .ImmSrc(ImmSrc),
      .ImmExt(ImmExt)
  );

  // --------------------------------------------------------
  // MUX del 2do operando de la ALU:
  //   ALUSrc = 0 -> RD2 (registro), ALUSrc = 1 -> inmediato.
  // "#(.WIDTH(32))" configura el mux para datos de 32 bits.
  // --------------------------------------------------------
  mux2to1 #(
      .WIDTH(32)
  ) mux_alusrc (
      .A     (RD2),
      .B     (ImmExt),
      .Select(ALUSrc),
      .Y     (SrcB)
  );

  // --------------------------------------------------------
  // ALU
  // --------------------------------------------------------
  alu alu_inst (
      .A         (RD1),
      .B         (SrcB),
      .ALUControl(ALUControl),
      .Result    (ALUResult),
      .Zero      (Zero)
  );

  // --------------------------------------------------------
  // Memoria de datos:
  //   Dirección            = ALUResult (rs1 + imm)
  //   Dato a escribir (sw) = RD2 (valor de rs2)
  // --------------------------------------------------------
  data_memory dmem (
      .clk     (clk),
      .MemWrite(MemWrite),
      .A       (ALUResult),
      .WD      (RD2),
      .RD      (ReadData)
  );

  // --------------------------------------------------------
  // MUX del resultado final (dato a escribir en rd):
  //   ResultSrc = 00 -> ALUResult
  //   ResultSrc = 01 -> ReadData (lw)
  //   ResultSrc = 10 -> PCPlus4 (jal)
  // --------------------------------------------------------
  mux3to1 #(
      .WIDTH(32)
  ) mux_result (
      .A     (ALUResult),
      .B     (ReadData),
      .C     (PCPlus4),
      .Select(ResultSrc),
      .Y     (Result)
  );

endmodule