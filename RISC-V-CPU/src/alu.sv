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


    // Códigos internos de operación (según especificación 4.1)
    localparam logic [3:0] ALU_ADD = 4'b0000;
    localparam logic [3:0] ALU_SUB = 4'b0001;
    localparam logic [3:0] ALU_AND = 4'b0010;
    localparam logic [3:0] ALU_OR  = 4'b0011;
 
    // Selección de la operación (lógica puramente combinacional)
    always_comb begin
        case (ALUControl)
            ALU_ADD: Result = A + B;
            ALU_SUB: Result = A - B;
            ALU_AND: Result = A & B;
            ALU_OR:  Result = A | B;
            default: Result = 32'b0;  // Código no definido: evita latches
        endcase
    end
 
    // Zero depende del resultado final, sin importar la operación
    assign Zero = (Result == 32'b0);
 
endmodule
