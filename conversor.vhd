----------------------------------------------------------------------------------
-- Company: Nameless2
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    12:15:23 11/18/2013 
-- Design Name: 
-- Module Name:    conversor - Behavioral 
-- Project Name: Representación gráfica de funciones	
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
use IEEE.STD_LOGIC_SIGNED.ALL;

entity conversor is
	port( caso : in std_logic_vector(1 downto 0);
			numPuntos : in std_logic_vector(6 downto 0);
	      fin_pantalla: in std_logic;
			avanza: in std_logic;
			punto: in std_logic_vector(20 downto 0);
			reset, clk: in std_logic;
			punto1X, punto2X, punto1Y, punto2Y: out std_logic_vector(6 downto 0);
			enable_pantalla, fin_conv, inf: out std_logic;
			indice_o: out std_logic_vector(4 downto 0)); -- Para mostrarlo en la barra de LEDs
end conversor;

architecture Behavioral of conversor is

constant ENT : integer := 11;
constant DEC : integer := 10;
constant nB: integer := 6;


type matrizPuntos is array(0 to 31) of  std_logic_vector(31 downto 0);
signal puntos, puntosAux: matrizPuntos;

signal indice, indice3: std_logic_vector(4 downto 0);

signal salida1Y, salida2Y: std_logic_vector(6 downto 0);
signal estado, estado_sig: std_logic_vector(6 downto 0);
signal estado2, estado2_sig: std_logic_vector(1 downto 0);

signal vAcc, vAccAux: std_logic_vector(DEC+ENT-1 downto 6);

type matrizX is array(0 to 32) of  std_logic_vector(6 downto 0);
signal puntos1X: matrizX;
type matrizX2 is array(0 to 31) of  std_logic_vector(6 downto 0);
signal puntos2X, puntos3X : matrizX2;

begin

puntos1X(0) <= "0000000";
puntos1X(1) <= "0000100";
puntos1X(2) <= "0001000";
puntos1X(3) <= "0001100";
puntos1X(4) <= "0010000";
puntos1X(5) <= "0010100";
puntos1X(6) <= "0011000";
puntos1X(7) <= "0011100";
puntos1X(8) <= "0100000";
puntos1X(9) <=  "0100100";
puntos1X(10) <= "0101000";
puntos1X(11) <= "0101100";
puntos1X(12) <= "0110000";
puntos1X(13) <= "0110100";
puntos1X(14) <= "0111000";
puntos1X(15) <= "0111100";
puntos1X(16) <= "1000000";
puntos1X(17) <= "1000100";
puntos1X(18) <= "1001000";
puntos1X(19) <= "1001100";
puntos1X(20) <= "1010000";
puntos1X(21) <= "1010100";
puntos1X(22) <= "1011000";
puntos1X(23) <= "1011100";
puntos1X(24) <= "1100000";
puntos1X(25) <= "1100100";
puntos1X(26) <= "1101000";
puntos1X(27) <= "1101100";
puntos1X(28) <= "1110000";
puntos1X(29) <= "1110100";
puntos1X(30) <= "1111000";
puntos1X(31) <= "1111100";
puntos1X(32) <= "1111111";

puntos2X(0) <= "0000000";
puntos2X(1) <= "0001000";
puntos2X(2) <= "0001100";
puntos2X(3) <= "0010000";
puntos2X(4) <= "0010100";
puntos2X(5) <= "0011000";
puntos2X(6) <= "0011100";
puntos2X(7) <= "0100000";
puntos2X(8) <=  "0100100";
puntos2X(9) <= "0101000";
puntos2X(10) <= "0101100";
puntos2X(11) <= "0110000";
puntos2X(12) <= "0110100";
puntos2X(13) <= "0111000";
puntos2X(14) <= "0111100";
puntos2X(15) <= "1000000";
puntos2X(16) <= "1000100";
puntos2X(17) <= "1001000";
puntos2X(18) <= "1001100";
puntos2X(19) <= "1010000";
puntos2X(20) <= "1010100";
puntos2X(21) <= "1011000";
puntos2X(22) <= "1011100";
puntos2X(23) <= "1100000";
puntos2X(24) <= "1100100";
puntos2X(25) <= "1101000";
puntos2X(26) <= "1101100";
puntos2X(27) <= "1110000";
puntos2X(28) <= "1110100";
puntos2X(29) <= "1111000";
puntos2X(30) <= "1111100";
puntos2X(31) <= "1111111";

puntos3X(0) <= "0000000";
puntos3X(1) <= "0000100";
puntos3X(2) <= "0001000";
puntos3X(3) <= "0001100";
puntos3X(4) <= "0010000";
puntos3X(5) <= "0010100";
puntos3X(6) <= "0011000";
puntos3X(7) <= "0011100";
puntos3X(8) <= "0100000";
puntos3X(9) <=  "0100100";
puntos3X(10) <= "0101000";
puntos3X(11) <= "0101100";
puntos3X(12) <= "0110000";
puntos3X(13) <= "0110100";
puntos3X(14) <= "0111000";
puntos3X(15) <= "0111100";
puntos3X(16) <= "1000100";
puntos3X(17) <= "1001000";
puntos3X(18) <= "1001100";
puntos3X(19) <= "1010000";
puntos3X(20) <= "1010100";
puntos3X(21) <= "1011000";
puntos3X(22) <= "1011100";
puntos3X(23) <= "1100000";
puntos3X(24) <= "1100100";
puntos3X(25) <= "1101000";
puntos3X(26) <= "1101100";
puntos3X(27) <= "1110000";
puntos3X(28) <= "1110100";
puntos3X(29) <= "1111000";
puntos3X(30) <= "1111100";
puntos3X(31) <= "1111111";



index: process(vAcc, estado2)
begin
-- En función del bit más significativo a 1 (permanece en todo a 1 tras realizar las or(ver el estado "10"), una posición a la izquierda
-- de ese bit será el índice. La conversión a coordenadas de pantalla consiste en, a partir de ese bit y hacia
-- la derecha, tomar 7 bits (un punto de la pantalla)
	indice <= "00110";
	bucle1: for i in 6 to 20 loop
	if estado2 = "01" or estado2 = "10" or estado2 = "11" then
		if vAcc(i) = '1' then
			indice <= conv_std_logic_vector(i+1, 5);
		end if;
	end if;
	end loop bucle1;
end process index;

sincrono: process(clk, reset, estado2_sig, estado_sig)
begin
	if reset = '1' then 
		estado2 <= ( others => '0');
		estado <= ( others => '0'); 				
	elsif clk'event and clk = '1' then
		estado2 <= estado2_sig;
		estado <= estado_sig;
	end if;
end process sincrono;

maquina: process(estado2, fin_pantalla, punto, avanza, puntos, estado, vAcc, numPuntos, caso)
begin

inf <= '0';
puntosAux <= puntos;
vAccAux <= vAcc;
salida1Y <= (others=>'0');
salida2Y <= (others=>'0');
		
	case estado2 is
	-- Estado de inicio
	when "00" =>
		vAccAux <= (others => '0');
		fin_conv <= '1';
		enable_pantalla <= '0';
		estado_sig <= estado;
		if avanza = '1' then
			estado2_sig <= "01";
		else
			estado2_sig <= "00";
		end if;
		
	-- Estado 01: de guardado de puntos. Se guardan en puntos, y vAcc (en este último, como valor absoluto,
	-- con el fin de poder obtener el índice necesario realizar el reescalado a coordenadas de pantalla, basándonos
	-- en realizar sucesivas OR lógicas con el fin de obtener el índice (factor para la escala vertical).
	
	when "01" =>
		fin_conv <= '0';
		enable_pantalla <= '0';
		if punto(20)='1' then 
			puntosAux(conv_integer(unsigned(estado))) <= "11111111111" & punto;
			vAccAux <= vAcc or ("000000000000" - punto(DEC+ENT-1 downto 6));
		else 
			vAccAux <= vAcc or punto(DEC+ENT-1 downto 6);
			puntosAux(conv_integer(unsigned(estado))) <= "00000000000" & punto;
		end if;
		
		estado_sig <= estado;
		if avanza ='1' then 
			if estado  = numPuntos-1 then
				estado2_sig <= "10";
				estado_sig <= (others => '0');
			else
				estado_sig <= estado +1;
				estado2_sig <= "01";
			end if;
		else 
			estado_sig <= estado;
			estado2_sig <= estado2;
		end if;

	-- En el siguiente estado se manda un par de puntos a la pantalla. Los puntos han sigo guardados en los estados
	-- anteriores, por tanto la señal indice tiene el valor correcto con el fin de tomar el subvector para realizar
	-- el reescalado.
	-- Debido a las características de la algoritmia de la pantalla, estado 10 y 11 son iguales, salvo que en el primero
	-- únicamente estamos un ciclo con enable_pantalla a 1.
	when "10" =>
		if estado = "0000000" and caso(1)='0' then
			inf <= '1';
		elsif estado = numPuntos(6 downto 1) -1 and caso = "10"  then
			inf <= '1';
		else 
			inf <= '0';
		end if;
		
		enable_pantalla <= '1';
		fin_conv <= '0';
		
		salida1Y <= puntos(conv_integer(unsigned(estado)))(conv_integer(unsigned(indice)) downto conv_integer(unsigned(indice))-6);
		salida2Y <= puntos(conv_integer(unsigned(estado))+1)(conv_integer(unsigned(indice)) downto conv_integer(unsigned(indice))-6);
		
		estado2_sig <= "11";
		estado_sig <= estado;
				
	when "11" =>
		if estado = "0000000" and caso(1)='0' then
			inf <= '1';
		elsif estado = numPuntos(6 downto 1) -1 and caso = "10"  then
			inf <= '1';
		else 
			inf <= '0';
		end if;
		
		
		fin_conv <= '0';
		
		salida1Y <= puntos(conv_integer(unsigned(estado)))(conv_integer(unsigned(indice)) downto conv_integer(unsigned(indice))-6);
		salida2Y <= puntos(conv_integer(unsigned(estado))+1)(conv_integer(unsigned(indice)) downto conv_integer(unsigned(indice))-6);
		
		enable_pantalla <= '0';
		if fin_pantalla = '1' then
			if estado = numPuntos-2 then
				estado_sig <= (others => '0');
				estado2_sig <= "00";
			else
				estado_sig <= estado +1;
				estado2_sig <= "10";
			end if;
		else 
			estado2_sig <= estado2;
			estado_sig <= estado;
		end if;
		
				
		-- Una vez hemos obtenido el subvector de longitud 7 usando el indice, hacemos 64 - eso, con el fin
		-- de ajustar a las coordenadas en la pantalla.
		
		
		--Ejemplo: las coordenadas verticales de la pantalla son de esta manera
		--
		-- 0 (lim. sup)
		--
		--
		-- 64 (eje horizontal)
		--
		--
		-- 127 (lim.inf). 
		
		-- Así, si por ejemplo tenemos los f(x) = 2, f(y) = 3, al tomar con el índice teniendo en cuenta las
		-- or anteriores quedarían 0100000 (=32) (para el 2) y 0110000 (=48) (para el 3). Realizando 64 - lo anterior, quedarían
		-- las coordenadas 32 y 16, respectivamente. De forma similar, si f(x) fuera negativo, su coordenada sería mayor
		-- que 64, quedando por debajo del eje horizontal.
	when others =>
		
	end case;



end process maquina;

process(clk)
begin
	if clk'event and clk = '1' then
		if estado2 = "11" then
			indice3 <= indice;
		else
			indice3 <= indice3;
		end if;
	end if;
end process;

p_outX: process(puntos1X, puntos2X, estado, estado2, caso, puntos3X)
begin
	if estado2 = "10" or estado2 = "11" then
		if caso = "00" then
			punto1X <= puntos1X(conv_integer(unsigned(estado)));
			punto2X <= puntos1X(conv_integer(unsigned(estado))+1);
		elsif caso = "01" then
			punto1X <= puntos2X(conv_integer(unsigned(estado)));
			punto2X <= puntos2X(conv_integer(unsigned(estado))+1);
		else
			punto1X <= puntos3X(conv_integer(unsigned(estado)));
			punto2X <= puntos3X(conv_integer(unsigned(estado))+1);			
		end if;
	else
			punto1X <= (others => '1');
			punto2X <=  (others => '1');
	end if;
end process p_outX;


registros: process (clk, reset, vAccAux, puntosAux, estado2_sig, estado_sig)
begin
	if reset = '1' then 
		puntos <= (others => "00000000000000000000000000000000");
		vAcc <= (others => '0');
		estado2 <= (others => '0');
		estado <= (others => '0');
	elsif clk'event and clk = '1' then
		puntos <= puntosAux;
		vAcc <= vAccAux;
		estado <= estado_sig;
		estado2 <= estado2_sig;
	end if;
end process registros;



punto1Y <= 64 - salida1Y;
punto2Y <= 64 - salida2Y;


-- Escala y: 1 unidad equivale a 2^(indice-13), por lo que indice_o representará este exponente

indice_o <= unsigned(indice3)-13 ;
end Behavioral;

