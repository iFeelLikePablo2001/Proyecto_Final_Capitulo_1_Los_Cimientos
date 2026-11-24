// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Multiplexor 3 a 1
//
// Descripción:
// Implementa un multiplexor 3 a 1 parametrizable que permite
// seleccionar una de tres entradas de datos. En el procesador
// se usa para elegir el dato que se escribe en el registro
// destino (ResultSrc): resultado de la ALU, dato leído de la
// memoria o PC + 4 (jal).
//
// Autor / Developer: Pablo Cabrera
// Nombre: mux3to1.sv
// Fecha de primera versión: 24/11/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// 24/11/2026  | Pablo Cabrera      | Primera versión
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// PARÁMETROS
// ------------------------------------------------------------
// WIDTH        : Cantidad de bits de las entradas y la salida.
//
// ENTRADAS
// ------------------------------------------------------------
// A            : Entrada 0 (Select = 00).
// B            : Entrada 1 (Select = 01).
// C            : Entrada 2 (Select = 10).
// Select       : Señal de selección de 2 bits.
//
// SALIDAS
// ------------------------------------------------------------
// Y            : Entrada seleccionada. Con Select = 11 (no usado)
//                la salida es 0.
// ============================================================

module mux3to1 #(
    parameter WIDTH = 32
) (
    input  logic [WIDTH - 1:0] A,
    input  logic [WIDTH - 1:0] B,
    input  logic [WIDTH - 1:0] C,
    input  logic [        1:0] Select,
    output logic [WIDTH - 1:0] Y
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  always_comb begin
    case (Select)
      2'b00:   Y = A;
      2'b01:   Y = B;
      2'b10:   Y = C;
      default: Y = '0;  // 2'b11 no se usa: salida en 0 (evita latches)
    endcase
  end

endmodule