`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnivoros)
//
// Testbench: Data Memory
//
// Descripcion:
// Verifica la lectura y escritura de datos de 32 bits en
// memoria. Comprueba la inicializacion, escritura sincrona,
// conservacion de datos y funcionamiento de MemWrite,
// comparando resultados mediante indicadores PASS/FAIL.
//
// Autor / Developer:
// Nombre: Ivan Arce Quiros
// Fecha de primera version: 13/11/26
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripcion
// ------------------------------------------------------------
// 13/11/26    | Ivan Arce Quiros   | Primera version
// 15/11/26    | Ivan Arce Quiros   | Revision y validacion final
// ============================================================

module data_memory_tb;

    // Senales del testbench
    logic        clk;
    logic        MemWrite;
    logic [31:0] A;
    logic [31:0] WD;
    logic [31:0] RD;

    // Instancia del modulo bajo prueba
    data_memory #(
        .DEPTH(64)
    ) dut (
        .clk(clk),
        .MemWrite(MemWrite),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    // Generacion de reloj
    initial clk = 0;
    always #5 clk = ~clk;

    // Contadores de pruebas
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // Tarea de verificacion automatica
    task automatic check(
        input string       id,
        input logic [31:0] exp_rd
    );
        begin
            total_tests = total_tests + 1;

            if (RD === exp_rd) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            // Entradas
            $display("  ENTRADAS:");

            $display("    MemWrite=%b", MemWrite);

            $display("    A: DEC=%0d | HEX=0x%08h",
                     $signed(A), A);
            $display("       BIN=%032b", A);

            $display("    WD: DEC=%0d | HEX=0x%08h",
                     $signed(WD), WD);
            $display("        BIN=%032b", WD);

            // Resultado esperado
            $display("  RESULTADO ESPERADO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(exp_rd), exp_rd);
            $display("    BIN=%032b", exp_rd);

            // Resultado obtenido
            $display("  RESULTADO OBTENIDO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(RD), RD);
            $display("    BIN=%032b", RD);

            $display("----------------------------------------");
        end
    endtask

    // Ejecucion de pruebas
    initial begin

        // Inicializacion
        MemWrite = 0;
        A = 0;
        WD = 0;

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // TEST 1 - Memoria inicializada en cero
        #1;

        check("DM-01 Memoria inicializada",
              32'h00000000);

        // TEST 2 - Escritura y lectura en direccion 0
        @(negedge clk);
        A = 32'd0;
        WD = 32'h12345678;
        MemWrite = 1;

        @(posedge clk);
        #1;
        MemWrite = 0;

        check("DM-02 Escritura direccion 0",
              32'h12345678);

        // TEST 3 - Escritura y lectura en direccion 4
        @(negedge clk);
        A = 32'd4;
        WD = 32'hABCDEF00;
        MemWrite = 1;

        @(posedge clk);
        #1;
        MemWrite = 0;

        check("DM-03 Escritura direccion 4",
              32'hABCDEF00);

        // TEST 4 - Lectura de un dato anterior
        A = 32'd0;
        #1;

        check("DM-04 Conservacion direccion 0",
              32'h12345678);

        // TEST 5 - Escritura deshabilitada
        @(negedge clk);
        A = 32'd0;
        WD = 32'hDEADBEEF;
        MemWrite = 0;

        @(posedge clk);
        #1;

        check("DM-05 MemWrite=0 (sin cambios)",
              32'h12345678);

        // TEST 6 - Sin escritura antes del flanco positivo
        @(negedge clk);
        A = 32'd252;
        WD = 32'hFFFFFFFF;
        MemWrite = 1;

        #1;

        check("DM-06 Antes del flanco positivo",
              32'h00000000);

        // TEST 7 - Escritura despues del flanco positivo
        @(posedge clk);
        #1;
        MemWrite = 0;

        check("DM-07 Despues del flanco positivo",
              32'hFFFFFFFF);

        // TEST 8 - Lectura de posicion no modificada
        A = 32'd8;
        #1;

        check("DM-08 Posicion sin modificar",
              32'h00000000);

        // Resumen final
        $display("");
        $display("========== RESUMEN DATA MEMORY ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("=========================================");
            $fatal(1, "Verificacion Data Memory fallida: %0d pruebas.",
                   failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("=========================================");
            $finish;
        end

    end

endmodule
