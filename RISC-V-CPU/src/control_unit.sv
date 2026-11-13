// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Control Unit
//
// Descripción:
// Unidad de control principal del procesador. Recibe los campos
// opcode, funct3 y funct7 de la instrucción y genera las señales
// de control para el datapath. Incluye unicaente instrucciones
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
// ENTRADAS
// ------------------------------------------------------------
// opcode       : Instr[6:0]
// funct3       : Instr[14:12]
// funct7       : Instr[31:25]
//
// SALIDAS
// ------------------------------------------------------------
// RegWrite     : Habilita la escritura en el banco de registros.
// ALUSrc       : 0 = 2do operando de la ALU es RD2,
//                1 = 2do operando es el inmediato.
// ALUControl   : Operación de la ALU:
//                0000 ADD, 0001 SUB, 0010 AND, 0011 OR.
// ImmSrc       : Formato del inmediato: 00 = I-type, 01 = S-type.
// MemWrite     : Habilita la escritura en la memoria de datos.
// ResultSrc    : 0 = resultado de la ALU,
//                1 = dato leído de la memoria de datos.
// ============================================================

module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic       RegWrite,
    output logic       ALUSrc,
    output logic [3:0] ALUControl,
    output logic [1:0] ImmSrc,
    output logic       MemWrite,
    output logic       ResultSrc
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  // Opcodes

  localparam logic [6:0] OP_RTYPE = 7'b0110011;  // add, sub, and, or
  localparam logic [6:0] OP_ADDI = 7'b0010011;  // addi
  localparam logic [6:0] OP_LW = 7'b0000011;  // lw
  localparam logic [6:0] OP_SW = 7'b0100011;  // sw

  // Códigos internos de operaciones ALU
  localparam logic [3:0] ALU_ADD = 4'b0000;
  localparam logic [3:0] ALU_SUB = 4'b0001;
  localparam logic [3:0] ALU_AND = 4'b0010;
  localparam logic [3:0] ALU_OR = 4'b0011;

  // Primero se asigna un valor por defecto
  // si la instrucción no está soportada, no se escribe nada
  always_comb begin
    // Valores INIT (default)
    RegWrite   = 1'b0;
    ALUSrc     = 1'b0;
    ALUControl = ALU_ADD;
    ImmSrc     = 2'b00;
    MemWrite   = 1'b0;
    ResultSrc  = 1'b0;

    // "case" elige comportaminento según el opcode
    case (opcode)

      // R-type: add, sub, and, or 
      // ALUSrc = 0 y ResultSrc = 0 (valores por defecto): la ALU opera
      // rs1 con rs2 y se guarda el resultado de la ALU.
      // RegWrite solo se activa si funct3/funct7 forman una instrucción válida.
      OP_RTYPE: begin
        case (funct3)
          3'b000: begin  // add o sub según funct7
            if (funct7 == 7'b0000000) begin
              RegWrite   = 1'b1;
              ALUControl = ALU_ADD;
            end else if (funct7 == 7'b0100000) begin
              RegWrite   = 1'b1;
              ALUControl = ALU_SUB;
            end
          end
          3'b111: begin  // and
            if (funct7 == 7'b0000000) begin
              RegWrite   = 1'b1;
              ALUControl = ALU_AND;
            end
          end
          3'b110: begin  // or
            if (funct7 == 7'b0000000) begin
              RegWrite   = 1'b1;
              ALUControl = ALU_OR;
            end
          end
          default: ;  
        endcase
      end

      // I-type: addi
      OP_ADDI: begin
        if (funct3 == 3'b000) begin  // addi
          RegWrite   = 1'b1;
          ALUSrc     = 1'b1;  // 2do operando = inmediato
          ImmSrc     = 2'b00;
          ALUControl = ALU_ADD;  
        end
      end

      // lw rd, imm(rs1) 
      OP_LW: begin
        if (funct3 == 3'b010) begin  // lw 32 bits
          RegWrite   = 1'b1;
          ALUSrc     = 1'b1;  // dirección = rs1 + imm
          ImmSrc     = 2'b00; 
          ALUControl = ALU_ADD;
          ResultSrc  = 1'b1;  // se guarda el dato en memoria
        end
      end

      // sw rs2, imm(rs1) 
      OP_SW: begin
        if (funct3 == 3'b010) begin  // sw 32 bits
          MemWrite   = 1'b1;  // escribir en memoria
          ALUSrc     = 1'b1;  // dirección = rs1 + imm
          ImmSrc     = 2'b01; 
          ALUControl = ALU_ADD;
        end
      end

      // Cualquier otra instrucción
      default: ;  // se mantienen los valores por defecto

    endcase
  end

endmodule
