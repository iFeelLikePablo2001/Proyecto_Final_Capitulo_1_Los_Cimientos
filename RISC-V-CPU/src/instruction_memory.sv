// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros)
//
// Módulo: Instruction Memory
//
// Descripción:
// Memoria de instrucciones de solo lectura para el procesador.
// Almacena palabras de 32 bits y entrega la instrucción
// direccionada por el PC de forma combinacional. El programa
// se precarga desde un archivo hexadecimal (INIT_FILE) o
// escribiendo directamente en el arreglo mem desde el testbench.
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
// INIT_FILE    : Archivo .hex con una palabra de 32 bits por línea.
//                Si es "", la memoria se llena solo con NOP.
//
// ENTRADAS
// ------------------------------------------------------------
// A            : Dirección de byte de la instrucción (viene del PC).
//
// SALIDAS
// ------------------------------------------------------------
// RD           : Instrucción de 32 bits en la dirección A.
//
// ============================================================

module instruction_memory #(
    parameter int    DEPTH     = 64,  //Debe de ser potencia de 2
    parameter string INIT_FILE = ""
) (
    input  logic [31:0] A,  //Dirección
    output logic [31:0] RD  //Instrucción
);

  // ========================================================
  // IMPLEMENTACIÓN DEL MÓDULO
  // ========================================================

  localparam int ADDR_BITS = $clog2(DEPTH);

  // Arreglo de palabras de 32 bits
  logic [31:0] mem[0:DEPTH-1];

  // Inicialización: todo en NOP (addi x0, x0, 0) y luego el programa
  integer i;
  initial begin
    for (i = 0; i < DEPTH; i = i + 1) mem[i] = 32'h00000013;
    if (INIT_FILE != "") $readmemh(INIT_FILE, mem);
  end

  // Lectura combinacional: índice de palabra = A[ADDR_BITS+1:2]
  assign RD = mem[A[ADDR_BITS+1:2]];

endmodule
