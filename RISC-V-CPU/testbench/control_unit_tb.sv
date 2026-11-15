`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnivoros)
//
// Testbench: Control Unit
//
// Descripcion:
// Verifica la decodificacion de las instrucciones RISC-V
// y la generacion de sus respectivas senales de control.
// Comprueba las siete instrucciones requeridas y casos
// no soportados mediante indicadores automaticos PASS/FAIL.
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

module control_unit_tb;

    // Entradas
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // Salidas
    logic       RegWrite;
    logic       ALUSrc;
    logic [3:0] ALUControl;
    logic [1:0] ImmSrc;
    logic       MemWrite;
    logic       ResultSrc;

    // Instancia del modulo bajo prueba
    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc)
    );

    // Contadores de pruebas
    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    // Tarea de verificacion automatica
    task automatic check(
        input string       id,
        input logic        exp_RegWrite,
        input logic        exp_ALUSrc,
        input logic [3:0]  exp_ALUControl,
        input logic [1:0]  exp_ImmSrc,
        input logic        exp_MemWrite,
        input logic        exp_ResultSrc
    );
        begin
            total_tests = total_tests + 1;

            if (
                RegWrite   === exp_RegWrite   &&
                ALUSrc     === exp_ALUSrc     &&
                ALUControl === exp_ALUControl &&
                ImmSrc     === exp_ImmSrc     &&
                MemWrite   === exp_MemWrite   &&
                ResultSrc  === exp_ResultSrc
            ) begin
                passed_tests = passed_tests + 1;
                $display("[PASS] %s", id);
            end
            else begin
                failed_tests = failed_tests + 1;
                $display("[FAIL] %s", id);
            end

            $display("  ENTRADAS:");
            $display("    opcode: BIN=%07b | HEX=0x%02h",
                     opcode, opcode);
            $display("    funct3: BIN=%03b", funct3);
            $display("    funct7: BIN=%07b", funct7);

            $display("  RESULTADO ESPERADO:");
            $display("    RegWrite=%b | ALUSrc=%b",
                     exp_RegWrite, exp_ALUSrc);
            $display("    ALUControl=%04b | ImmSrc=%02b",
                     exp_ALUControl, exp_ImmSrc);
            $display("    MemWrite=%b | ResultSrc=%b",
                     exp_MemWrite, exp_ResultSrc);

            $display("  RESULTADO OBTENIDO:");
            $display("    RegWrite=%b | ALUSrc=%b",
                     RegWrite, ALUSrc);
            $display("    ALUControl=%04b | ImmSrc=%02b",
                     ALUControl, ImmSrc);
            $display("    MemWrite=%b | ResultSrc=%b",
                     MemWrite, ResultSrc);

            $display("----------------------------------------");
        end
    endtask

    // Ejecucion de pruebas
    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        // TEST 1 - ADD
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        check("CU-01 ADD",
              1'b1, 1'b0, 4'b0000,
              2'b00, 1'b0, 1'b0);

        // TEST 2 - SUB
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        #10;
        check("CU-02 SUB",
              1'b1, 1'b0, 4'b0001,
              2'b00, 1'b0, 1'b0);

        // TEST 3 - AND
        opcode = 7'b0110011;
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        #10;
        check("CU-03 AND",
              1'b1, 1'b0, 4'b0010,
              2'b00, 1'b0, 1'b0);

        // TEST 4 - OR
        opcode = 7'b0110011;
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        #10;
        check("CU-04 OR",
              1'b1, 1'b0, 4'b0011,
              2'b00, 1'b0, 1'b0);

        // TEST 5 - ADDI
        opcode = 7'b0010011;
        funct3 = 3'b000;
        funct7 = 7'b1111111;
        #10;
        check("CU-05 ADDI",
              1'b1, 1'b1, 4'b0000,
              2'b00, 1'b0, 1'b0);

        // TEST 6 - LW
        opcode = 7'b0000011;
        funct3 = 3'b010;
        funct7 = 7'b0000000;
        #10;
        check("CU-06 LW",
              1'b1, 1'b1, 4'b0000,
              2'b00, 1'b0, 1'b1);

        // TEST 7 - SW
        opcode = 7'b0100011;
        funct3 = 3'b010;
        funct7 = 7'b1111111;
        #10;
        check("CU-07 SW",
              1'b0, 1'b1, 4'b0000,
              2'b01, 1'b1, 1'b0);

        // TEST 8 - Opcode no soportado
        opcode = 7'b1111111;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        check("CU-08 Opcode no soportado",
              1'b0, 1'b0, 4'b0000,
              2'b00, 1'b0, 1'b0);

        // TEST 9 - R-type con funct7 invalido
        opcode = 7'b0110011;
        funct3 = 3'b000;
        funct7 = 7'b0000001;
        #10;
        check("CU-09 R-type no soportado",
              1'b0, 1'b0, 4'b0000,
              2'b00, 1'b0, 1'b0);

        // TEST 10 - Load con funct3 no soportado
        opcode = 7'b0000011;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;
        check("CU-10 Load no soportado",
              1'b0, 1'b0, 4'b0000,
              2'b00, 1'b0, 1'b0);

        // Resumen final
        $display("");
        $display("========== RESUMEN CONTROL UNIT ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests != 0) begin
            $display("Estado general: FAIL");
            $display("==========================================");
            $fatal(1, "Verificacion Control Unit fallida: %0d pruebas.",
                   failed_tests);
        end
        else begin
            $display("Estado general: PASS");
            $display("==========================================");
            $finish;
        end

    end

endmodule
