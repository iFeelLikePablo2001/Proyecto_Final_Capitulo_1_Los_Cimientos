`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnivoros)
//
// Testbench: Instruction Memory
//
// Descripcion:
// Verifica la inicializacion y lectura de instrucciones
// de 32 bits almacenadas en la memoria. Comprueba distintas
// direcciones, instrucciones precargadas y posiciones con NOP,
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

module instruction_memory_tb;

    // Senales del testbench
    logic [31:0] A;
    logic [31:0] RD;

    // Instancia del modulo bajo prueba
    instruction_memory #(
        .DEPTH(64),
        .INIT_FILE("")
    ) dut (
        .A(A),
        .RD(RD)
    );

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

            $display("  ENTRADA:");

            $display("    A: DEC=%0d | HEX=0x%08h",
                     $signed(A), A);
            $display("       BIN=%032b", A);

            $display("  RESULTADO ESPERADO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(exp_rd), exp_rd);
            $display("    BIN=%032b", exp_rd);

            $display("  RESULTADO OBTENIDO:");

            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(RD), RD);
            $display("    BIN=%032b", RD);

            $display("----------------------------------------");
        end
    endtask

    // Ejecucion de pruebas
    initial begin

        A = 32'd0;

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // TEST 1 - Inicializacion con NOP
        #1;
        check("IM-01 Inicializacion NOP",
              32'h00000013);

        // Precarga de instrucciones para la simulacion
        // addi x1, x0, 10
        dut.mem[0]  = 32'h00A00093;

        // addi x2, x0, 20
        dut.mem[1]  = 32'h01400113;

        // add x3, x1, x2
        dut.mem[2]  = 32'h002081B3;

        // addi x5, x0, 5
        dut.mem[63] = 32'h00500293;

        // TEST 2 - Primera instruccion
        A = 32'd0;
        #1;
        check("IM-02 Lectura direccion 0",
              32'h00A00093);

        // TEST 3 - Segunda instruccion
        A = 32'd4;
        #1;
        check("IM-03 Lectura direccion 4",
              32'h01400113);

        // TEST 4 - Tercera instruccion
        A = 32'd8;
        #1;
        check("IM-04 Lectura direccion 8",
              32'h002081B3);

        // TEST 5 - Ultima posicion de memoria
        A = 32'd252;
        #1;
        check("IM-05 Lectura ultima posicion",
              32'h00500293);

        // TEST 6 - Posicion no modificada
        A = 32'd12;
        #1;
        check("IM-06 Posicion con NOP",
              32'h00000013);

        // Resumen final
        $display("");
        $display("========== RESUMEN INSTRUCTION MEMORY ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("================================================");
            $fatal(1, "Verificacion Instruction Memory fallida: %0d pruebas.",
                   failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("================================================");
            $finish;
        end

    end

endmodule
