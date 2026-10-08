// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Testbench: ALU
//
// Descripción:
// Verifica el funcionamiento de la ALU para las operaciones
// aritméticas y lógicas definidas en la especificación.
//
// Autor / Verification Engineer:
// Nombre: ______________________________
// Fecha de primera versión: ____/____/______
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// ____/____/  | _________________  | Primera versión
//
// ============================================================

module alu_tb;

    // Señales del testbench
    logic [31:0] A;
    logic [31:0] B;
    logic [3:0]  ALUControl;

    logic [31:0] Result;
    logic        Zero;

    // Instancia del módulo bajo prueba
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin

        // ====================================================
        // TEST 1 - ADD
        // ====================================================
        A = 5;
        B = 3;
        ALUControl = 4'b0000;

        #10;

        // TODO: Verificar resultado

        // ====================================================
        // TEST 2 - SUB
        // ====================================================
        // TODO

        // ====================================================
        // TEST 3 - AND
        // ====================================================
        // TODO

        // ====================================================
        // TEST 4 - OR
        // ====================================================
        // TODO

        // TODO: Agregar pruebas adicionales según la especificación.

    end

endmodule
