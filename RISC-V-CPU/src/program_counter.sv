// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Program Counter
//
// Descripción:
// Registro de 32 bits que almacena la dirección de la
// instrucción actual. En cada flanco positivo de clk carga
// PCNext. La señal reset (síncrona, activa en alto) lleva el
// PC a 0x00000000.
//
// Autor / Developer:
// Nombre: Julián Murillo Wo Ching
// Fecha de primera versión: 10/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 10/11/2026  | Julián Murillo     | Primera versión
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Reloj. El PC se actualiza en el flanco positivo.
// reset        : Reinicio síncrono, activo en alto (1 = reiniciar).
// PCNext       : Dirección de la siguiente instrucción.
//
// SALIDAS
// ------------------------------------------------------------
// PC           : Dirección de la instrucción actual.
//
// ============================================================

module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] PCNext,
    output logic [31:0] PC
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  // Registro del PC: reset tiene prioridad sobre la carga de PCNext
  always_ff @(posedge clk) begin
    if (reset) PC <= 32'h00000000;
    else PC <= PCNext;
  end

endmodule
