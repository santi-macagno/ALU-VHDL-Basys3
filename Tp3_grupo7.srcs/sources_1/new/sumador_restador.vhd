----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2025 05:48:09 PM
-- Design Name: 
-- Module Name: sumador_restador - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
    
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sumador_restador is
port (
    A, B : in std_logic_vector (3 downto 0);
    sel : in std_logic; -- este es el selector de suma o resta si es 0 suma si es 1 resta
    R : out std_logic_vector (3 downto 0); -- resultado
    Cout : out std_logic; -- carry de salida
    Ovf : out std_logic -- overflow 
    
);
end sumador_restador;

architecture Behavioral of sumador_restador is
    signal B_mod : std_logic_vector (3 downto 0); -- B modificado para la resta
    signal A_5, B_5, R_5 : signed (4 downto 0); -- valores extendidos con signo a 5 bit
    
begin
    -- aca si "sel" = 0 B_mod = B osea suma 
    -- y si "sel" = 1 B_mod = complemento a2 de B osea resta
    B_mod <= B when sel = '0' 
    else std_logic_vector (unsigned (not B) + 1);
   
   -- se extienden a y b_mpod a 5 bits con signo para detectar el overflow y carry
   A_5 <= signed ('0' & A); -- agg bit al principio
   B_5 <= signed ('0' & B_mod);
   R_5 <= A_5 + B_5; --rea;iza la suma
   
   --en el resultado solo tomamos los 4 bits menos signioficaticos
   R <= std_logic_vector (R_5 (3 downto 0));
   
   -- y en el carry out tomamos el bit mas significativo del r_5
   Cout <= R_5 (4);
   
   -- ahora en el overflow detectamos si el signo no tiene sentido tipo si en complemento a2 sumo dos positivos y da negativo tengo ovf
Ovf <= (A(3) and B_mod(3) and not R_5(3)) or
        (not A(3) and not B_mod(3) and R_5(3));
end Behavioral;
