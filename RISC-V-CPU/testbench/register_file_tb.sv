
`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: Ohminivoros 
//
// Testbench: Register File
//
// Descripcion:
// Implementa el banco de 32 registros de 32 bits del procesador.
// Permite leer dos registros simultáneamente y escribir un
// registro cuando la señal RegWrite está habilitada.
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
// ============================================================

module register_file_tb;

    // Senales del testbench
    logic        clk;
    logic [4:0]  A1;
    logic [4:0]  A2;
    logic [4:0]  A3;
    logic [31:0] WD3;
    logic        RegWrite;
    logic [31:0] RD1;
    logic [31:0] RD2;

    // Instancias
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

    // Generacion de reloj
    initial clk = 0;
    always #5 clk = ~clk;

    // Contadores de pruebas
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // Verificacion automatica

    task automatic check(
        input string       id,
        input logic [31:0] exp_rd1,
        input logic [31:0] exp_rd2
    );
        begin
            total_tests = total_tests + 1;

            // Comparacion de ambos puertos de lectura
            if (RD1 === exp_rd1 && RD2 === exp_rd2) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            // Direcciones de lectura
            $display("  ENTRADAS:");
            $display("    A1=x%0d | A2=x%0d", A1, A2);

            // Resultado esperado
            $display("  RESULTADO ESPERADO:");

            $display("    RD1: DEC=%0d | HEX=0x%08h",
                     $signed(exp_rd1), exp_rd1);
            $display("         BIN=%032b", exp_rd1);

            $display("    RD2: DEC=%0d | HEX=0x%08h",
                     $signed(exp_rd2), exp_rd2);
            $display("         BIN=%032b", exp_rd2);

            // Resultado obtenido
            $display("  RESULTADO OBTENIDO:");

            $display("    RD1: DEC=%0d | HEX=0x%08h",
                     $signed(RD1), RD1);
            $display("         BIN=%032b", RD1);

            $display("    RD2: DEC=%0d | HEX=0x%08h",
                     $signed(RD2), RD2);
            $display("         BIN=%032b", RD2);

            $display("----------------------------------------");

        end
    endtask

    // Ejecucion de pruebas

    initial begin

        // Inicializacion
        RegWrite = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // ====================================================
        // TEST 1 - Escritura y lectura de un registro
        // ====================================================

        @(negedge clk);
        A3 = 5;
        WD3 = 25;
        RegWrite = 1;

        @(posedge clk);
        #1;
        RegWrite = 0;

        A1 = 5;
        A2 = 0;
        #1;

        check("RF-01 Escritura y lectura x5=25",
              32'd25, 32'd0);

        // ====================================================
        // TEST 2 - Lectura simultanea
        // ====================================================

        @(negedge clk);
        A3 = 6;
        WD3 = 42;
        RegWrite = 1;

        @(posedge clk);
        #1;
        RegWrite = 0;

        A1 = 5;
        A2 = 6;
        #1;

        check("RF-02 Lectura simultanea x5 y x6",
              32'd25, 32'd42);

        // ====================================================
        // TEST 3 - Registro x0
        // ====================================================

        @(negedge clk);
        A3 = 0;
        WD3 = 100;
        RegWrite = 1;

        @(posedge clk);
        #1;
        RegWrite = 0;

        A1 = 0;
        A2 = 5;
        #1;

        check("RF-03 Proteccion del registro x0",
              32'd0, 32'd25);

        // ====================================================
        // TEST 4 - RegWrite deshabilitado
        // ====================================================

        @(negedge clk);
        A3 = 5;
        WD3 = 999;
        RegWrite = 0;

        @(posedge clk);
        #1;

        A1 = 5;
        A2 = 6;
        #1;

        check("RF-04 RegWrite=0 (x5 sin cambios)",
              32'd25, 32'd42);

        // ====================================================
        // Resumen final
        // ====================================================

        $display("");
        $display("========== RESUMEN REGISTER FILE ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("===========================================");
            $fatal(1, "Verificacion Register File fallida: %0d pruebas.",
                   failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("===========================================");
            $finish;
        end

    end

endmodule
