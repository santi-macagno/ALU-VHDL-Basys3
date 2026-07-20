# ALU de 4 Bits en VHDL - Basys 3

Este proyecto contiene el diseño en VHDL de una **Unidad Aritmético Lógica (ALU)** de 4 bits con soporte para operaciones aritméticas (suma/resta con opción de saturación en Complemento a 2) y operaciones lógicas (AND/OR), además de un decodificador para visualizar los resultados en el display de 7 segmentos de la placa **Digilent Basys 3** (FPGA Xilinx Artix-7).

---

##  Arquitectura del Proyecto

El diseño está compuesto por una arquitectura estructural modular que conecta las siguientes unidades:

```
                  +-----------------------------------+
                  |            ALU_top                |
                  |                                   |
 A(3..0) -------->+---> [ sumador_restador ]          |
 B(3..0) -------->+---> [      logica     ]          |
                  |            |      |               |
 Control(0) ----->+------------+      |               |
 Control(1) ----->+---> [ saturador ] |               |
 Control(2) ----->+-----------> [ mux ]               |
 Control(3) ----->+----------------> [ mux (final) ]---> Res(3..0)
                  |                       |           |---> Ovf / Cout
                  |                       v           |
                  |                  [ display7 ]----> seg(6..0), an(3..0)
                  +-----------------------------------+
```

### Módulos Principales

1. **`ALU_top.vhd`**: Módulo de nivel superior (Top Level) que realiza el interconectado estructural de todas las sub-unidades.
2. **`sumador_restador.vhd`**: Sumador/Restador de 4 bits en Complemento a 2 (C2) con detección de carry de salida (`Cout`) y desbordamiento (`Ovf`).
3. **`saturador.vhd`**: Módulo opcional de saturación. Cuando está activo (`Control(1) = '1'`) y ocurre un desbordamiento (`Ovf = '1'`), limita el resultado a $+7$ (`"0111"`) para overflow positivo o a $-8$ (`"1000"`) para overflow negativo en C2.
4. **`logica.vhd`**: Realiza las operaciones bit a bit `AND` y `OR` en paralelo entre los vectores de entrada `A` y `B`.
5. **`mux.vhd`**: Multiplexor paramétrico de 2 a 1 para seleccionar entre operaciones lógicas/aritméticas o selección de función.
6. **`display7.vhd`**: Decodificador BCD/Hexadecimal a display de 7 segmentos con lógica catódica (activo en `'0'`).
7. **`TB_ALU.vhd`**: Banco de pruebas (Testbench) para la verificación funcional del circuito en simulación.

---

##  Tabla de Control de la ALU

La palabra de control `Control(3 downto 0)` define la operación a ejecutar según el siguiente desglose de bits:

| Bit de Control | Función / Selector |
| :---: | :--- |
| **`Control(0)`** | Selector Suma/Resta (`'0'`: Suma, `'1'`: Resta) |
| **`Control(1)`** | Habilitador de Saturación en C2 (`'0'`: Normal, `'1'`: Satura si hay `Ovf`) |
| **`Control(2)`** | Selector de Operación Lógica (`'0'`: AND, `'1'`: OR) |
| **`Control(3)`** | Selector Lógica/Aritmética (`'0'`: Resultado Aritmético, `'1'`: Resultado Lógico) |

---

##  Recrear el Proyecto mediante Tcl Script

Para mantener el repositorio liviano y evitar subir archivos temporales pesados de Vivado (como `.Xil/`, `*.runs/`, `*.cache/`), se utiliza la reconstrucción automatizada mediante **Tcl Scripts**.

### 1. Exportar el Script Tcl desde Vivado (Pasos seguidos en el diseño)
En Vivado, con el proyecto abierto, ve al menú superior:
> **`File` > `Project` > `Write Tcl...`**

En la ventana que se despliega:
* Asigna el nombre `recreate_project.tcl` en la raíz del proyecto.
* Desmarca la casilla **Write all properties**.
* Asegúrate de marcar **Copy sources to project** o **Reconstruct build tree**.

### 2. Cómo Reconstruir el Proyecto desde Cero (Para otros usuarios o computadoras)
Si clonas este repositorio en una nueva computadora o máquina virtual, puedes re-crear el proyecto `.xpr` exacto con un solo comando:

#### Opción A: Desde la Terminal de Vivado (GUI)
1. Abre Vivado.
2. En la barra de herramientas superior, ve a **`Tools` > `Run Tcl Script...`**.
3. Selecciona el archivo `recreate_project.tcl` presente en la raíz del repositorio.

#### Opción B: Desde la Consola/Terminal (Símbolo del sistema o Bash)
Abre la terminal en la carpeta del repositorio y ejecuta Vivado en modo batch/tcl:
```bash
vivado -mode tcl -source recreate_project.tcl
```
Vivado leerá las fuentes dentro de la carpeta `srcs` y generará la estructura de proyecto `.xpr` de forma totalmente automática.

---

##  Requisitos de Hardware y Software

* **FPGA Target**: Digilent Basys 3 (Xilinx Artix-7 `xc7a35tcpg236-1`).
* **Toolchain**: Xilinx Vivado ML Edition (versión 2020.1 o posterior).
* **Lenguaje**: VHDL-2008 / VHDL-93.
