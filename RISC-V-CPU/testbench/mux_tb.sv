// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: TODO
//
// Testbench: Multiplexor 2 a 1
//
// Descripción:
// Verifica que el multiplexor seleccione correctamente cada
// una de sus entradas según la señal Select.
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

module mux_tb;

  logic [31:0] A;
  logic [31:0] B;
  logic        Select;
  logic [31:0] Y;

  mux dut (
      .A(A),
      .B(B),
      .Select(Select),
      .Y(Y)
  );

  task automatic check(
	  input string id, 
	  input logic [31:0] exp_y
	  );

    if (Y == exp_y)

      $display(
          "[PASS] %s | esperado=%0h | obtenido=%0h", id, $signed(exp_y), $signed(Y));

    else begin

      $display("[FAIL] %s | esperado=%0h | obtenido=%0h", id, $signed(exp_y), $signed(Y));

    end
  endtask

  initial begin

    A = 32'h12345678;
    B = 32'hABCDEF00;

    $display("A=32'h12345678, B=32'hABCDEF00");

    // ====================================================
    // TEST 1 - Select = 0
    // ====================================================
    Select = 0;

    #10;

    check("Select = 0", A);


    // ====================================================
    // TEST 2 - Select = 1
    // ====================================================
    Select = 1;

    #10;

    check("Select = 1", B);

    // ====================================================
    // TEST 3 - Prueba adicional
    // ====================================================

    #10;

    A = 32'h11111111;
    B = 32'hAAAAAAAA;

    $display("A=32'h11111111, B=32'hAAAAAAAA");

    // ====================================================
    // TEST 1 - Select = 0
    // ====================================================
    Select = 0;

    #10;

    check("Select = 0", A);


    // ====================================================
    // TEST 2 - Select = 1
    // ====================================================
    Select = 1;

    #10;

    check("Select = 1", B);
    $finish;
  end

endmodule
