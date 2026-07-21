----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/27/2025 10:29:28 AM
-- Design Name: 
-- Module Name: display7 - Behavioral
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

entity display7 is
    port (
    valor : in std_logic_vector (3 downto 0);
    segmento : out std_logic_vector (6 downto 0)
    );
end display7;

architecture Behavioral of display7 is

begin
process (valor)
    begin
        case valor is
            when "0000" => segmento <= "1000000";
            when "0001" => segmento <= "1111001";
            when "0010" => segmento <= "0100100";
            when "0011" => segmento <= "0110000";
            when "0100" => segmento <= "0011001";
            when "0101" => segmento <= "0010010";
            when "0110" => segmento <= "0000010";
            when "0111" => segmento <= "1111000";
            when "1000" => segmento <= "0000000";
            when "1001" => segmento <= "0010000";
            when "1010" => segmento <= "0001000";
            when "1011" => segmento <= "0000011";
            when "1100" => segmento <= "1000110";
            when "1101" => segmento <= "0100001";
            when "1110" => segmento <= "0000110";
            when "1111" => segmento <= "0001110";
            when others => segmento <= "1111111";
            
         end case;
         
      end process;


end Behavioral;
