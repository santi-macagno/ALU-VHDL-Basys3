----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2025 05:07:02 PM
-- Design Name: 
-- Module Name: saturador - Behavioral
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

entity saturador is
    port (
    entrada : in std_logic_vector (3 downto 0) ;
    Ovf : in std_logic;
    act : in std_logic;
    sal : out std_logic_vector (3 downto 0)

    );
end saturador;

architecture Behavioral of saturador is

begin
process ( entrada, Ovf, act)
    begin 
    if act = '1' and Ovf = '1' then
    if entrada (3) = '1' then 
        sal <= "0111" ;
    else 
        sal <= "1000" ;
    end if;
    else
        sal <= entrada;
        end if;
        
end process;   
    

end Behavioral;
