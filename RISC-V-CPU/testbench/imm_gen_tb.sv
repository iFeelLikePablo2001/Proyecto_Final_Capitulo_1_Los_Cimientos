// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Testbench: Immediate Generator
//
// Descripción:
// Verifica la generación y extensión de los valores inmediatos
// requeridos durante el Capítulo 1 del proyecto.
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

module imm_gen_tb;

    logic [31:0] Instr;
    logic [1:0]  ImmSrc;
    logic [31:0] ImmExt;

    imm_gen dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin

        // ====================================================
        // TEST 1 - Inmediato tipo I positivo
        // ====================================================
        // TODO: Construir una instrucción de prueba.
        // TODO: Seleccionar el ImmSrc correspondiente.
        // TODO: Verificar ImmExt.

        // ====================================================
        // TEST 2 - Inmediato tipo I negativo
        // ====================================================
        // TODO: Verificar extensión de signo.

        // ====================================================
        // TEST 3 - Inmediato tipo S positivo
        // ====================================================
        // TODO

        // ====================================================
        // TEST 4 - Inmediato tipo S negativo
        // ====================================================
        // TODO: Verificar extensión de signo.

        $finish;
    end

endmodule
