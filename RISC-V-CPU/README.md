# Procesador RISC-V Uniciclo

## Diseño de Sistemas Digitales

### Capítulo 1 - Los cimientos

Este paquete contiene las plantillas iniciales para el desarrollo y verificación de los componentes fundamentales del procesador RISC-V uniciclo.

## Grupo

Nombre de grupo: Ohmnivoros

## Integrantes y roles

- Team Lead: Karla Priscila Arias Arias
- Hardware Developer 1: Pablo Andrés Cabrera Montealegre
- Hardware Developer 2: Julián Murillo Wo Ching
- Verification Engineer: Iván Josué Arias Quiros
- Documentation & Configuration Engineer: Chavelli Fernández Murillo


## Estructura

```text
RISC-V-CPU/
├── src/
│   ├── alu.sv
│   ├── register_file.sv
│   ├── imm_gen.sv
│   └── mux.sv
├── testbench/
│   ├── alu_tb.sv
│   ├── register_file_tb.sv
│   ├── imm_gen_tb.sv
│   └── mux_tb.sv
├── Imágenes de Puebas
|   ├──ALU
|   ├── Imm_gen
|   ├──Mux
├── Liks
├── docs/
└── README.md
```

## Módulos del Capítulo 1

- ALU
- Register File
- Immediate Generator
- Multiplexor 2 a 1

## Ambiente de trabajo

Editor recomendado: Visual Studio Code.

Simulación oficial: EDA Playground.

Los archivos `.sv` utilizados localmente deben ser compatibles con los archivos entregados y simulados en EDA Playground.

## Enlaces de simulación

Las simulaciones de los módulos se realizaron utilizando EDA Playground. A continuación, se presentan los enlaces correspondientes a cada componente.

ALU: [Agregar enlace de EDA Playground]

Register File: [Agregar enlace de EDA Playground]

Immediate Generator: [Agregar enlace de EDA Playground]

MUX: [Agregar enlace de EDA Playground]

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
|---|---|---|---|
| ALU | TODO | TODO | Verificado | 
| Register File | TODO | TODO | Verificado |
| Immediate Generator | TODO | TODO | Verificado |
| MUX | TODO | TODO | Verificado |

## Evidencia de verificación

La evidencia de verificación de los módulos se encuentra en el informe técnico y en la carpeta evidencias/, donde se incluyen capturas de las simulaciones realizadas para cada componente. Estas evidencias permiten observar los resultados de las pruebas de la ALU, el banco de registros, el generador de inmediatos y el multiplexor.

