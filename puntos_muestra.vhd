----------------------------------------------------------------------------------
-- Company: Nameless2
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    13:01:33 11/18/2013 
-- Design Name: 
-- Module Name:    puntos_muestra - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity puntos_muestra is

    Port ( caso : in std_logic_vector(1 downto 0);
				numPuntos : in std_logic_vector( 6 downto 0);
				enable, retro_muestra : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           fin : out STD_LOGIC;
			  entradaTeclado: in std_logic_vector(49 downto 0);
           punto_o : out STD_LOGIC_VECTOR(20 downto 0);
			  count_o: out std_logic_vector(3 downto 0));-- Para mostrar en el display de 7 segmentos
           
end puntos_muestra;

architecture Behavioral of puntos_muestra is

-- En la representación en coma fija
-- DEC es el número de bits reservados a la parte decimal
-- ENT es el número de bits reservados a la parte entera
constant ENT : integer := 11;
constant DEC : integer := 10;

 --Tamaño de los coeficientes en la señal de salida del teclado
constant COEF : integer := 5;
constant NUM_COUNT : integer:= 4; 


type matriz1 is array(0 to 32) of  std_logic_vector(DEC+ENT+NUM_COUNT-1 downto 0);
type matriz2 is array(0 to 31) of  std_logic_vector(DEC+ENT+NUM_COUNT-1 downto 0);


-- En función del caso utilizaremos uno de los siguientes muestreos de puntos (para más información consultar genera2.m)
constant puntos1 : matriz1 := ( 
"0000000000000000000000000",
"0000000000000001000000000",
"0000000000000010000000000",
"0000000000000011000000000",
"0000000000000100000000000",
"0000000000000101000000000",
"0000000000000110000000000",
"0000000000000111000000000",
"0000000000001000000000000",
"0000000000001001000000000",
"0000000000001010000000000",
"0000000000001011000000000",
"0000000000001100000000000",
"0000000000001101000000000",
"0000000000001110000000000",
"0000000000001111000000000",
"0000000000010000000000000",
"0000000000010001000000000",
"0000000000010010000000000",
"0000000000010011000000000",
"0000000000010100000000000",
"0000000000010101000000000",
"0000000000010110000000000",
"0000000000010111000000000",
"0000000000011000000000000",
"0000000000011001000000000",
"0000000000011010000000000",
"0000000000011011000000000",
"0000000000011100000000000",
"0000000000011101000000000",
"0000000000011110000000000",
"0000000000011111000000000",
"0000000000100000000000000");

constant puntos2 : matriz2 := ( 
"0000000000000000000000000",
"0000000000000010000000000",
"0000000000000011000000000",
"0000000000000100000000000",
"0000000000000101000000000",
"0000000000000110000000000",
"0000000000000111000000000",
"0000000000001000000000000",
"0000000000001001000000000",
"0000000000001010000000000",
"0000000000001011000000000",
"0000000000001100000000000",
"0000000000001101000000000",
"0000000000001110000000000",
"0000000000001111000000000",
"0000000000010000000000000",
"0000000000010001000000000",
"0000000000010010000000000",
"0000000000010011000000000",
"0000000000010100000000000",
"0000000000010101000000000",
"0000000000010110000000000",
"0000000000010111000000000",
"0000000000011000000000000",
"0000000000011001000000000",
"0000000000011010000000000",
"0000000000011011000000000",
"0000000000011100000000000",
"0000000000011101000000000",
"0000000000011110000000000",
"0000000000011111000000000",
"0000000000100000000000000");

constant puntos3 : matriz2 := (
"1111111111100000000000000",
"1111111111100010000000000",
"1111111111100100000000000",
"1111111111100110000000000",
"1111111111101000000000000",
"1111111111101010000000000",
"1111111111101100000000000",
"1111111111101110000000000",
"1111111111110000000000000",
"1111111111110010000000000",
"1111111111110100000000000",
"1111111111110110000000000",
"1111111111111000000000000",
"1111111111111010000000000",
"1111111111111100000000000",
"1111111111111110000000000",
"0000000000000010000000000",
"0000000000000100000000000",
"0000000000000110000000000",
"0000000000001000000000000",
"0000000000001010000000000",
"0000000000001100000000000",
"0000000000001110000000000",
"0000000000010000000000000",
"0000000000010010000000000",
"0000000000010100000000000",
"0000000000010110000000000",
"0000000000011000000000000",
"0000000000011010000000000",
"0000000000011100000000000",
"0000000000011110000000000",
"0000000000100000000000000");

signal punto: STD_LOGIC_VECTOR(DEC+ENT+NUM_COUNT-1 downto 0);
signal count: std_logic_vector(3 downto 0);
signal c3, c2,c1, cn1, cn2, cn3: std_logic_vector(COEF-1 downto 0);
signal puntoAux: std_logic_vector(20 downto 0);
signal estado, estado_sig: std_logic_vector(6 downto 0);



begin

-- Obtenemos los coeficientes introducidos por el teclado, en valor absoluto
process(entradaTeclado)
begin
if entradaTeclado(34)='1' then c3 <= "00000" - entradaTeclado(34 downto 30);
else c3 <= entradaTeclado(34 downto 30);
end if;
if entradaTeclado(29)='1' then c2 <= "00000" - entradaTeclado(29 downto 25);
else c2 <= entradaTeclado(29 downto 25);
end if;
if entradaTeclado(24)='1' then c1 <= "00000" - entradaTeclado(24 downto 20);
else c1 <= entradaTeclado(24 downto 20);
end if;
if entradaTeclado(14)='1' then cn1<= "00000" - entradaTeclado(14 downto 10);
else cn1 <= entradaTeclado(14 downto 10);
end if;
if entradaTeclado(9)='1' then cn2 <= "00000" - entradaTeclado(9 downto 5);
else cn2 <= entradaTeclado(9 downto 5);
end if;
if entradaTeclado(4)='1' then cn3 <= "00000" - entradaTeclado(4 downto 0);
else cn3 <= entradaTeclado(4 downto 0);
end if;
end process;


-- En función de los coeficientes de la función, escogemos el count adecuado (reescalado del eje X)
-- (para más información consultar genera2.m)
pcount: process(c3, c2, c1, cn1, cn2, cn3, caso)
begin
	if caso = "00" then
		count <= "0000";
	else
		 if c3>0 then
			  if cn3>0 then
					count<="0010";
			  elsif cn2>0 then
					if c3 > cn2(4 downto 1) then
						 count<="0001";
					else
						 count<="0010";
					end if;
			  elsif cn1>0 then
					count<="0001";
			  else
					count<="0001";
			  end if;
		 elsif c2>0 then
			  if cn3>0 then
					if cn3 > c2(4 downto 1) then
						 count<="0011";
					else
						 count<="0010";
					end if;
			  elsif cn2>0 then
					count<="0010";
			  elsif cn1>0 then
					if c2 > cn1(4 downto 1) then
						 count<="0001";
					else
						 count<="0010";
					end if;
			  else
					count<="0010";
			  end if;
		 elsif c1>0 then
			  if cn3>0 then
					count<="0011";
			  elsif cn2>0 then
					if cn2 > c1(4 downto 1) then
						 count<="0011";
					else
						 count<="0010";
					end if;
			  else
					count<="0010";
			  end if;
		 else
			  if cn3>0 then
					count<="0100";
			  elsif cn2>0 then
					count<="0011";
			  elsif cn1>0 then
					count<="0010";
				else
					count<="0000";
			  end if;
		 end if;
	 end if;
end process pcount;

sincrono: process (clk, reset, enable)
begin
   if reset = '1' then 
		estado <= (others => '0');
   elsif clk'event and clk = '1' then
      if enable = '1' then
         estado <= estado_sig;
      elsif retro_muestra = '1'
		then estado <= numPuntos-1;
		end if;
   end if;

end process sincrono;


maquina_estados: process(estado, caso, numPuntos)
begin
		if estado = "0000000" then
			fin <= '1';
		else
			fin <= '0';
		end if;
		if caso = "00" then 
			punto <= puntos1(conv_integer(unsigned(estado)));
		elsif caso = "01" then 
			punto <= puntos2(conv_integer(unsigned(estado)));
		else
			punto <= puntos3(conv_integer(unsigned(estado)));
		end if;
		
	 
		if estado = numPuntos-1 then
			estado_sig <= (others => '0');
			fin <= '1';
		else
			estado_sig <= estado + 1;
			fin <= '0';
		end if;

end process maquina_estados;

-- En función del count (nos indica la potencia de 2 por la cual tenemos que multiplicar los puntos de muestra),
--elegimos el subvector que nos interesa 

puntoAux <= punto(DEC+ENT+NUM_COUNT-1-conv_integer(count) downto NUM_COUNT-conv_integer(count));
punto_o <= puntoAux;


-- Escala x: en el caso normal, 1 unidad equivale a 2^(count-3), por lo que count_o representará este exponente
-- En el caso de solo tomar números positivos (logaritmo), debido al reescalado de los puntos, ahora 1 unidad
-- representará la mitad que en el caso anterior
with caso select
count_o <= count-3 when "10", --eje central
			count-4 when  others;--eje en la izquierda (log)


					

end Behavioral;



