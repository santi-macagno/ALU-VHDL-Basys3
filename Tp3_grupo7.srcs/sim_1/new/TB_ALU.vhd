----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/30/2025 01:58:11 PM
-- Design Name: 
-- Module Name: TB_ALU - Behavioral
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

entity TB_ALU is
--  Port ( );
end TB_ALU;

architecture Behavioral of TB_ALU is
signal A, B     : std_logic_vector (3 downto 0);
            signal Control  : std_logic_vector (3 downto 0);
            signal Res      : std_logic_vector (3 downto 0);
            signal Cout     : std_logic;
            signal Ovf      : std_logic;
begin
            DUT : entity work.ALU_top
                port map (
                    A_top => A,
                    B_top => B,
                    Control => Control,
                    Res => Res,
                    Cout => Cout,
                    Ovf => Ovf
              );
process
    begin
        --Suma sin saturacion (1)
        A <= "0011";        -- A = 3
        B <= "0101";        -- B = 5
        Control <= "0000"; 
        wait for 10 ns;

        --Resta sin saturacion (2)
        A <= "0110";        -- A = 6
        B <= "0010";        -- B = 2
        Control <= "0001";
        wait for 10 ns;

        --Resta con saturacion activa sin overflow (3)
        A <= "0110";        -- A = 6
        B <= "0001";        -- B = 1
        Control <= "0011";
        wait for 10 ns;

        --Suma con overflow positivo se satura a 7  (4)
        A <= "0111";        -- A = 7
        B <= "0001";        -- B = 1
        Control <= "0010";
        wait for 10 ns;

        --Suma con overflow negativo se satura a -8   (5)
        A <= "1000";       
        B <= "1000";       
        Control <= "0010";   
        wait for 10 ns;

        --Logica AND   (6)
        A <= "1100";
        B <= "1010";
        Control <= "0000";        
        Control(3) <= '1';       
        wait for 10 ns;

        --Logica OR    (7)
        Control(2) <= '1';    
        wait for 10 ns;

        --Salida logica sin saturacion   (8)
        A <= "1111";
        B <= "0000";
        Control <= "1100";        
        wait for 10 ns;
        
         A <= "1000" ;
        B <= "0011" ;
        Control <= "0000" ;
        wait for 10 ns;

        wait;
    end process;


end Behavioral;