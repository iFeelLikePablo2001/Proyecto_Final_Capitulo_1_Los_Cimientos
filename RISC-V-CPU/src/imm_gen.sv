// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros) 
//
// Módulo: Immediate Generator
//
// Descripción:
// Genera y extiende a 32 bits el valor inmediato contenido en
// una instrucción RISC-V. En esta etapa del proyecto se deben
// implementar los formatos de inmediato indicados en la
// especificación del Capítulo 1.
//
// Autor / Developer: Pablo Cabrera
// Nombre: ______________________________
// Fecha de primera versión: 20/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// ____/____/  | _________________  | Primera versión
// ____/____/  | _________________  | ________________________
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
    input  logic [1:0]  ImmSrc,
    output logic [31:0] ImmExt
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================


    always_comb begin
        case (ImmSrc)
            // I-type: imm[11:0] = Instr[31:20]
            2'b00:   ImmExt = {{20{Instr[31]}}, Instr[31:20]};
 
            // S-type: imm[11:5] = Instr[31:25], imm[4:0] = Instr[11:7]
            2'b01:   ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
 
            // Formatos no implementados en el Capítulo 1 (B, J, U)
            default: ImmExt = 32'b0;
        endcase
    end

endmodule
