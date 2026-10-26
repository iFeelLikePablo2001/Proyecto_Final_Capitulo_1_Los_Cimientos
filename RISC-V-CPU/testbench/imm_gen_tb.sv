
`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Testbench: Immediate Generator
//
// Descripcion:
// Verifica la generacion y extension de los valores inmediatos
// requeridos durante el Capitulo 1 del proyecto.
//
// Autor / Verification Engineer:
// Nombre: ______________________________
// Fecha de primera version: ____/____/______
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripcion
// ------------------------------------------------------------
// ____/____/  | _________________  | Primera version
//
// ============================================================

module imm_gen_tb;

    // Senales del testbench
    logic [31:0] Instr;
    logic [1:0]  ImmSrc;
    logic [31:0] ImmExt;

    // Instancia del modulo bajo prueba
    imm_gen dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
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
        input logic [31:0] exp_imm
    );
        begin
            total_tests = total_tests + 1;

            // Comparacion del inmediato extendido
            if (ImmExt === exp_imm) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            // Entradas en tres formatos
            $display("  ENTRADAS:");

            $display("    Instr: DEC=%0d | HEX=0x%08h",
                     $signed(Instr), Instr);
            $display("           BIN=%032b", Instr);

            $display("    ImmSrc=%02b", ImmSrc);

            // Resultado esperado
            $display("  RESULTADO ESPERADO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(exp_imm), exp_imm);

            $display("    BIN=%032b", exp_imm);

            // Resultado obtenido
            $display("  RESULTADO OBTENIDO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(ImmExt), ImmExt);

            $display("    BIN=%032b", ImmExt);

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

        // ====================================================
        // TEST 1 - Inmediato I-type positivo (+100)
        // ADDI x5, x6, 100
        // ====================================================

        Instr  = 32'h06430293;
        ImmSrc = 2'b00;
        #10;
        check("IMM-01 I-type positivo (+100)", 32'd100);

        // ====================================================
        // TEST 2 - Inmediato I-type negativo (-20)
        // ADDI x5, x6, -20
        // ====================================================

        Instr  = 32'hFEC30293;
        ImmSrc = 2'b00;
        #10;
        check("IMM-02 I-type negativo (-20)", -32'sd20);

        // ====================================================
        // TEST 3 - Inmediato S-type positivo (+100)
        // SW x7, 100(x6)
        // ====================================================

        Instr  = 32'h06732223;
        ImmSrc = 2'b01;
        #10;
        check("IMM-03 S-type positivo (+100)", 32'd100);

        // ====================================================
        // TEST 4 - Inmediato S-type negativo (-20)
        // SW x7, -20(x6)
        // ====================================================

        Instr  = 32'hFE732623;
        ImmSrc = 2'b01;
        #10;
        check("IMM-04 S-type negativo (-20)", -32'sd20);

        // ====================================================
        // TEST 5 - Maximo positivo I-type (+2047)
        // ADDI x5, x6, 2047
        // ====================================================

        Instr  = 32'h7FF30293;
        ImmSrc = 2'b00;
        #10;
        check("IMM-05 I-type maximo (+2047)", 32'd2047);

        // ====================================================
        // TEST 6 - Minimo negativo I-type (-2048)
        // ADDI x5, x6, -2048
        // ====================================================

        Instr  = 32'h80030293;
        ImmSrc = 2'b00;
        #10;
        check("IMM-06 I-type minimo (-2048)", -32'sd2048);

        // ====================================================
        // TEST 7 - Maximo positivo S-type (+2047)
        // SW x7, 2047(x6)
        // ====================================================

        Instr  = 32'h7E732FA3;
        ImmSrc = 2'b01;
        #10;
        check("IMM-07 S-type maximo (+2047)", 32'd2047);

        // ====================================================
        // TEST 8 - Minimo negativo S-type (-2048)
        // SW x7, -2048(x6)
        // ====================================================

        Instr  = 32'h80732023;
        ImmSrc = 2'b01;
        #10;
        check("IMM-08 S-type minimo (-2048)", -32'sd2048);

        // ====================================================
        // Resumen final
        // ====================================================

        $display("");
        $display("========== RESUMEN IMM GEN ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("=================================");
            $fatal(1, "Verificacion IMM GEN fallida: %0d pruebas.", failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("=================================");
            $finish;
        end

    end

endmodule
