// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Testbench: Multiplexor 2 a 1
//
// Descripción:
// Verifica que el multiplexor seleccione correctamente cada
// una de sus entradas según la señal Select.
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

module mux_tb;

    logic [31:0] A;
    logic [31:0] B;
    logic        Select;
    logic [31:0] Y;

    mux2to1 #(.WIDTH(32)) dut (
        .A(A),
        .B(B),
        .Select(Select),
        .Y(Y)
    );

    initial begin

        A = 32'h12345678;
        B = 32'hABCDEF00;

        // ====================================================
        // TEST 1 - Select = 0
        // ====================================================
        Select = 0;
        #10;
        // TODO: Verificar que Y corresponda a la entrada A.

        // ====================================================
        // TEST 2 - Select = 1
        // ====================================================
        // TODO: Seleccionar B y verificar el resultado.

        // ====================================================
        // TEST 3 - Prueba adicional
        // ====================================================
        // TODO: Definir nuevos valores y comprobar ambos casos.

        $finish;
    end

endmodule
