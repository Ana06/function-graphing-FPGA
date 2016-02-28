----------------------------------------------------------------------------------
-- Company: Nameless2
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    17:18:53 12/09/2013 
-- Design Name: 
-- Module Name:    reconocedor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reconocedor is
	port(ps2data: inout std_logic; 
			ps2clk: inout std_logic;
			reset: in std_logic;
			clk: in std_logic;
			fin : out std_logic;
			fin_coef: out std_logic_vector(15 downto 0);
			salida: out std_logic_vector(49 downto 0)); -- cambiar dimensiones si cambia l!!!!!
end reconocedor;

architecture Behavioral of reconocedor is
constant l: integer := 4;
component KbdCore is
PORT ( 
    clk                 : IN    STD_LOGIC;
    rst                 : IN    STD_LOGIC;
    rdOBuff             : IN    STD_LOGIC;
    wrIBuffer           : IN    STD_LOGIC;
    dataFromHost        : IN    STD_LOGIC_VECTOR(7 downto 0);
    KBData              : INOUT STD_LOGIC;
    KBClk               : INOUT STD_LOGIC;
    statusReg           : OUT   STD_LOGIC_VECTOR(7 downto 0);
    dataToHost          : OUT   STD_LOGIC_VECTOR(7 downto 0)
);
end component KbdCore;
signal statusOut, dataOut: std_logic_vector(7 downto 0);
signal num: std_logic_vector(l downto 0);
signal estado: std_logic_vector(3 downto 0);
signal leer, signo: std_logic;
signal espera: std_logic_vector(1 downto 0);
signal salidaout: std_logic_vector(49 downto 0);
begin

--dar la vuelta a los coeficientes
salida(49 downto 45) <= salidaout(4 downto 0);
salida(44 downto 40) <= salidaout(9 downto 5);
salida(39 downto 35) <= salidaout(14 downto 10);
salida(34 downto 30) <= salidaout(19 downto 15);
salida(29 downto 25) <= salidaout(24 downto 20);
salida(24 downto 20) <= salidaout(29 downto 25);
salida(19 downto 15) <= salidaout(34 downto 30);
salida(14 downto 10) <= salidaout(39 downto 35);
salida(9 downto 5) <= salidaout(44 downto 40);
salida(4 downto 0) <= salidaout(49 downto 45);

with dataOut select
num <= "00001" when "00010110",
		 "00010" when "00011110",
		 "00011" when "00100110",
		 "00100" when "00100101",
		 "00101" when "00101110",
		 "00110" when "00110110",
		 "00111" when "00111101",
		 "01000" when "00111110",
		 "01001" when "01000110",
		 "00000" when "01000101",
		 "01100" when "01001110",-- menos en teclado ingles, ' en teclado español
		 "01111" when "11110000",-- deja de pulsar la tecla
		 "01110" when others;    -- codigo de otra tecla

elemento: KbdCore port map(clk, reset, leer, '0', "00000000", ps2data, ps2clk, statusOut, dataOut);
-- si statusOut(7) esta a 1 no ha habido mas pulsaciones de teclado

pleer: process(clk, statusOut)
begin
	if statusOut(7)='1' then
		leer<='0';
	else
		leer<='1';
	end if;
end process pleer;

sinc: process(clk, reset)
begin
	if reset='1' then
		estado<="0000";
		signo<='0';
		espera<="10"; -- el primer codigo es erroneo
		salidaout<=(others=>'0');
		fin_coef <= (others => '0');
	elsif clk'event and clk='1' then -- al tener un clk'event no hace falta completar los if
	fin <= '0';
	
		if statusOut(7)='0' then
			if espera="00" then
				espera<="01";
				if num="00000" then -- 0
					if estado="1001" then
						estado<="0000";
						fin <= '1';
					else
						estado<=estado+1;
					end if;
					salidaout((conv_integer(estado)+1)*(l+1)-1 downto conv_integer(estado)*(l+1))<="00000";
					fin_coef(conv_integer(estado)) <= '1';
					signo<='0';
				elsif num="01100" then -- menos
					signo<='1';
				elsif num/="01110" then -- no es una tecla numerica
					if estado="1001" then
						estado<="0000";
						fin <= '1';
					else
						estado<=estado+1;
					end if;
					if signo = '0' then
						salidaout((conv_integer(estado)+1)*(l+1)-1 downto conv_integer(estado)*(l+1))<=num;
						fin_coef(conv_integer(estado)) <= '1';
					else
						salidaout((conv_integer(estado)+1)*(l+1)-1 downto conv_integer(estado)*(l+1))<="00000"-num;
						fin_coef(conv_integer(estado)) <= '1';
					end if;
					signo<='0';
				end if;
			elsif espera="01" and num="01111" then -- espera hasta que la tecla deje de ser pulsada
				espera<="10";
				if estado = "0001" then
					salidaout(49 downto 5) <= (others => '0');
					fin_coef(10 downto 1) <= (others => '0');
				end if;
			else
				espera<="00";
			end if;
		end if;
	end if;
end process sinc;
end Behavioral;
