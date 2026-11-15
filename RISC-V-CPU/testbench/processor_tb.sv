`timescale 1ns/1ps

// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnivoros)
//
// Testbench: Processor (Integracion)
//
// Descripcion:
// Verifica la integracion y funcionamiento del procesador
// RISC-V uniciclo mediante la ejecucion de un programa propio.
// Comprueba las siete instrucciones requeridas, el avance
// del Program Counter y los valores de registros y memoria,
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

module processor_tb;


    // 1. DECLARACION DE SEÑALES

    logic clk;
    logic reset;

    logic [31:0] PC;
    logic [31:0] Instr;

    integer total_tests;
    integer passed_tests;
    integer failed_tests;


    // 2. INSTANCIA DEL PROCESADOR

    processor dut (
        .clk(clk),
        .reset(reset),
        .PC(PC),
        .Instr(Instr)
    );


    // 3. GENERACION DEL RELOJ

    initial clk = 0;

    always #5 clk = ~clk;


    // 4. TAREA PARA VERIFICAR RESULTADOS

    task automatic verificar(
        input string nombre,
        input logic [31:0] obtenido,
        input logic [31:0] esperado
    );

        begin

            total_tests = total_tests + 1;

            if (obtenido === esperado) begin

                passed_tests = passed_tests + 1;

                $display("[PASS] %s", nombre);

            end else begin

                failed_tests = failed_tests + 1;

                $display("[FAIL] %s", nombre);

            end

            $display("  RESULTADO ESPERADO:");
            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(esperado), esperado);
            $display("    BIN=%032b", esperado);

            $display("  RESULTADO OBTENIDO:");
            $display("    DEC=%0d | HEX=0x%08h",
                     $signed(obtenido), obtenido);
            $display("    BIN=%032b", obtenido);

            $display("----------------------------------------");

        end

    endtask

    // 5. TAREA PARA AVANZAR UN CICLO
    
    task automatic avanzar_ciclo(
        input string nombre,
        input logic [31:0] pc_esperado
    );

        begin

            @(posedge clk);

            #1;

            verificar(nombre, PC, pc_esperado);

        end

    endtask


    // 6. PROGRAMA DE PRUEBAS

    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        reset = 1;


        // 7. CARGA DEL PROGRAMA RISC-V

        #1;

        // ADDI x1, x0, 13
        dut.imem.mem[0] = 32'h00D00093;

        // ADDI x2, x0, 7
        dut.imem.mem[1] = 32'h00700113;

        // ADD x3, x1, x2
        dut.imem.mem[2] = 32'h002081B3;

        // SUB x4, x1, x2
        dut.imem.mem[3] = 32'h40208233;

        // AND x5, x1, x2
        dut.imem.mem[4] = 32'h0020F2B3;

        // OR x6, x1, x2
        dut.imem.mem[5] = 32'h0020E333;

        // SW x4, 0(x0)
        dut.imem.mem[6] = 32'h00402023;

        // LW x7, 0(x0)
        dut.imem.mem[7] = 32'h00002383;

        // ADDI x8, x7, -3
        dut.imem.mem[8] = 32'hFFD38413;

        // SW x8, 4(x0)
        dut.imem.mem[9] = 32'h00802223;

        // LW x9, 4(x0)
        dut.imem.mem[10] = 32'h00402483;

        // ADD x10, x9, x5
        dut.imem.mem[11] = 32'h00548533;


        $display("\n========================================");
        $display("  TESTBENCH DEL PROCESADOR RISC-V");
        $display("========================================\n");


        // 8. VERIFICACION DEL RESET

        @(posedge clk);

        #1;

        verificar(
            "CPU-00 Reset inicial del PC",
            PC,
            32'd0
        );

        verificar(
            "CPU-00 Lectura primera instruccion",
            Instr,
            32'h00D00093
        );


        // Desactivar reset antes del siguiente flanco

        @(negedge clk);

        reset = 0;


        // 9. INSTRUCCION 1: ADDI

        avanzar_ciclo(
            "CPU-01 PC despues de ADDI",
            32'd4
        );

        verificar(
            "CPU-01 ADDI x1 = 13",
            dut.rf.regs[1],
            32'd13
        );


        // 10. INSTRUCCION 2: ADDI

        avanzar_ciclo(
            "CPU-02 PC despues de ADDI",
            32'd8
        );

        verificar(
            "CPU-02 ADDI x2 = 7",
            dut.rf.regs[2],
            32'd7
        );


        // 11. INSTRUCCION 3: ADD

        avanzar_ciclo(
            "CPU-03 PC despues de ADD",
            32'd12
        );

        verificar(
            "CPU-03 ADD x3 = 20",
            dut.rf.regs[3],
            32'd20
        );


        // 12. INSTRUCCION 4: SUB

        avanzar_ciclo(
            "CPU-04 PC despues de SUB",
            32'd16
        );

        verificar(
            "CPU-04 SUB x4 = 6",
            dut.rf.regs[4],
            32'd6
        );


        // 13. INSTRUCCION 5: AND

        avanzar_ciclo(
            "CPU-05 PC despues de AND",
            32'd20
        );

        verificar(
            "CPU-05 AND x5 = 5",
            dut.rf.regs[5],
            32'd5
        );


        // 14. INSTRUCCION 6: OR

        avanzar_ciclo(
            "CPU-06 PC despues de OR",
            32'd24
        );

        verificar(
            "CPU-06 OR x6 = 15",
            dut.rf.regs[6],
            32'd15
        );


        // 15. INSTRUCCION 7: SW

        avanzar_ciclo(
            "CPU-07 PC despues de SW",
            32'd28
        );

        verificar(
            "CPU-07 SW Memoria[0] = 6",
            dut.dmem.mem[0],
            32'd6
        );


        // 16. INSTRUCCION 8: LW

        avanzar_ciclo(
            "CPU-08 PC despues de LW",
            32'd32
        );

        verificar(
            "CPU-08 LW x7 = 6",
            dut.rf.regs[7],
            32'd6
        );


        // 17. INSTRUCCION 9: ADDI NEGATIVO

        avanzar_ciclo(
            "CPU-09 PC despues de ADDI negativo",
            32'd36
        );

        verificar(
            "CPU-09 ADDI x8 = 3",
            dut.rf.regs[8],
            32'd3
        );


        // 18. INSTRUCCION 10: SW

        avanzar_ciclo(
            "CPU-10 PC despues de SW",
            32'd40
        );

        verificar(
            "CPU-10 SW Memoria[4] = 3",
            dut.dmem.mem[1],
            32'd3
        );


        // 19. INSTRUCCION 11: LW

        avanzar_ciclo(
            "CPU-11 PC despues de LW",
            32'd44
        );

        verificar(
            "CPU-11 LW x9 = 3",
            dut.rf.regs[9],
            32'd3
        );


        // 20. INSTRUCCION 12: ADD

        avanzar_ciclo(
            "CPU-12 PC despues de ADD",
            32'd48
        );

        verificar(
            "CPU-12 ADD x10 = 8",
            dut.rf.regs[10],
            32'd8
        );


        // 21. VERIFICACION REGISTRO X0

        verificar(
            "CPU-13 Registro x0 permanece en cero",
            dut.rf.regs[0],
            32'd0
        );


        // 22. RESUMEN FINAL

        $display("");
        $display("========== RESUMEN PROCESSOR ==========");
        $display("Pruebas ejecutadas: %0d", total_tests);
        $display("Pruebas aprobadas:  %0d", passed_tests);
        $display("Pruebas fallidas:   %0d", failed_tests);

        if (failed_tests == 0)
            $display("Estado general: PASS");
        else
            $display("Estado general: FAIL");

        $display("=======================================");
        $display("");

        $finish;

    end

endmodule
