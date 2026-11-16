# Procesador RISC-V Uniciclo

## Diseño de Sistemas Digitales

### Capítulo 1 - Los cimientos y Capítulo 2 - Integración del Procesador Uniciclo

Este paquete contiene la implementación y verificación en SystemVerilog de los componentes fundamentales y la integración completa del procesador RISC-V uniciclo de 32 bits (subconjunto RV32I: `add`, `sub`, `and`, `or`, `addi`, `lw` y `sw`).

## Grupo

Nombre de grupo: Ohmnivoros

## Integrantes y roles

* Team Lead: Karla Priscila Arias Arias
* Hardware Developer 1: Pablo Andrés Cabrera Montealegre
* Hardware Developer 2: Julián Murillo Wo Ching
* Verification Engineer: Iván Josué Arias Quiros
* Documentation & Configuration Engineer: Chavelli Fernández Murillo

## Estructura

```text
RISC-V-CPU/
├── src/
│   ├── alu.sv
│   ├── register_file.sv
│   ├── imm_gen.sv
│   ├── mux.sv
│   ├── program_counter.sv
│   ├── instruction_memory.sv
│   ├── data_memory.sv
│   ├── control_unit.sv
│   └── processor.sv
├── testbench/
│   ├── alu_tb.sv
│   ├── register_file_tb.sv
│   ├── imm_gen_tb.sv
│   ├── mux_tb.sv
│   ├── program_counter_tb.sv
│   ├── instruction_memory_tb.sv
│   ├── data_memory_tb.sv
│   ├── control_unit_tb.sv
│   └── processor_tb.sv
├── evidencias/
│   ├── ALU/
│   ├── Register_File/
│   ├── Imm_Gen/
│   ├── Mux/
│   ├── Program_Counter/
│   ├── Instruction_Memory/
│   ├── Data_Memory/
│   ├── Control_Unit/
│   └── Processor/
├── docs/
└── README.md

```

## Módulos del Capítulo 1

* ALU
* Register File
* Immediate Generator
* Multiplexor 2 a 1

## Módulos del Capítulo 2

* Program Counter (PC)
* Instruction Memory
* Data Memory
* Control Unit
* Processor (Integración Top-Level RISC-V Uniciclo)

## Ambiente de trabajo

Editor recomendado: Visual Studio Code.

Simulación oficial: EDA Playground.

Los archivos `.sv` utilizados localmente deben ser compatibles con los archivos entregados y simulados en EDA Playground.

## Enlaces de simulación

Las simulaciones de los módulos y de la integración del procesador se realizaron utilizando EDA Playground. A continuación, se presentan los enlaces correspondientes a cada componente.

### Capítulo 1

ALU: [https://www.edaplayground.com/x/rArT](https://www.edaplayground.com/x/rArT)

Register File: [https://www.edaplayground.com/x/9NTD](https://www.edaplayground.com/x/9NTD)

Immediate Generator: [https://www.edaplayground.com/x/8Eq](https://www.edaplayground.com/x/8Eq)_

MUX: [https://www.edaplayground.com/x/vY9z](https://www.edaplayground.com/x/vY9z)

### Capítulo 2

Program Counter: [https://www.edaplayground.com/x/ZXzW]

Instruction Memory: [https://www.edaplayground.com/x/7cbz]

Data Memory: [https://www.edaplayground.com/x/QuXL]

Control Unit: [https://www.edaplayground.com/x/w4aB]

Processor (Integración): [https://www.edaplayground.com/x/f3wF]


## Convenciones

1. No eliminar el encabezado de los archivos proporcionados.
2. Completar el nombre de grupo, autor y fecha de primera versión.
3. Registrar las modificaciones importantes en el historial del archivo.
4. No borrar entradas anteriores del historial de modificaciones.
5. Mantener los nombres de módulos y puertos proporcionados, salvo autorización del profesor.
6. Completar las secciones marcadas como `TODO`.
7. Los testbenches deben verificar los casos requeridos por la especificación y pueden incluir casos adicionales.
8. Cada resultado presentado debe poder ser explicado durante la defensa.

## Estado de los módulos

| Módulo | Implementación | Verificación | Estado |
| --- | --- | --- | --- |
| ALU | Completado | Completado (8/8 PASS) | Verificado |
| Register File | Completado | Completado (4/4 PASS) | Verificado |
| Immediate Generator | Completado | Completado (8/8 PASS) | Verificado |
| MUX | Completado | Completado (6/6 PASS) | Verificado |
| Program Counter | Completado | Completado (6/6 PASS) | Verificado |
| Instruction Memory | Completado | Completado (6/6 PASS) | Verificado |
| Data Memory | Completado | Completado (8/8 PASS) | Verificado |
| Control Unit | Completado | Completado (10/10 PASS) | Verificado |
| Processor (Top-Level) | Completado | Completado (27/27 PASS) | Verificado |

## Evidencia de verificación

La evidencia de verificación de los módulos se encuentra en el informe técnico y en la carpeta `evidencias/`, donde se incluyen capturas de las simulaciones realizadas para cada componente y para la integración del procesador. Estas evidencias permiten observar los resultados de las pruebas unitarias de la ALU, el banco de registros, el generador de inmediatos, el multiplexor, el contador de programa, la memoria de instrucciones, la memoria de datos y la unidad de control, así como la ejecución completa del programa de prueba en el procesador RISC-V uniciclo (83 pruebas ejecutadas en total, 83 aprobadas y 0 fallidas).

