// ============================================================
// Proyecto: Procesador RISC-V Uniciclo
// Curso: Diseño de Sistemas Digitales
// Grupo: 4 (Los Ohmnívoros) 
//
// Módulo: Multiplexor 2 a 1
//
// Descripción:
// Implementa un multiplexor 2 a 1 parametrizable que permite
// seleccionar una de dos entradas de datos.
//
// Autor / Developer: Pablo Cabrera
// Nombre: ______________________________
// Fecha de primera versión: 20/10/2026
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
// PARÁMETROS
// ------------------------------------------------------------
// WIDTH        : Cantidad de bits de las entradas y la salida.
//
// ENTRADAS
// ------------------------------------------------------------
// A            : Entrada 0.
// B            : Entrada 1.
// Select       : Señal de selección.
//
// SALIDAS
// ------------------------------------------------------------
// Y            : Entrada seleccionada.
// ============================================================

module mux2to1 #(
    parameter WIDTH = 32
)(
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic             Select,
    output logic [31:0] Y
);

    // ========================================================
    // IMPLEMENTACIÓN DEL MÓDULO
    // ========================================================

    assign Y = Select ? B : A;
endmodule
