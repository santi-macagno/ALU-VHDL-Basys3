----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2025 06:51:02 PM
-- Design Name: 
-- Module Name: ALU_top1 - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
--FUNCIONAMIENTO --------------------
-- EN A_top y B_top ponemos los valores de entrada
-- CONTROL EL MAS RARO SERIA ----
-- PARA EL BIT '0' ES EL SELECTOR DEL SUMADOR RESTADOR SELECCIONA SI SUMA O RESTA ('0','1') RESPECTIVAENTE
-- PARA EL BIT '1' ES DEL SATURADOR OSEA 1 SATURA 0 NO SI SE CUMPLEN LAS COND
-- PARA EL BIT '2' ES EL SELECTOR DE "A" O "B" DEL MUX SELECCIONA AND U OR
-- PARA EL BIT '3' ES EL SELECTOR PARA DECIDIR SI QUEREMOS EL RESULTADO LOGICO O ARITMETICO DE LAS ENTRADAS

entity ALU_top is
Port (
    A_top, B_top : in std_logic_vector (3 downto 0); -- entradas 4 bits
    Control : in std_logic_vector (3 downto 0); -- bits de control 
    Res : out std_logic_vector (3 downto 0); -- resultado de la alu
    Cout : out std_logic; -- carry de salida del sumador    
    Ovf : out std_logic; -- overflow del sumador
    seg : out std_logic_vector (6 downto 0);
    an : out std_logic_vector (3 downto 0)
   
);
end ALU_top;

architecture Structural of ALU_top is
    signal arit      : std_logic_vector (3 downto 0); -- salida del sumador
    signal arit_satu : std_logic_vector (3 downto 0); -- resultado aritmetico saturado
    signal and_res1   : std_logic_vector (3 downto 0); -- res de A and B
    signal or_res1    : std_logic_vector (3 downto 0); -- res de A or B
    signal log_res   : std_logic_vector (3 downto 0); -- resultado logico
    signal Ovf_top   : std_logic;
    signal resultado_final   : std_logic_vector (3 downto 0);
begin

    unidad_1: entity work.sumador_restador
                port map (
                    A => A_top,
                    B => B_top, 
                    sel => Control (0), 
                    R => arit,
                    Cout => Cout,
                    Ovf => Ovf_top
                );

    unidad_2 : entity work.saturador   
                port map (
                    entrada => arit,
                    Ovf => Ovf_top, 
                    act => Control(1),
                    sal => arit_satu
                );

    unidad_3 : entity work.logica
                port map(
                    A => A_top,
                    B => B_top,
                    and_res => and_res1,
                    or_res => or_res1

                );

    unidad_4 :entity work.mux
                port map (
                    A => and_res1,
                    B => or_res1,
                    sel => Control(2),
                    mux_out => log_res
                );
                
    unidad_final : entity work.mux
                port map(
                    A => arit_satu,
                    B => log_res,
                    sel => Control(3),
                    mux_out => resultado_final


                );  
        
    unidad_seg7 : entity work.display7
               port map(
               valor => resultado_final,
               segmento => seg
               );        
       Ovf <= Ovf_top;
      Res <= resultado_final;
       an <= "1110";


end Structural;
