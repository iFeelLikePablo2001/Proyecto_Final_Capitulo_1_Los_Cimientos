
`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Ohminivoros 
//
// Testbench: Multiplexor 2 a 1
//
// Descripcion:
// Implementa un multiplexor 2 a 1 parametrizable que permite
// seleccionar una de dos entradas de datos.
//
// Autor / Developer:
// Nombre: Ivan Arce Quiros
// Fecha de primera versión: 22/10/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 22/10/26  | Ivan Arce Quiros  | Primera versión
// 25/10/26  | Ivan Arce Quiros  | Ultima versión
//
// ============================================================

module mux_tb;

    // Senales del testbench
    logic [31:0] A;
    logic [31:0] B;
    logic        Select;
    logic [31:0] Y;

    // Instancias
    mux2to1 #(.WIDTH(32)) dut (
        .A(A),
        .B(B),
        .Select(Select),
        .Y(Y)
    );

    // Contadores de pruebas
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // Verificacion automatica

    task automatic check(
        input string       id,
        input logic [31:0] exp_y
    );
        begin
            total_tests = total_tests + 1;

            // Comparacion del resultado
            if (Y === exp_y) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            // Entradas 
            $display("  ENTRADAS:");

            $display("    A: DEC=%0d | HEX=0x%08h",
                     $signed(A), A);
            $display("       BIN=%032b", A);

            $display("    B: DEC=%0d | HEX=0x%08h",
                     $signed(B), B);
            $display("       BIN=%032b", B);

            $display("    Select=%b", Select);

            // Resultado esperado
            $display("  RESULTADO ESPERADO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(exp_y), exp_y);

            $display("    BIN=%032b", exp_y);

            // Resultado obtenido
            $display("  RESULTADO OBTENIDO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(Y), Y);

            $display("    BIN=%032b", Y);

            $display("----------------------------------------");

        end
    endtask

    // Ejecucion de pruebas

    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // Valores iniciales
        A = 32'h12345678;
        B = 32'hABCDEF00;

        // TEST 1 - Select = 0
        Select = 0;
        #10;
        check("MUX-01 Select=0 (Entrada A)", 32'h12345678);

        // TEST 2 - Select = 1
        Select = 1;
        #10;
        check("MUX-02 Select=1 (Entrada B)", 32'hABCDEF00);

        // Nuevos valores de entrada
        A = 32'h11111111;
        B = 32'hAAAAAAAA;

        // TEST 3 - Select = 0
        Select = 0;
        #10;
        check("MUX-03 Select=0 (Entrada A)", 32'h11111111);

        // TEST 4 - Select = 1
        Select = 1;
        #10;
        check("MUX-04 Select=1 (Entrada B)", 32'hAAAAAAAA);

        // Valores extremos
        A = 32'h00000000;
        B = 32'hFFFFFFFF;

        // TEST 5 - Seleccion de entrada cero
        Select = 0;
        #10;
        check("MUX-05 Select=0 (Todos ceros)", 32'h00000000);

        // TEST 6 - Seleccion de entrada maxima
        Select = 1;
        #10;
        check("MUX-06 Select=1 (Todos unos)", 32'hFFFFFFFF);

        // Resumen final

        $display("");
        $display("========== RESUMEN MUX ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("=================================");
            $fatal(1, "Verificacion MUX fallida: %0d pruebas.", failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("=================================");
            $finish;
        end

    end

endmodule
