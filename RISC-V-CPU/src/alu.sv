// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Módulo: ALU
//
// Descripción:
// Implementa las operaciones aritméticas y lógicas requeridas
// por el procesador RISC-V.
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
// A            : Operando de 32 bits.
// B            : Operando de 32 bits.
// ALUControl   : Código que determina la operación.
//
// SALIDAS
// ------------------------------------------------------------
// Result       : Resultado de la operación.
// Zero         : 1 cuando Result es igual a cero.
// ============================================================

module alu (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUControl,
    output logic [31:0] Result,
    output logic        Zero
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // TODO: Implementar ALU

endmodule
