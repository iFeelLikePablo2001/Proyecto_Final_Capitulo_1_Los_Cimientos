`timescale 1ns/1ps

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

    // Instancia del modulo bajo prueba
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    // Contadores de pruebas
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // ========================================================
    // Tarea de verificacion automatica
    // ========================================================

    task automatic check(
        input string       id,
        input logic [31:0] exp_result,
        input logic        exp_zero
    );
        begin
            total_tests = total_tests + 1;

            // Comparacion de resultado y Zero
            if (Result === exp_result && Zero === exp_zero) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            // Entradas en tres formatos
            $display("  ENTRADAS:");

            $display("    A: DEC=%0d | HEX=0x%08h",
                     $signed(A), A);
            $display("       BIN=%032b", A);

            $display("    B: DEC=%0d | HEX=0x%08h",
                     $signed(B), B);
            $display("       BIN=%032b", B);

            // Resultado esperado
            $display("  RESULTADO ESPERADO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(exp_result), exp_result);

            $display("    BIN=%032b | Zero=%b",
                     exp_result, exp_zero);

            // Resultado obtenido
            $display("  RESULTADO OBTENIDO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(Result), Result);

            $display("    BIN=%032b | Zero=%b",
                     Result, Zero);

            $display("----------------------------------------");

        end
    endtask

    // ========================================================
    // Ejecucion de pruebas
    // ========================================================

    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // TEST 1 - ADD
        A = 5;
        B = 3;
        ALUControl = 4'b0000;
        #10;
        check("ALU-01 ADD 5+3", 32'd8, 1'b0);

        // TEST 2 - SUB
        A = 5;
        B = 3;
        ALUControl = 4'b0001;
        #10;
        check("ALU-02 SUB 5-3", 32'd2, 1'b0);

        // TEST 3 - AND
        A = 32'hF0F0F0F0;
        B = 32'h0FF00FF0;
        ALUControl = 4'b0010;
        #10;
        check("ALU-03 AND", 32'h00F000F0, 1'b0);

        // TEST 4 - OR
        A = 32'hF0F0F0F0;
        B = 32'h0FF00FF0;
        ALUControl = 4'b0011;
        #10;
        check("ALU-04 OR", 32'hFFF0FFF0, 1'b0);

        // TEST 5 - Resultado cero
        A = 5;
        B = 5;
        ALUControl = 4'b0001;
        #10;
        check("ALU-05 SUB 5-5 (Zero=1)", 32'd0, 1'b1);

        // TEST 6 - Resultado negativo
        A = 3;
        B = 5;
        ALUControl = 4'b0001;
        #10;
        check("ALU-06 SUB 3-5 (negativo)", -32'sd2, 1'b0);

        // TEST 7 - Desbordamiento ADD
        A = 32'hFFFFFFFF;
        B = 32'd1;
        ALUControl = 4'b0000;
        #10;
        check("ALU-07 ADD overflow (Zero=1)", 32'd0, 1'b1);

        // TEST 8 - AND con resultado cero
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        ALUControl = 4'b0010;
        #10;
        check("ALU-08 AND disjunto (Zero=1)", 32'd0, 1'b1);

        // ====================================================
        // Resumen final
        // ====================================================

        $display("");
        $display("========== RESUMEN ALU ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("=================================");
            $fatal(1, "Verificacion ALU fallida: %0d pruebas.", failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("=================================");
            $finish;
        end

    end

endmodule
