// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Immediate Generator
//
// Descripción:
// Genera y extiende a 32 bits el valor inmediato contenido en
// una instrucción RISC-V. Soporta instrucciones tipo I, S, B y J.
//
// Autor / Developer: Pablo Cabrera
// Nombre: imm_gen.sv
// Fecha de primera versión: 20/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 20/10/2026  | Pablo Cabrera      | Primera versión
// 23/11/2026  | Julián Murillo     | Implementación de imm_gen para instrucciones B y J
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// Instr        : Instrucción RISC-V de 32 bits.
// ImmSrc       : Selecciona el formato del inmediato.
//
// SALIDAS
// ------------------------------------------------------------
// ImmExt       : Inmediato extendido a 32 bits.
// ============================================================

module imm_gen (
    input  logic [31:0] Instr,
    input  logic [ 1:0] ImmSrc,
    output logic [31:0] ImmExt
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================


  always_comb begin
    case (ImmSrc)
      // I-type: imm[11:0] = Instr[31:20]
      2'b00: ImmExt = {{20{Instr[31]}}, Instr[31:20]};

      // S-type: imm[11:5] = Instr[31:25], imm[4:0] = Instr[11:7]
      2'b01: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};

      // B-type: imm[12|10:5] = Instr[31:25], imm[4:1|11] = Instr[11:7]
      2'b10: ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};

      // J-type: imm[20|10:1|11|19:12] = Instr[31:12]
      2'b11: ImmExt = {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0};

      // Formatos no implementados 
      default: ImmExt = 32'b0;
    endcase
  end

endmodule
