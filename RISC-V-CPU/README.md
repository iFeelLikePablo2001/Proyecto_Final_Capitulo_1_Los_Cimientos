# Procesador RISC-V Uniciclo

## Diseño de Sistemas Digitales

### Capítulo 1 - Los cimientos

Este paquete contiene las plantillas iniciales para el desarrollo y verificación de los componentes fundamentales del procesador RISC-V uniciclo.

## Grupo

Nombre de grupo: ____________________

## Integrantes y roles

- Team Lead: ______________________________
- Hardware Developer 1: ___________________
- Hardware Developer 2: ___________________
- Verification Engineer: __________________
- Documentation & Configuration Engineer: _

> En los grupos de cuatro integrantes, las responsabilidades deberán redistribuirse entre los miembros del equipo.

Los roles representan responsabilidades principales. Todos los integrantes deben conocer el funcionamiento general de los módulos y estar preparados para explicar el diseño durante la defensa.

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
| ALU | TODO | TODO | Pendiente |
| Register File | TODO | TODO | Pendiente |
| Immediate Generator | TODO | TODO | Pendiente |
| MUX | TODO | TODO | Pendiente |

## Evidencia de verificación

El equipo debe documentar los casos de prueba ejecutados utilizando la matriz de pruebas solicitada en las instrucciones del proyecto. Cada caso debe incluir como mínimo:

- Identificador del test.
- Condición o entrada utilizada.
- Resultado esperado.
- Resultado obtenido.
- Estado PASS/FAIL.

## Importante

Las plantillas proporcionan la interfaz y estructura inicial del proyecto. La implementación de los módulos, la ampliación de los testbenches y el análisis de los resultados son responsabilidad del equipo.
