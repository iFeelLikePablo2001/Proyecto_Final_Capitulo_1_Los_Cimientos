// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros) 
//
// Módulo: Register File
//
// Descripción:
// Banco de 32 registros de 32 bits con dos puertos de lectura
// y un puerto de escritura. La escritura es síncrona (flanco
// positivo de clk) y la lectura es combinacional. El registro
// x0 siempre vale cero.
//
// Autor / Developer:
// Nombre: Julián Murillo Wo Ching 
// Fecha de primera versión: 22/10/2026
//
// Historial de modificaciones:
// ------------------------------------------------------------
// Fecha       | Autor              | Descripción
// ------------------------------------------------------------
// ____/____/  | _________________  | Primera versión
// ____/____/  | _________________  | ________________________
// ____/____/  | _________________  | ________________________
//
// ============================================================

// ============================================================
// ENTRADAS
// ------------------------------------------------------------
// clk          : Reloj. La escritura ocurre en el flanco positivo.
// A1           : Dirección del registro leído por el puerto 1.
// A2           : Dirección del registro leído por el puerto 2.
// A3           : Dirección del registro destino de la escritura.
// WD3          : Dato de 32 bits a escribir en A3.
// RegWrite     : Habilita la escritura (1 = escribir).
//
// SALIDAS
// ------------------------------------------------------------
// RD1          : Contenido del registro A1.
// RD2          : Contenido del registro A2.
// ============================================================

module register_file (
    input  logic        clk,
    input  logic [4:0]  A1,
    input  logic [4:0]  A2,
    input  logic [4:0]  A3,
    input  logic [31:0] WD3,
    input  logic        RegWrite,
    output logic [31:0] RD1,
    output logic [31:0] RD2
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    // Arreglo de 32 registros de 32 bits
    logic [31:0] regs [31:0];

    // Inicialización a cero (evita valores 'x' en simulación)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    // Escritura síncrona: solo si RegWrite = 1 y el destino no es x0
    always_ff @(posedge clk) begin
        if (RegWrite && (A3 != 5'd0))
            regs[A3] <= WD3;
    end

    // Lectura combinacional: x0 siempre devuelve cero
    assign RD1 = (A1 == 5'd0) ? 32'b0 : regs[A1];
    assign RD2 = (A2 == 5'd0) ? 32'b0 : regs[A2];

endmodule
