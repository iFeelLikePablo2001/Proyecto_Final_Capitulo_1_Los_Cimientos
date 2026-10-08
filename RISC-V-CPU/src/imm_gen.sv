// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Módulo: Immediate Generator
//
// Descripción:
// Genera y extiende a 32 bits el valor inmediato contenido en
// una instrucción RISC-V. En esta etapa del proyecto se deben
// implementar los formatos de inmediato indicados en la
// especificación del Capítulo 1.
//
// Autor / Developer:
// Nombre: ______________________________
// Fecha de primera versión: ____/____/______
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

    // TODO: Implementar la generación del inmediato.

    // TODO: Implementar extensión de signo.

    // Capítulo 1: incluir como mínimo los formatos I y S.

endmodule
