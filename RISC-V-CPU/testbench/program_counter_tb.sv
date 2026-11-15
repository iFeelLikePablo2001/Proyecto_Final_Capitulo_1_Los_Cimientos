`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnivoros)
//
// Testbench: Program Counter
//
// Descripcion:
// Verifica el reinicio sincrono del Program Counter y la
// actualizacion de su valor en el flanco positivo del reloj.
// Comprueba los resultados esperados y obtenidos mediante
// pruebas automaticas con indicadores PASS/FAIL.
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

module program_counter_tb;

    // Senales del testbench
    logic        clk;
    logic        reset;
    logic [31:0] PCNext;
    logic [31:0] PC;

    // Instancia del modulo bajo prueba
    program_counter dut (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
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
        input logic [31:0] exp_pc
    );
        begin
            total_tests = total_tests + 1;

            if (PC === exp_pc) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            $display("  ENTRADAS:");
            $display("    reset=%b", reset);
            $display("    PCNext: DEC=%0d | HEX=0x%08h",
                     $signed(PCNext), PCNext);
            $display("            BIN=%032b", PCNext);

            $display("  RESULTADO ESPERADO:");
            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(exp_pc), exp_pc);
            $display("    BIN=%032b", exp_pc);

            $display("  RESULTADO OBTENIDO:");
            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(PC), PC);
            $display("    BIN=%032b", PC);

            $display("----------------------------------------");
        end
    endtask

    // Ejecucion de pruebas
    initial begin

        reset = 1;
        PCNext = 32'h00000100;

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // TEST 1 - Reset sincrono activo en alto
        @(posedge clk);
        #1;
        check("PC-01 Reset inicial", 32'h00000000);

        // TEST 2 - Carga de PCNext = 4
        @(negedge clk);
        reset = 0;
        PCNext = 32'h00000004;

        @(posedge clk);
        #1;
        check("PC-02 Carga PC=4", 32'h00000004);

        // TEST 3 - Carga de PCNext = 8
        @(negedge clk);
        PCNext = 32'h00000008;

        @(posedge clk);
        #1;
        check("PC-03 Carga PC=8", 32'h00000008);

        // TEST 4 - Reset no cambia PC antes del flanco
        @(negedge clk);
        reset = 1;
        PCNext = 32'h00000100;

        #1;
        check("PC-04 Reset antes del flanco",
              32'h00000008);

        // TEST 5 - Reset se aplica en flanco positivo
        @(posedge clk);
        #1;
        check("PC-05 Reset en flanco positivo",
              32'h00000000);

        // TEST 6 - Nueva carga despues del reset
        @(negedge clk);
        reset = 0;
        PCNext = 32'h000000A0;

        @(posedge clk);
        #1;
        check("PC-06 Carga despues del reset",
              32'h000000A0);

        // Resumen final
        $display("");
        $display("========== RESUMEN PROGRAM COUNTER ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("============================================");
            $fatal(1, "Verificacion PC fallida: %0d pruebas.",
                   failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("============================================");
            $finish;
        end

    end

endmodule
