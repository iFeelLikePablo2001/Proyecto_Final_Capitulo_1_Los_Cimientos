// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Testbench: Register File
//
// Descripción:
// Verifica las operaciones de lectura y escritura del banco de
// registros, incluyendo el comportamiento especial de x0.
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

module register_file_tb;

    logic        clk;
    logic [4:0]  A1;
    logic [4:0]  A2;
    logic [4:0]  A3;
    logic [31:0] WD3;
    logic        RegWrite;
    logic [31:0] RD1;
    logic [31:0] RD2;

    register_file dut (
        .clk(clk),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RegWrite(RegWrite),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Generación de reloj
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

        // Inicialización
        RegWrite = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        // ====================================================
        // TEST 1 - Escritura y lectura de un registro
        // ====================================================
        // TODO: Escribir un valor en un registro diferente de x0.
        // TODO: Leer el registro y verificar el resultado.

        // ====================================================
        // TEST 2 - Lectura simultánea
        // ====================================================
        // TODO: Verificar los dos puertos de lectura.

        // ====================================================
        // TEST 3 - Registro x0
        // ====================================================
        // TODO: Intentar escribir en x0.
        // TODO: Verificar que x0 continúe almacenando cero.

        // ====================================================
        // TEST 4 - RegWrite deshabilitado
        // ====================================================
        // TODO: Verificar que no exista escritura cuando
        // RegWrite = 0.

        $finish;
    end

endmodule
