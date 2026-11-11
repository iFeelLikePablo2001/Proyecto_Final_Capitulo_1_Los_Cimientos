// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Data Memory
//
// Descripción:
// Memoria de datos del procesador. Almacena palabras de 32
// bits con lectura combinacional y escritura síncrona (flanco
// positivo de clk) controlada por MemWrite. Solo se soporta
// acceso alineado a palabra (lw y sw).
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
// PARÁMETROS
// ------------------------------------------------------------
// DEPTH        : Cantidad de palabras de 32 bits (por defecto 64,
//                es decir, 256 bytes). Debe ser potencia de 2.
//
// ENTRADAS
// ------------------------------------------------------------
// clk          : Reloj. La escritura ocurre en el flanco positivo.
// MemWrite     : Habilita la escritura (1 = escribir).
// A            : Dirección de byte (viene de ALUResult).
// WD           : Dato de 32 bits a escribir (viene de RD2).
//
// SALIDAS
// ------------------------------------------------------------
// RD           : Palabra de 32 bits leída en la dirección A.
// ============================================================
//

module data_memory #(
    parameter int DEPTH = 64
) (
    input  logic        clk,
    input  logic        MemWrite,
    input  logic [31:0] A,
    input  logic [31:0] WD,
    output logic [31:0] RD
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  localparam int ADDR_BITS = $clog2(DEPTH);

  // Arreglo de palabras de 32 bits
  logic [31:0] mem[0:DEPTH-1];

  // Inicialización a cero (evita valores 'x' en simulación)
  integer i;
  initial begin
    for (i = 0; i < DEPTH; i = i + 1) mem[i] = 32'b0;
  end

  // Escritura síncrona: solo si MemWrite = 1
  always_ff @(posedge clk) begin
    if (MemWrite) mem[A[ADDR_BITS+1:2]] <= WD;
  end

  // Lectura combinacional
  assign RD = mem[A[ADDR_BITS+1:2]];

endmodule
