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
// instruccion por ciclo de reloj. Sopoporta instrucciones
// tipo R, I y S. 
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
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// PARÁMETROS
// ------------------------------------------------------------
// INIT_FILE    : Archivo .hex con el para cargar instruction_memory.
//                Si es "", la memoria se llena con 0.
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

module processor #(
    parameter string INIT_FILE = ""
) (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] PC,
    output logic [31:0] Instr
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  // Señales internas
  logic [31:0] PCNext;  
  logic [31:0] RD1, RD2;  // datos leídos de rs1 y rs2
  logic [31:0] ImmExt;  // inmediato extendido a 32 bits
  logic [31:0] SrcB;  // selección del 2do operando de la ALU 
  logic [31:0] ALUResult;  // resultado
  logic [31:0] ReadData;  // dato de la memoria de datos
  logic [31:0] Result;  // dato a escribir en rd
  logic        Zero;  // saltos de la ALU (beq, bne, etc.)

  // Señales de control de control_unit
  logic        RegWrite, ALUSrc, MemWrite, ResultSrc;
  logic [1:0] ImmSrc;
  logic [3:0] ALUControl;

  // --------------------------------------------------------
  // Program Counter: sin saltos + 4 bytes
  // --------------------------------------------------------
  assign PCNext = PC + 32'd4;

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
  instruction_memory #(
      .INIT_FILE(INIT_FILE)
  ) imem (
      .A (PC),
      .RD(Instr)
  );

  // --------------------------------------------------------
  // Unidad de control. Instrucciones
  //   Instr[6:0]   = opcode
  //   Instr[14:12] = funct3
  //   Instr[31:25] = funct7
  // --------------------------------------------------------
  control_unit cu (S
      .opcode    (Instr[6:0]),
      .funct3    (Instr[14:12]),
      .funct7    (Instr[31:25]),
      .RegWrite  (RegWrite),
      .ALUSrc    (ALUSrc),
      .ALUControl(ALUControl),
      .ImmSrc    (ImmSrc),
      .MemWrite  (MemWrite),
      .ResultSrc (ResultSrc)
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
  // MUX del resultado final:
  //   ResultSrc = 0 -> ALUResult, ResultSrc = 1 -> ReadData.
  // --------------------------------------------------------
  mux2to1 #(
      .WIDTH(32)
  ) mux_result (
      .A     (ALUResult),
      .B     (ReadData),
      .Select(ResultSrc),
      .Y     (Result)
  );

endmodule
