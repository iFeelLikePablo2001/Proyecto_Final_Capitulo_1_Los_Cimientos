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


    // Instancia del módulo bajo prueba
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    // Compara Result y Zero contra los valores esperados e
    // imprime PASS/FAIL con el ID de la matriz de pruebas.
    task automatic check(
        input string       id,
        input logic [31:0] exp_result,
        input logic        exp_zero
    );
        if (Result === exp_result && Zero === exp_zero)
            $display("[PASS] %s | A=%0b | B=%0b \n Esperado: %0b / Zero = %b | Obtenido: %0b / Zero = %b \n",
                     id, A, B, $signed(exp_result), exp_zero, $signed(Result), Zero);
        else begin
            $display("[FAIL] %s |  A=%0d | B=%0d \n Esperado: %0b / Zero = %b | Obtenido: %0b / Zero = %b \n",
                     id, A, B, $signed(exp_result), exp_zero, $signed(Result), Zero);
        end
    endtask

    initial begin

        // ====================================================
        // TEST 1 - ADD
        // ====================================================
        A = 5;
        B = 3;
        ALUControl = 4'b0000;

        #10;

        check("ALU-01 ADD 5+3", 32'd8, 1'b0);

        // ====================================================
        // TEST 2 - SUB
        // ====================================================
        A = 5;
        B = 3;
        ALUControl = 4'b0001;

        #10;

        check("ALU-02 SUB 5-3", 32'd2, 1'b0);

        // ====================================================
        // TEST 3 - AND
        // ====================================================
        A = 32'hF0F0F0F0;
        B = 32'h0FF00FF0;
        ALUControl = 4'b0010;

        #10;

        check("ALU-03 AND", 32'h00F000F0, 1'b0);

        // ====================================================
        // TEST 4 - OR
        // ====================================================
        A = 32'hF0F0F0F0;
        B = 32'h0FF00FF0;
        ALUControl = 4'b0011;

        #10;

        check("ALU-04 OR", 32'hFFF0FFF0, 1'b0);

        // ====================================================
        // TEST 5 - Resultado cero (flag Zero)
        // ====================================================
        A = 5;
        B = 5;
        ALUControl = 4'b0001;

        #10;

        check("ALU-05 SUB 5-5 (Zero=1)", 32'd0, 1'b1);

        // ====================================================
        // TEST 6 - Resultado negativo
        // ====================================================
        A = 3;
        B = 5;
        ALUControl = 4'b0001;

        #10;

        check("ALU-06 SUB 3-5 (negativo)", -32'sd2, 1'b0);

        // ====================================================
        // TEST 7 - Desbordamiento de ADD (se trunca a 32 bits)
        // ====================================================
        A = 32'hFFFFFFFF;
        B = 32'd1;
        ALUControl = 4'b0000;

        #10;

        check("ALU-07 ADD overflow (Zero=1)", 32'd0, 1'b1);

        // ====================================================
        // TEST 8 - AND con resultado cero
        // ====================================================
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        ALUControl = 4'b0010;

        #10;

        check("ALU-08 AND disjunto (Zero=1)", 32'd0, 1'b1);

        $finish;
    end

endmodule
