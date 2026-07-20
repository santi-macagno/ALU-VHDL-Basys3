# ALU de 4 Bits con Saturación y Display en VHDL - Basys 3

Este repositorio contiene la implementación completa en VHDL de una **Unidad Aritmético Lógica (ALU)** de 4 bits optimizada para la placa de desarrollo **Digilent Basys 3** (FPGA Xilinx Artix-7 `xc7a35tcpg236-1`). 

El diseño cuenta con una arquitectura **estructural modular**, soporte para operaciones aritméticas en Complemento a 2 (C2), módulo de saturación ante desbordamientos (*overflow*), operaciones lógicas bit a bit, multiplexación de salidas y decodificación para el display de 7 segmentos integrado de la placa.

---

## 📐 Descripción General del Proyecto

La ALU procesa dos entradas numéricas de 4 bits (`A` y `B`) en función de un vector de control de 4 bits (`Control`). Genera un resultado numérico o lógico (`Res`), banderas de estado (`Cout` y `Ovf`) y las señales para el control del display de 7 segmentos (`seg` y `an`).

### Diagrama de la Arquitectura Estructural (`ALU_top`)

```
                                  +---------------------------------------+
                                  |                ALU_top                |
                                  |                                       |
     A(3..0) -------------------->+---> [ sumador_restador ]              |
     B(3..0) -------------------->+---> [      logica     ]              |
                                  |            |      |                   |
 Control(0) (Suma/Resta) -------->+------------+      |                   |
 Control(1) (Act. Saturador) ---->+---> [ saturador ] |                   |
 Control(2) (AND/OR) ------------>+-----------> [ mux ]                   |
 Control(3) (Arit/Log) ---------->+----------------> [ mux (final) ]-----> Res(3..0)
                                  |                       |               |---> Ovf
                                  |                       v               |---> Cout
                                  |                  [ display7 ]--------> seg(6..0)
                                  |                               -------> an(3..0)
                                  +---------------------------------------+
```

---

## 🧩 Módulos del Sistema

1. **`ALU_top.vhd` (Top Level):**
   Módulo de nivel superior que interconecta estructuralmente mediante señales internas (`arit`, `arit_satu`, `and_res1`, `or_res1`, `log_res`, `resultado_final`) todos los bloques funcionales del circuito.

2. **`sumador_restador.vhd` (Unidad Aritmética):**
   * Realiza la suma (`Control(0) = '0'`) o resta (`Control(0) = '1'`) en Complemento a 2 mediante la conversión de `B` a su complemento (`not B + 1`).
   * Genera el bit de acarreo de salida (`Cout`).
   * Calcula el flag de desbordamiento (`Ovf`) detectando inconsistencias entre el signo de los operandos y el resultado.

3. **`saturador.vhd` (Bloque de Saturación):**
   * Evalúa si la saturación está activa (`Control(1) = '1'`) y si ocurrió un desbordamiento (`Ovf = '1'`).
   * Satura la salida a los valores límite de 4 bits en C2:
     * **$+7$ (`"0111"`)** ante overflow positivo.
     * **$-8$ (`"1000"`)** ante overflow negativo.
   * Si no hay overflow o la saturación está deshabilitada, transmite la salida aritmética original.

4. **`logica.vhd` (Unidad Lógica):**
   * Ejecuta en paralelo las operaciones booleanas bit a bit entre `A` y `B`: `AND` (`A and B`) y `OR` (`A or B`).

5. **`mux.vhd` (Multiplexor Paramétrico):**
   * Multiplexor combinacional de 2 a 1 de 4 bits. Se utiliza dos veces en el Top Level:
     * *Unidad 4:* Selecciona entre la salida `AND` o `OR` según `Control(2)`.
     * *Unidad Final:* Selecciona entre la salida Aritmética (Saturada/Normal) o Lógica según `Control(3)`.

6. **`display7.vhd` (Decodificador de Display):**
   * Convierte el resultado de 4 bits a su representación hexadecimal/BCD en el display de 7 segmentos de la Basys 3.
   * Funciona con lógica de ánodo común / catódica (segmento encendido en `'0'`).

7. **`TB_ALU.vhd` (Testbench / Banco de Pruebas):**
   * Módulo de simulación sin puertos (`entity TB_ALU is end;`).
   * Aplica estímulos secuenciales con retrasos temporales (`wait for 10 ns`) para verificar en simulación todas las combinaciones de la ALU.

---

## 🎛️ Decodificación del Vector de Control

La palabra `Control(3 downto 0)` configura la función deseada de la ALU:

| Bit de Control | Nombre | Descripción de Funcionamiento |
| :---: | :--- | :--- |
| **`Control(0)`** | `sel` Sumador | `'0'`: Suma ($A + B$)<br>`'1'`: Resta ($A - B$) |
| **`Control(1)`** | `act` Saturador | `'0'`: Sin saturación (salida con desbordamiento estándar)<br>`'1'`: Activa saturación en C2 ($+7$ / $-8$) ante `Ovf = '1'` |
| **`Control(2)`** | `sel` Lógica | `'0'`: Selecciona operación `AND`<br>`'1'`: Selecciona operación `OR` |
| **`Control(3)`** | `sel` Final | `'0'`: Salida de la ALU = Resultado Aritmético<br>`'1'`: Salida de la ALU = Resultado Lógico |

---

## 🧪 Entornos de Simulación y Verificación

El proyecto está diseñado para verificarse completamente mediante simulación funcional previa a la implementación física en la FPGA:

### Simuladores Compatibles
* **Vivado Simulator (XSim):** Simulador nativo integrado en Xilinx Vivado.
* **ModelSim / QuestaSim:** Totalmente compatible exportando las fuentes VHDL.
* **GHDL + GTKWave:** Entorno libre/código abierto para análisis de formas de onda.

### Escenarios de Prueba en el Testbench (`TB_ALU.vhd`)
El banco de pruebas simula los siguientes casos críticos:
1. **Suma Aritmética sin Saturación:** $3 + 5 = 8$ (evaluación de desbordamiento).
2. **Resta Aritmética sin Saturación:** $6 - 2 = 4$.
3. **Resta con Saturador Activo (sin Ovf):** $6 - 1 = 5$.
4. **Suma con Overflow Positivo Saturado:** $7 + 1 = 8 \rightarrow \text{Satura a } +7$ (`"0111"`).
5. **Suma con Overflow Negativo Saturado:** $-8 + (-8) = -16 \rightarrow \text{Satura a } -8$ (`"1000"`).
6. **Operaciones Lógicas:** Verificación de compuertas `AND` y `OR` bit a bit.

---

## ⚡ Automatización de Proyecto con Tcl Script (Gestión con Git)

Para mantener el repositorio libre de archivos temporales y binarios pesados (`.Xil/`, `*.runs/`, `*.cache/`, `*.bit`), el proyecto se puede reconstruir utilizando **Vivado Tcl Scripts**.

### Generar el Script desde Vivado (Para desarrolladores)
1. Con el proyecto abierto en Vivado, ve a **File > Project > Write Tcl...**
2. Nombra el archivo `recreate_project.tcl` en la raíz del proyecto.
3. Desmarca **Write all properties** y marca **Copy sources to project**.

### Reconstruir el Proyecto desde el Repositorio

#### Vía Interfaz Gráfica (Vivado GUI)
1. Abre Vivado.
2. En el menú superior ve a **Tools > Run Tcl Script...**
3. Selecciona `recreate_project.tcl`.

#### Vía Línea de Comandos (Terminal / CMD / PowerShell / Git Bash)
Navega a la carpeta del proyecto y ejecuta:
```bash
vivado -mode tcl -source recreate_project.tcl
```
Esto reconstruirá automáticamente la estructura `.xpr` con todos sus archivos asociándolos a la FPGA Basys 3.

---

## 💻 Requisitos de Hardware y Software

* **Tarjeta FPGA:** Digilent Basys 3 (Xilinx Artix-7 `xc7a35tcpg236-1`).
* **Entorno de Desarrollo:** Xilinx Vivado ML Edition (v2020.1 o superior).
* **Estándar de Lenguaje:** VHDL-2008 / VHDL-93.
