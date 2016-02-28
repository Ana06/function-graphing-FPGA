----------------------------------------------------------------------------------
-- Company: Universidad Complutense de Madrid
-- Engineer: Hortensia Mecha
-- 
-- Design Name: divisor 
-- Module Name:    divisor - divisor_arch 
-- Project Name: 
-- Target Devices: 
-- Description: Creación de un reloj de 1Hz a partir de
--		un clk de 100 MHz
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.ALL;

entity divisor is
    port (
        reset: in STD_LOGIC;
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
    );
end divisor;

architecture divisor_arch of divisor is
 SIGNAL cuenta: std_logic_vector(1 downto 0);
 SIGNAL clk_aux, clk: std_logic;
  
  begin

clk<=clk_entrada; 
clk_salida<=clk_aux;
  contador:
  PROCESS(reset, clk)
  BEGIN
    IF (reset='1') THEN
      cuenta<= (OTHERS=>'0');
		clk_aux <= '0';
    ELSIF(clk'EVENT AND clk='1') THEN
      IF (cuenta="11") THEN 
      	clk_aux <= not clk_aux;
        cuenta<= (OTHERS=>'0');
      ELSE
        cuenta <= cuenta+'1';
      END IF;
    END IF;
  END PROCESS contador;

end divisor_arch;
