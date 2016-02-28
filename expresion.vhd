----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    16:17:24 02/22/2014 
-- Design Name: 
-- Module Name:    expresion - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use std.textio.all;


entity expresion is
	port(
		clk: in std_logic;
		salida_teclado: in std_logic_vector(49 downto 0);
      addr : in std_logic_vector(7 downto 0);
      do : out std_logic_vector(0 to 10)
	);
end expresion;


architecture Behavioral of expresion is
	constant anchoExp: integer:=216;
	
	type matriz is array(0 to 255) of  std_logic_vector(10 downto 0);
	signal expMatematica: matriz;
	
	type coeficiente is array (0 to 5) of std_logic_vector(10 downto 0);
   constant cero: coeficiente:= 	("01111111111", "01111111111", "01100000011", "01100000011", "01111111111", "01111111111");	
	constant uno: coeficiente:= 	((others=>'0'), (others=>'0'), "01111111111", "01111111111", (others=>'0'), (others=>'0'));	
 	constant dos: coeficiente:= 	("01111110011", "01111110011", "01100110011", "01100110011", "01100111111", "01100111111");	
	constant tres: coeficiente:= 	("01111111111", "01111111111", "01100110011", "01100110011", "01100110011", "01100000011");
	constant cuatro: coeficiente:=("01111111111", "01111111111", "00000110000", "00000110000", "01111110000", "01111110000");	
 	constant cinco: coeficiente:= ("01100111111", "01100111111", "01100110011", "01100110011", "01111110011", "01111110011");	
 	constant seis: coeficiente:= 	("01100111111", "01100111111", "01100110011", "01100110011", "01111111111", "01111111111");	
 	constant siete: coeficiente:= ("00000110000", "01111111111", "01111111111", "01100110000", "01100000000", "01100000000");	
 	constant ocho: coeficiente:= 	("01111111111", "01111111111", "01100110011", "01100110011", "01111111111", "01111111111");	
 	constant nueve: coeficiente:= ("01111111111", "01111111111", "01100110000", "01100110000", "01111110000", "01111110000");	

	type caracter5Lineas is array (0 to 4) of std_logic_vector(10 downto 0);
	constant X: caracter5Lineas:= 			("01100000011", "00011001100", "00000110000", "00011001100", "01100000011");
	constant sen: caracter5Lineas:= 			("00111100011", "01111110011", "01100110011", "01100111111", "01100011110");
	constant cos: caracter5Lineas:= 			("01111111111", "01111111111", "11000000011", "11000000011", "11000000011");
	constant log: caracter5Lineas:= 			("00000000011", "00000000011", "00000000011", "01111111111", "01111111111");
	constant pi: caracter5Lineas:= 			("01111111111", "01111111111", "01100000000", "01111111111", "01111111111");
	constant Xpequeña: caracter5Lineas:= 	("00110000011", "00001101100", "00000010000", "00001101100", "00110000011");
	
	type signo is array (0 to 2) of std_logic_vector(10 downto 0);
	constant mas: signo:= 	("00000110000", "00011111100", "00000110000");
	constant menos: signo:= ("00000110000", "00000110000", "00000110000");
	
begin
--OBTENER TROZO DE LA EXPRESIÓN PEDIDO
expPedida: process (clk)
	begin
		if rising_edge(clk) then
			do <= expMatematica(anchoExp-1-conv_integer(addr));
      end if;	
end process expPedida;

				
--EXPRESION MATEMÁTICA
	
--ExpMatematica tiene algunos valores fijos

--Xs (5 columnas cada una)
--6-10
expMatematica(6)<=X(0);
expMatematica(7)<=X(1);
expMatematica(8)<=X(2);
expMatematica(9)<=X(3);
expMatematica(10)<=X(4);

--29-33
expMatematica(29)<=X(0);
expMatematica(30)<=X(1);
expMatematica(31)<=X(2);
expMatematica(32)<=X(3);
expMatematica(33)<=X(4);

--50-54
expMatematica(50)<=X(0);
expMatematica(51)<=X(1);
expMatematica(52)<=X(2);
expMatematica(53)<=X(3);
expMatematica(54)<=X(4);

--78-82
expMatematica(78)<=X(0);
expMatematica(79)<=X(1);
expMatematica(80)<=X(2);
expMatematica(81)<=X(3);
expMatematica(82)<=X(4);

--99-103
expMatematica(99)<=X(0);
expMatematica(100)<=X(1);
expMatematica(101)<=X(2);
expMatematica(102)<=X(3);
expMatematica(103)<=X(4);

--120-124
expMatematica(120)<=X(0);
expMatematica(121)<=X(1);
expMatematica(122)<=X(2);
expMatematica(123)<=X(3);
expMatematica(124)<=X(4);

--S de sen (5 columnas)
expMatematica(182)<=sen(0);
expMatematica(181)<=sen(1);
expMatematica(180)<=sen(2);
expMatematica(179)<=sen(3);
expMatematica(178)<=sen(4);

--C de cos(5 columnas)
expMatematica(153)<=cos(0);
expMatematica(152)<=cos(1);
expMatematica(151)<=cos(2);
expMatematica(150)<=cos(3);
expMatematica(149)<=cos(4);

--L de log(5 columnas)
expMatematica(201)<=log(0);
expMatematica(202)<=log(1);
expMatematica(203)<=log(2);
expMatematica(204)<=log(3);
expMatematica(205)<=log(4);

-- Lo de dentro del Sen y Cos: pi
expMatematica(176)<= pi(0);
expMatematica(175)<= pi(1);
expMatematica(174)<= pi(2);
expMatematica(173)<= pi(3);
expMatematica(172)<= pi(4);

expMatematica(147)<= pi(0);
expMatematica(146)<= pi(1);
expMatematica(145)<= pi(2);
expMatematica(144)<= pi(3);
expMatematica(143)<= pi(4);

-- Lo de dentro del Sen, Cos y log: x
expMatematica(170)<= Xpequeña(0);
expMatematica(169)<= Xpequeña(1);
expMatematica(168)<= Xpequeña(2);
expMatematica(167)<= Xpequeña(3);
expMatematica(166)<= Xpequeña(4);

expMatematica(141)<= Xpequeña(0);
expMatematica(140)<= Xpequeña(1);
expMatematica(139)<= Xpequeña(2);
expMatematica(138)<= Xpequeña(3);
expMatematica(137)<= Xpequeña(4);

expMatematica(195)<= Xpequeña(0);
expMatematica(196)<= Xpequeña(1);
expMatematica(197)<= Xpequeña(2);
expMatematica(198)<= Xpequeña(3);
expMatematica(199)<= Xpequeña(4);

--EXPONENTE 3 (3 columnas)
expMatematica(2)<="10001000000";
expMatematica(1)<="10101000000";
expMatematica(0)<="11111000000";

expMatematica(118)<="10001000000";
expMatematica(117)<="10101000000";
expMatematica(116)<="11111000000";

--EXPONENTE 2 (3 columnas)
expMatematica(23)<="11101000000";
expMatematica(24)<="10101000000";
expMatematica(25)<="10111000000";

expMatematica(95)<="11101000000";
expMatematica(96)<="10101000000";
expMatematica(97)<="10111000000";

--EXPONENTE 1 (1 columna)
expMatematica(46)<="11111000000";

--EXPONENTE - (1 columna)
expMatematica(4)<="00100000000";
expMatematica(27)<="00100000000";
expMatematica(48)<="00100000000";

--Los coeficientes son variables y dependen de salida_teclado
expMatCal: process(salida_teclado)
begin
--signo de coeficiente de x^-3
	if salida_teclado(4) = '0' then -- signo +
		expMatematica(19)<= mas(0);
		expMatematica(20)<= mas(1);
		expMatematica(21)<= mas(2);	
	else -- signo -
		expMatematica(19)<= menos(0);
		expMatematica(20)<= menos(1);
		expMatematica(21)<= menos(2);
	end if;
--signo de coeficiente de x^-2
	if salida_teclado(9) = '0' then -- signo +
		expMatematica(42)<= mas(0);
		expMatematica(43)<= mas(1);
		expMatematica(44)<= mas(2);	
	else -- signo -
		expMatematica(42)<= menos(0);
		expMatematica(43)<= menos(1);
		expMatematica(44)<= menos(2);
	end if;
--signo de coeficiente de x^-1
	if salida_teclado(14) = '0' then -- signo +
		expMatematica(63)<= mas(0);
		expMatematica(64)<= mas(1);
		expMatematica(65)<= mas(2);
	else -- signo -
		expMatematica(63)<= menos(0);
		expMatematica(64)<= menos(1);
		expMatematica(65)<= menos(2);
	end if;
--signo de coeficiente de la constante
	if salida_teclado(19) = '0' then -- signo +
		expMatematica(74)<= mas(0);
		expMatematica(75)<= mas(1);
		expMatematica(76)<= mas(2);	
	else -- signo -
		expMatematica(74)<= menos(0);
		expMatematica(75)<= menos(1);
		expMatematica(76)<= menos(2);
	end if;
--signo de coeficiente de x
	if salida_teclado(24) = '0' then -- signo +
		expMatematica(91)<= mas(0);
		expMatematica(92)<= mas(1);
		expMatematica(93)<= mas(2);
	else -- signo -
		expMatematica(91)<= menos(0);
		expMatematica(92)<= menos(1);
		expMatematica(93)<= menos(2);
	end if;		
--signo de coeficiente de x^2
	if salida_teclado(29) = '0' then -- signo +
		expMatematica(112)<= mas(0);
		expMatematica(113)<= mas(1);
		expMatematica(114)<= mas(2);
	else -- signo -
		expMatematica(112)<= menos(0);
		expMatematica(113)<= menos(1);
		expMatematica(114)<= menos(2);
	end if;		
--signo de coeficiente de x^3
	if salida_teclado(34) = '0' then -- signo +
		expMatematica(133)<= mas(0);
		expMatematica(134)<= mas(1);
		expMatematica(135)<= mas(2);	
	else -- signo -
		expMatematica(133)<= menos(0);
		expMatematica(134)<= menos(1);
		expMatematica(135)<= menos(2);
	end if;		
--signo de coeficiente de cos
	if salida_teclado(39) = '0' then -- signo +
		expMatematica(162)<= mas(0);
		expMatematica(163)<= mas(1);
		expMatematica(164)<= mas(2);	
	else -- signo -
		expMatematica(162)<= menos(0);
		expMatematica(163)<= menos(1);
		expMatematica(164)<= menos(2);
	end if;		
--signo de coeficiente de sen
	if salida_teclado(44) = '0' then -- signo +
		expMatematica(191)<= mas(0);
		expMatematica(192)<= mas(1);
		expMatematica(193)<= mas(2);
	else -- signo -
		expMatematica(191)<= menos(0);
		expMatematica(192)<= menos(1);
		expMatematica(193)<= menos(2);
	end if;
--signo de coeficiente de log	
if salida_teclado(49) = '0' then -- si es + no se muestra nada pues es el primer sumando
		expMatematica(214)<=(others=>'0');
		expMatematica(215)<=(others=>'0');
		expMatematica(216)<=(others=>'0');	
	else -- signo -
		expMatematica(214)<= menos(0);
		expMatematica(215)<= menos(1);
		expMatematica(216)<= menos(2);
	end if;		
	
--coeficiente de x^-3 (posiciones de 12 a 17)
	if salida_teclado(4 downto 0) = "00001" or salida_teclado(4 downto 0) = "11111" then --1
		expMatematica(12)<= uno(0);
		expMatematica(13)<= uno(1);
		expMatematica(14)<= uno(2);
		expMatematica(15)<= uno(3);
		expMatematica(16)<= uno(4);
		expMatematica(17)<= uno(5); 
	elsif salida_teclado(4 downto 0) = "00010" or salida_teclado(4 downto 0) = "11110" then --2
		expMatematica(12)<= dos(0);
		expMatematica(13)<= dos(1);
		expMatematica(14)<= dos(2);
		expMatematica(15)<= dos(3);
		expMatematica(16)<= dos(4);
		expMatematica(17)<= dos(5);
	elsif salida_teclado(4 downto 0) = "00011" or salida_teclado(4 downto 0) = "11101" then --3
		expMatematica(12)<= tres(0);
		expMatematica(13)<= tres(1);
		expMatematica(14)<= tres(2);
		expMatematica(15)<= tres(3);
		expMatematica(16)<= tres(4);
		expMatematica(17)<= tres(5);
	elsif salida_teclado(4 downto 0) = "00100" or salida_teclado(4 downto 0) = "11100" then --4
		expMatematica(12)<= cuatro(0);
		expMatematica(13)<= cuatro(1);
		expMatematica(14)<= cuatro(2);
		expMatematica(15)<= cuatro(3);
		expMatematica(16)<= cuatro(4);
		expMatematica(17)<= cuatro(5);
	elsif salida_teclado(4 downto 0) = "00101" or salida_teclado(4 downto 0) = "11011" then --5
		expMatematica(12)<= cinco(0);
		expMatematica(13)<= cinco(1);
		expMatematica(14)<= cinco(2);
		expMatematica(15)<= cinco(3);
		expMatematica(16)<= cinco(4);
		expMatematica(17)<= cinco(5);
	elsif salida_teclado(4 downto 0) = "00110" or salida_teclado(4 downto 0) = "11010" then --6
		expMatematica(12)<= seis(0);
		expMatematica(13)<= seis(1);
		expMatematica(14)<= seis(2);
		expMatematica(15)<= seis(3);
		expMatematica(16)<= seis(4);
		expMatematica(17)<= seis(5);
	elsif salida_teclado(4 downto 0) = "00111" or salida_teclado(4 downto 0) = "11001" then --7
		expMatematica(12)<= siete(0);
		expMatematica(13)<= siete(1);
		expMatematica(14)<= siete(2);
		expMatematica(15)<= siete(3);
		expMatematica(16)<= siete(4);
		expMatematica(17)<= siete(5);
	elsif salida_teclado(4 downto 0) = "01000" or salida_teclado(4 downto 0) = "11000" then --8
		expMatematica(12)<= ocho(0);
		expMatematica(13)<= ocho(1);
		expMatematica(14)<= ocho(2);
		expMatematica(15)<= ocho(3);
		expMatematica(16)<= ocho(4);
		expMatematica(17)<= ocho(5);
	elsif salida_teclado(4 downto 0) = "01001" or salida_teclado(4 downto 0) = "10111" then --9
		expMatematica(12)<= nueve(0);
		expMatematica(13)<= nueve(1);
		expMatematica(14)<= nueve(2);
		expMatematica(15)<= nueve(3);
		expMatematica(16)<= nueve(4);
		expMatematica(17)<= nueve(5);
	else -- 0
		expMatematica(12)<= cero(0);
		expMatematica(13)<= cero(1);
		expMatematica(14)<= cero(2);
		expMatematica(15)<= cero(3);
		expMatematica(16)<= cero(4);
		expMatematica(17)<= cero(5);
	end if;
	
--coeficiente de x^-2 (posiciones de 35 a 40)
	if salida_teclado(9 downto 5) = "00001" or salida_teclado(9 downto 5) = "11111" then --1
		expMatematica(35)<= uno(0);
		expMatematica(36)<= uno(1);
		expMatematica(37)<= uno(2);
		expMatematica(38)<= uno(3);
		expMatematica(39)<= uno(4);
		expMatematica(40)<= uno(5); 
	elsif salida_teclado(9 downto 5) = "00010" or salida_teclado(9 downto 5) = "11110" then --2
		expMatematica(35)<= dos(0);
		expMatematica(36)<= dos(1);
		expMatematica(37)<= dos(2);
		expMatematica(38)<= dos(3);
		expMatematica(39)<= dos(4);
		expMatematica(40)<= dos(5);
	elsif salida_teclado(9 downto 5) = "00011" or salida_teclado(9 downto 5) = "11101" then --3
		expMatematica(35)<= tres(0);
		expMatematica(36)<= tres(1);
		expMatematica(37)<= tres(2);
		expMatematica(38)<= tres(3);
		expMatematica(39)<= tres(4);
		expMatematica(40)<= tres(5);
	elsif salida_teclado(9 downto 5) = "00100" or salida_teclado(9 downto 5) = "11100" then --4
		expMatematica(35)<= cuatro(0);
		expMatematica(36)<= cuatro(1);
		expMatematica(37)<= cuatro(2);
		expMatematica(38)<= cuatro(3);
		expMatematica(39)<= cuatro(4);
		expMatematica(40)<= cuatro(5);
	elsif salida_teclado(9 downto 5) = "00101" or salida_teclado(9 downto 5) = "11011" then --5
		expMatematica(35)<= cinco(0);
		expMatematica(36)<= cinco(1);
		expMatematica(37)<= cinco(2);
		expMatematica(38)<= cinco(3);
		expMatematica(39)<= cinco(4);
		expMatematica(40)<= cinco(5);
	elsif salida_teclado(9 downto 5) = "00110" or salida_teclado(9 downto 5) = "11010" then --6
		expMatematica(35)<= seis(0);
		expMatematica(36)<= seis(1);
		expMatematica(37)<= seis(2);
		expMatematica(38)<= seis(3);
		expMatematica(39)<= seis(4);
		expMatematica(40)<= seis(5);
	elsif salida_teclado(9 downto 5) = "00111" or salida_teclado(9 downto 5) = "11001" then --7
		expMatematica(35)<= siete(0);
		expMatematica(36)<= siete(1);
		expMatematica(37)<= siete(2);
		expMatematica(38)<= siete(3);
		expMatematica(39)<= siete(4);
		expMatematica(40)<= siete(5);
	elsif salida_teclado(9 downto 5) = "01000" or salida_teclado(9 downto 5) = "11000" then --8
		expMatematica(35)<= ocho(0);
		expMatematica(36)<= ocho(1);
		expMatematica(37)<= ocho(2);
		expMatematica(38)<= ocho(3);
		expMatematica(39)<= ocho(4);
		expMatematica(40)<= ocho(5);
	elsif salida_teclado(9 downto 5) = "01001" or salida_teclado(9 downto 5) = "10111" then --9
		expMatematica(35)<= nueve(0);
		expMatematica(36)<= nueve(1);
		expMatematica(37)<= nueve(2);
		expMatematica(38)<= nueve(3);
		expMatematica(39)<= nueve(4);
		expMatematica(40)<= nueve(5);
	else -- 0
		expMatematica(35)<= cero(0);
		expMatematica(36)<= cero(1);
		expMatematica(37)<= cero(2);
		expMatematica(38)<= cero(3);
		expMatematica(39)<= cero(4);
		expMatematica(40)<= cero(5);
	end if;
	
--coeficiente de x^-1 (posiciones de 56 a 61)
	if salida_teclado(14 downto 10) = "00001" or salida_teclado(14 downto 10) = "11111" then --1
		expMatematica(56)<= uno(0);
		expMatematica(57)<= uno(1);
		expMatematica(58)<= uno(2);
		expMatematica(59)<= uno(3);
		expMatematica(60)<= uno(4);
		expMatematica(61)<= uno(5); 
	elsif salida_teclado(14 downto 10) = "00010" or salida_teclado(14 downto 10) = "11110" then --2
		expMatematica(56)<= dos(0);
		expMatematica(57)<= dos(1);
		expMatematica(58)<= dos(2);
		expMatematica(59)<= dos(3);
		expMatematica(60)<= dos(4);
		expMatematica(61)<= dos(5);
	elsif salida_teclado(14 downto 10) = "00011" or salida_teclado(14 downto 10) = "11101" then --3
		expMatematica(56)<= tres(0);
		expMatematica(57)<= tres(1);
		expMatematica(58)<= tres(2);
		expMatematica(59)<= tres(3);
		expMatematica(60)<= tres(4);
		expMatematica(61)<= tres(5);
	elsif salida_teclado(14 downto 10) = "00100" or salida_teclado(14 downto 10) = "11100" then --4
		expMatematica(56)<= cuatro(0);
		expMatematica(57)<= cuatro(1);
		expMatematica(58)<= cuatro(2);
		expMatematica(59)<= cuatro(3);
		expMatematica(60)<= cuatro(4);
		expMatematica(61)<= cuatro(5);
	elsif salida_teclado(14 downto 10) = "00101" or salida_teclado(14 downto 10) = "11011" then --5
		expMatematica(56)<= cinco(0);
		expMatematica(57)<= cinco(1);
		expMatematica(58)<= cinco(2);
		expMatematica(59)<= cinco(3);
		expMatematica(60)<= cinco(4);
		expMatematica(61)<= cinco(5);
	elsif salida_teclado(14 downto 10) = "00110" or salida_teclado(14 downto 10) = "11010" then --6
		expMatematica(56)<= seis(0);
		expMatematica(57)<= seis(1);
		expMatematica(58)<= seis(2);
		expMatematica(59)<= seis(3);
		expMatematica(60)<= seis(4);
		expMatematica(61)<= seis(5);
	elsif salida_teclado(14 downto 10) = "00111" or salida_teclado(14 downto 10) = "11001" then --7
		expMatematica(56)<= siete(0);
		expMatematica(57)<= siete(1);
		expMatematica(58)<= siete(2);
		expMatematica(59)<= siete(3);
		expMatematica(60)<= siete(4);
		expMatematica(61)<= siete(5);
	elsif salida_teclado(14 downto 10) = "01000" or salida_teclado(14 downto 10) = "11000" then --8
		expMatematica(56)<= ocho(0);
		expMatematica(57)<= ocho(1);
		expMatematica(58)<= ocho(2);
		expMatematica(59)<= ocho(3);
		expMatematica(60)<= ocho(4);
		expMatematica(61)<= ocho(5);
	elsif salida_teclado(14 downto 10) = "01001" or salida_teclado(14 downto 10) = "10111" then --9
		expMatematica(56)<= nueve(0);
		expMatematica(57)<= nueve(1);
		expMatematica(58)<= nueve(2);
		expMatematica(59)<= nueve(3);
		expMatematica(60)<= nueve(4);
		expMatematica(61)<= nueve(5);
	else -- 0
		expMatematica(56)<= cero(0);
		expMatematica(57)<= cero(1);
		expMatematica(58)<= cero(2);
		expMatematica(59)<= cero(3);
		expMatematica(60)<= cero(4);
		expMatematica(61)<= cero(5);
	end if;
	
--coeficiente de constante(posiciones de 67 a 72)
	if salida_teclado(19 downto 15) = "00001" or salida_teclado(19 downto 15) = "11111" then --1
		expMatematica(67)<= uno(0);
		expMatematica(68)<= uno(1);
		expMatematica(69)<= uno(2);
		expMatematica(70)<= uno(3);
		expMatematica(71)<= uno(4);
		expMatematica(72)<= uno(5); 
	elsif salida_teclado(19 downto 15) = "00010" or salida_teclado(19 downto 15) = "11110" then --2
		expMatematica(67)<= dos(0);
		expMatematica(68)<= dos(1);
		expMatematica(69)<= dos(2);
		expMatematica(70)<= dos(3);
		expMatematica(71)<= dos(4);
		expMatematica(72)<= dos(5);
	elsif salida_teclado(19 downto 15) = "00011" or salida_teclado(19 downto 15) = "11101" then --3
		expMatematica(67)<= tres(0);
		expMatematica(68)<= tres(1);
		expMatematica(69)<= tres(2);
		expMatematica(70)<= tres(3);
		expMatematica(71)<= tres(4);
		expMatematica(72)<= tres(5);
	elsif salida_teclado(19 downto 15) = "00100" or salida_teclado(19 downto 15) = "11100" then --4
		expMatematica(67)<= cuatro(0);
		expMatematica(68)<= cuatro(1);
		expMatematica(69)<= cuatro(2);
		expMatematica(70)<= cuatro(3);
		expMatematica(71)<= cuatro(4);
		expMatematica(72)<= cuatro(5);
	elsif salida_teclado(19 downto 15) = "00101" or salida_teclado(19 downto 15) = "11011" then --5
		expMatematica(67)<= cinco(0);
		expMatematica(68)<= cinco(1);
		expMatematica(69)<= cinco(2);
		expMatematica(70)<= cinco(3);
		expMatematica(71)<= cinco(4);
		expMatematica(72)<= cinco(5);
	elsif salida_teclado(19 downto 15) = "00110" or salida_teclado(19 downto 15) = "11010" then --6
		expMatematica(67)<= seis(0);
		expMatematica(68)<= seis(1);
		expMatematica(69)<= seis(2);
		expMatematica(70)<= seis(3);
		expMatematica(71)<= seis(4);
		expMatematica(72)<= seis(5);
	elsif salida_teclado(19 downto 15) = "00111" or salida_teclado(19 downto 15) = "11001" then --7
		expMatematica(67)<= siete(0);
		expMatematica(68)<= siete(1);
		expMatematica(69)<= siete(2);
		expMatematica(70)<= siete(3);
		expMatematica(71)<= siete(4);
		expMatematica(72)<= siete(5);
	elsif salida_teclado(19 downto 15) = "01000" or salida_teclado(19 downto 15) = "11000" then --8
		expMatematica(67)<= ocho(0);
		expMatematica(68)<= ocho(1);
		expMatematica(69)<= ocho(2);
		expMatematica(70)<= ocho(3);
		expMatematica(71)<= ocho(4);
		expMatematica(72)<= ocho(5);
	elsif salida_teclado(19 downto 15) = "01001" or salida_teclado(19 downto 15) = "10111" then --9
		expMatematica(67)<= nueve(0);
		expMatematica(68)<= nueve(1);
		expMatematica(69)<= nueve(2);
		expMatematica(70)<= nueve(3);
		expMatematica(71)<= nueve(4);
		expMatematica(72)<= nueve(5);
	else -- 0
		expMatematica(67)<= cero(0);
		expMatematica(68)<= cero(1);
		expMatematica(69)<= cero(2);
		expMatematica(70)<= cero(3);
		expMatematica(71)<= cero(4);
		expMatematica(72)<= cero(5);
	end if;

--coeficiente de x(posiciones de 84 a 89)
	if salida_teclado(24 downto 20) = "00001" or salida_teclado(24 downto 20) = "11111" then --1
		expMatematica(84)<= uno(0);
		expMatematica(85)<= uno(1);
		expMatematica(86)<= uno(2);
		expMatematica(87)<= uno(3);
		expMatematica(88)<= uno(4);
		expMatematica(89)<= uno(5); 
	elsif salida_teclado(24 downto 20) = "00010" or salida_teclado(24 downto 20) = "11110" then --2
		expMatematica(84)<= dos(0);
		expMatematica(85)<= dos(1);
		expMatematica(86)<= dos(2);
		expMatematica(87)<= dos(3);
		expMatematica(88)<= dos(4);
		expMatematica(89)<= dos(5);
	elsif salida_teclado(24 downto 20) = "00011" or salida_teclado(24 downto 20) = "11101" then --3
		expMatematica(84)<= tres(0);
		expMatematica(85)<= tres(1);
		expMatematica(86)<= tres(2);
		expMatematica(87)<= tres(3);
		expMatematica(88)<= tres(4);
		expMatematica(89)<= tres(5);
	elsif salida_teclado(24 downto 20) = "00100" or salida_teclado(24 downto 20) = "11100" then --4
		expMatematica(84)<= cuatro(0);
		expMatematica(85)<= cuatro(1);
		expMatematica(86)<= cuatro(2);
		expMatematica(87)<= cuatro(3);
		expMatematica(88)<= cuatro(4);
		expMatematica(89)<= cuatro(5);
	elsif salida_teclado(24 downto 20) = "00101" or salida_teclado(24 downto 20) = "11011" then --5
		expMatematica(84)<= cinco(0);
		expMatematica(85)<= cinco(1);
		expMatematica(86)<= cinco(2);
		expMatematica(87)<= cinco(3);
		expMatematica(88)<= cinco(4);
		expMatematica(89)<= cinco(5);
	elsif salida_teclado(24 downto 20) = "00110" or salida_teclado(24 downto 20) = "11010" then --6
		expMatematica(84)<= seis(0);
		expMatematica(85)<= seis(1);
		expMatematica(86)<= seis(2);
		expMatematica(87)<= seis(3);
		expMatematica(88)<= seis(4);
		expMatematica(89)<= seis(5);
	elsif salida_teclado(24 downto 20) = "00111" or salida_teclado(24 downto 20) = "11001" then --7
		expMatematica(84)<= siete(0);
		expMatematica(85)<= siete(1);
		expMatematica(86)<= siete(2);
		expMatematica(87)<= siete(3);
		expMatematica(88)<= siete(4);
		expMatematica(89)<= siete(5);
	elsif salida_teclado(24 downto 20) = "01000" or salida_teclado(24 downto 20) = "11000" then --8
		expMatematica(84)<= ocho(0);
		expMatematica(85)<= ocho(1);
		expMatematica(86)<= ocho(2);
		expMatematica(87)<= ocho(3);
		expMatematica(88)<= ocho(4);
		expMatematica(89)<= ocho(5);
	elsif salida_teclado(24 downto 20) = "01001" or salida_teclado(24 downto 20) = "10111" then --9
		expMatematica(84)<= nueve(0);
		expMatematica(85)<= nueve(1);
		expMatematica(86)<= nueve(2);
		expMatematica(87)<= nueve(3);
		expMatematica(88)<= nueve(4);
		expMatematica(89)<= nueve(5);
	else -- 0
		expMatematica(84)<= cero(0);
		expMatematica(85)<= cero(1);
		expMatematica(86)<= cero(2);
		expMatematica(87)<= cero(3);
		expMatematica(88)<= cero(4);
		expMatematica(89)<= cero(5);
	end if;

--coeficiente de x^2(posiciones de 105 a 110)
	if salida_teclado(29 downto 25) = "00001" or salida_teclado(29 downto 25) = "11111" then --1
		expMatematica(105)<= uno(0);
		expMatematica(106)<= uno(1);
		expMatematica(107)<= uno(2);
		expMatematica(108)<= uno(3);
		expMatematica(109)<= uno(4);
		expMatematica(110)<= uno(5); 
	elsif salida_teclado(29 downto 25) = "00010" or salida_teclado(29 downto 25) = "11110" then --2
		expMatematica(105)<= dos(0);
		expMatematica(106)<= dos(1);
		expMatematica(107)<= dos(2);
		expMatematica(108)<= dos(3);
		expMatematica(109)<= dos(4);
		expMatematica(110)<= dos(5);
	elsif salida_teclado(29 downto 25) = "00011" or salida_teclado(29 downto 25) = "11101" then --3
		expMatematica(105)<= tres(0);
		expMatematica(106)<= tres(1);
		expMatematica(107)<= tres(2);
		expMatematica(108)<= tres(3);
		expMatematica(109)<= tres(4);
		expMatematica(110)<= tres(5);
	elsif salida_teclado(29 downto 25) = "00100" or salida_teclado(29 downto 25) = "11100" then --4
		expMatematica(105)<= cuatro(0);
		expMatematica(106)<= cuatro(1);
		expMatematica(107)<= cuatro(2);
		expMatematica(108)<= cuatro(3);
		expMatematica(109)<= cuatro(4);
		expMatematica(110)<= cuatro(5);
	elsif salida_teclado(29 downto 25) = "00101" or salida_teclado(29 downto 25) = "11011" then --5
		expMatematica(105)<= cinco(0);
		expMatematica(106)<= cinco(1);
		expMatematica(107)<= cinco(2);
		expMatematica(108)<= cinco(3);
		expMatematica(109)<= cinco(4);
		expMatematica(110)<= cinco(5);
	elsif salida_teclado(29 downto 25) = "00110" or salida_teclado(29 downto 25) = "11010" then --6
		expMatematica(105)<= seis(0);
		expMatematica(106)<= seis(1);
		expMatematica(107)<= seis(2);
		expMatematica(108)<= seis(3);
		expMatematica(109)<= seis(4);
		expMatematica(110)<= seis(5);
	elsif salida_teclado(29 downto 25) = "00111" or salida_teclado(29 downto 25) = "11001" then --7
		expMatematica(105)<= siete(0);
		expMatematica(106)<= siete(1);
		expMatematica(107)<= siete(2);
		expMatematica(108)<= siete(3);
		expMatematica(109)<= siete(4);
		expMatematica(110)<= siete(5);
	elsif salida_teclado(29 downto 25) = "01000" or salida_teclado(29 downto 25) = "11000" then --8
		expMatematica(105)<= ocho(0);
		expMatematica(106)<= ocho(1);
		expMatematica(107)<= ocho(2);
		expMatematica(108)<= ocho(3);
		expMatematica(109)<= ocho(4);
		expMatematica(110)<= ocho(5);
	elsif salida_teclado(29 downto 25) = "01001" or salida_teclado(29 downto 25) = "10111" then --9
		expMatematica(105)<= nueve(0);
		expMatematica(106)<= nueve(1);
		expMatematica(107)<= nueve(2);
		expMatematica(108)<= nueve(3);
		expMatematica(109)<= nueve(4);
		expMatematica(110)<= nueve(5);
	else -- 0
		expMatematica(105)<= cero(0);
		expMatematica(106)<= cero(1);
		expMatematica(107)<= cero(2);
		expMatematica(108)<= cero(3);
		expMatematica(109)<= cero(4);
		expMatematica(110)<= cero(5);
	end if;
--coeficiente de x^3 (posiciones de 126 a 131)
	if salida_teclado(34 downto 30) = "00001" or salida_teclado(34 downto 30) = "11111" then --1
		expMatematica(126)<= uno(0);
		expMatematica(127)<= uno(1);
		expMatematica(128)<= uno(2);
		expMatematica(129)<= uno(3);
		expMatematica(130)<= uno(4);
		expMatematica(131)<= uno(5); 
	elsif salida_teclado(34 downto 30) = "00010" or salida_teclado(34 downto 30) = "11110" then --2
		expMatematica(126)<= dos(0);
		expMatematica(127)<= dos(1);
		expMatematica(128)<= dos(2);
		expMatematica(129)<= dos(3);
		expMatematica(130)<= dos(4);
		expMatematica(131)<= dos(5);
	elsif salida_teclado(34 downto 30) = "00011" or salida_teclado(34 downto 30) = "11101" then --3
		expMatematica(126)<= tres(0);
		expMatematica(127)<= tres(1);
		expMatematica(128)<= tres(2);
		expMatematica(129)<= tres(3);
		expMatematica(130)<= tres(4);
		expMatematica(131)<= tres(5);
	elsif salida_teclado(34 downto 30) = "00100" or salida_teclado(34 downto 30) = "11100" then --4
		expMatematica(126)<= cuatro(0);
		expMatematica(127)<= cuatro(1);
		expMatematica(128)<= cuatro(2);
		expMatematica(129)<= cuatro(3);
		expMatematica(130)<= cuatro(4);
		expMatematica(131)<= cuatro(5);
	elsif salida_teclado(34 downto 30) = "00101" or salida_teclado(34 downto 30) = "11011" then --5
		expMatematica(126)<= cinco(0);
		expMatematica(127)<= cinco(1);
		expMatematica(128)<= cinco(2);
		expMatematica(129)<= cinco(3);
		expMatematica(130)<= cinco(4);
		expMatematica(131)<= cinco(5);
	elsif salida_teclado(34 downto 30) = "00110" or salida_teclado(34 downto 30) = "11010" then --6
		expMatematica(126)<= seis(0);
		expMatematica(127)<= seis(1);
		expMatematica(128)<= seis(2);
		expMatematica(129)<= seis(3);
		expMatematica(130)<= seis(4);
		expMatematica(131)<= seis(5);
	elsif salida_teclado(34 downto 30) = "00111" or salida_teclado(34 downto 30) = "11001" then --7
		expMatematica(126)<= siete(0);
		expMatematica(127)<= siete(1);
		expMatematica(128)<= siete(2);
		expMatematica(129)<= siete(3);
		expMatematica(130)<= siete(4);
		expMatematica(131)<= siete(5);
	elsif salida_teclado(34 downto 30) = "01000" or salida_teclado(34 downto 30) = "11000" then --8
		expMatematica(126)<= ocho(0);
		expMatematica(127)<= ocho(1);
		expMatematica(128)<= ocho(2);
		expMatematica(129)<= ocho(3);
		expMatematica(130)<= ocho(4);
		expMatematica(131)<= ocho(5);
	elsif salida_teclado(34 downto 30) = "01001" or salida_teclado(34 downto 30) = "10111" then --9
		expMatematica(126)<= nueve(0);
		expMatematica(127)<= nueve(1);
		expMatematica(128)<= nueve(2);
		expMatematica(129)<= nueve(3);
		expMatematica(130)<= nueve(4);
		expMatematica(131)<= nueve(5);
	else -- 0
		expMatematica(126)<= cero(0);
		expMatematica(127)<= cero(1);
		expMatematica(128)<= cero(2);
		expMatematica(129)<= cero(3);
		expMatematica(130)<= cero(4);
		expMatematica(131)<= cero(5);
	end if;
	
--coeficiente de cos(posiciones de 155 a 160)
	if salida_teclado(39 downto 35) = "00001" or salida_teclado(39 downto 35) = "11111" then --1
		expMatematica(155)<= uno(0);
		expMatematica(156)<= uno(1);
		expMatematica(157)<= uno(2);
		expMatematica(158)<= uno(3);
		expMatematica(159)<= uno(4);
		expMatematica(160)<= uno(5); 
	elsif salida_teclado(39 downto 35) = "00010" or salida_teclado(39 downto 35) = "11110" then --2
		expMatematica(155)<= dos(0);
		expMatematica(156)<= dos(1);
		expMatematica(157)<= dos(2);
		expMatematica(158)<= dos(3);
		expMatematica(159)<= dos(4);
		expMatematica(160)<= dos(5);
	elsif salida_teclado(39 downto 35) = "00011" or salida_teclado(39 downto 35) = "11101" then --3
		expMatematica(155)<= tres(0);
		expMatematica(156)<= tres(1);
		expMatematica(157)<= tres(2);
		expMatematica(158)<= tres(3);
		expMatematica(159)<= tres(4);
		expMatematica(160)<= tres(5);
	elsif salida_teclado(39 downto 35) = "00100" or salida_teclado(39 downto 35) = "11100" then --4
		expMatematica(155)<= cuatro(0);
		expMatematica(156)<= cuatro(1);
		expMatematica(157)<= cuatro(2);
		expMatematica(158)<= cuatro(3);
		expMatematica(159)<= cuatro(4);
		expMatematica(160)<= cuatro(5);
	elsif salida_teclado(39 downto 35) = "00101" or salida_teclado(39 downto 35) = "11011" then --5
		expMatematica(155)<= cinco(0);
		expMatematica(156)<= cinco(1);
		expMatematica(157)<= cinco(2);
		expMatematica(158)<= cinco(3);
		expMatematica(159)<= cinco(4);
		expMatematica(160)<= cinco(5);
	elsif salida_teclado(39 downto 35) = "00110" or salida_teclado(39 downto 35) = "11010" then --6
		expMatematica(155)<= seis(0);
		expMatematica(156)<= seis(1);
		expMatematica(157)<= seis(2);
		expMatematica(158)<= seis(3);
		expMatematica(159)<= seis(4);
		expMatematica(160)<= seis(5);
	elsif salida_teclado(39 downto 35) = "00111" or salida_teclado(39 downto 35) = "11001" then --7
		expMatematica(155)<= siete(0);
		expMatematica(156)<= siete(1);
		expMatematica(157)<= siete(2);
		expMatematica(158)<= siete(3);
		expMatematica(159)<= siete(4);
		expMatematica(160)<= siete(5);
	elsif salida_teclado(39 downto 35) = "01000" or salida_teclado(39 downto 35) = "11000" then --8
		expMatematica(155)<= ocho(0);
		expMatematica(156)<= ocho(1);
		expMatematica(157)<= ocho(2);
		expMatematica(158)<= ocho(3);
		expMatematica(159)<= ocho(4);
		expMatematica(160)<= ocho(5);
	elsif salida_teclado(39 downto 35) = "01001" or salida_teclado(39 downto 35) = "10111" then --9
		expMatematica(155)<= nueve(0);
		expMatematica(156)<= nueve(1);
		expMatematica(157)<= nueve(2);
		expMatematica(158)<= nueve(3);
		expMatematica(159)<= nueve(4);
		expMatematica(160)<= nueve(5);
	else -- 0
		expMatematica(155)<= cero(0);
		expMatematica(156)<= cero(1);
		expMatematica(157)<= cero(2);
		expMatematica(158)<= cero(3);
		expMatematica(159)<= cero(4);
		expMatematica(160)<= cero(5);
	end if;
	
--coeficiente de sen(posiciones de 184 a 189)
	if salida_teclado(44 downto 40) = "00001" or salida_teclado(44 downto 40) = "11111" then --1
		expMatematica(184)<= uno(0);
		expMatematica(185)<= uno(1);
		expMatematica(186)<= uno(2);
		expMatematica(187)<= uno(3);
		expMatematica(188)<= uno(4);
		expMatematica(189)<= uno(5); 
	elsif salida_teclado(44 downto 40) = "00010" or salida_teclado(44 downto 40) = "11110" then --2
		expMatematica(184)<= dos(0);
		expMatematica(185)<= dos(1);
		expMatematica(186)<= dos(2);
		expMatematica(187)<= dos(3);
		expMatematica(188)<= dos(4);
		expMatematica(189)<= dos(5);
	elsif salida_teclado(44 downto 40) = "00011" or salida_teclado(44 downto 40) = "11101" then --3
		expMatematica(184)<= tres(0);
		expMatematica(185)<= tres(1);
		expMatematica(186)<= tres(2);
		expMatematica(187)<= tres(3);
		expMatematica(188)<= tres(4);
		expMatematica(189)<= tres(5);
	elsif salida_teclado(44 downto 40) = "00100" or salida_teclado(44 downto 40) = "11100" then --4
		expMatematica(184)<= cuatro(0);
		expMatematica(185)<= cuatro(1);
		expMatematica(186)<= cuatro(2);
		expMatematica(187)<= cuatro(3);
		expMatematica(188)<= cuatro(4);
		expMatematica(189)<= cuatro(5);
	elsif salida_teclado(44 downto 40) = "00101" or salida_teclado(44 downto 40) = "11011" then --5
		expMatematica(184)<= cinco(0);
		expMatematica(185)<= cinco(1);
		expMatematica(186)<= cinco(2);
		expMatematica(187)<= cinco(3);
		expMatematica(188)<= cinco(4);
		expMatematica(189)<= cinco(5);
	elsif salida_teclado(44 downto 40) = "00110" or salida_teclado(44 downto 40) = "11010" then --6
		expMatematica(184)<= seis(0);
		expMatematica(185)<= seis(1);
		expMatematica(186)<= seis(2);
		expMatematica(187)<= seis(3);
		expMatematica(188)<= seis(4);
		expMatematica(189)<= seis(5);
	elsif salida_teclado(44 downto 40) = "00111" or salida_teclado(44 downto 40) = "11001" then --7
		expMatematica(184)<= siete(0);
		expMatematica(185)<= siete(1);
		expMatematica(186)<= siete(2);
		expMatematica(187)<= siete(3);
		expMatematica(188)<= siete(4);
		expMatematica(189)<= siete(5);
	elsif salida_teclado(44 downto 40) = "01000" or salida_teclado(44 downto 40) = "11000" then --8
		expMatematica(184)<= ocho(0);
		expMatematica(185)<= ocho(1);
		expMatematica(186)<= ocho(2);
		expMatematica(187)<= ocho(3);
		expMatematica(188)<= ocho(4);
		expMatematica(189)<= ocho(5);
	elsif salida_teclado(44 downto 40) = "01001" or salida_teclado(44 downto 40) = "10111" then --9
		expMatematica(184)<= nueve(0);
		expMatematica(185)<= nueve(1);
		expMatematica(186)<= nueve(2);
		expMatematica(187)<= nueve(3);
		expMatematica(188)<= nueve(4);
		expMatematica(189)<= nueve(5);
	else -- 0
		expMatematica(184)<= cero(0);
		expMatematica(185)<= cero(1);
		expMatematica(186)<= cero(2);
		expMatematica(187)<= cero(3);
		expMatematica(188)<= cero(4);
		expMatematica(189)<= cero(5);
	end if;
	
--coeficiente de log(posiciones de 207 a 212)
	if salida_teclado(49 downto 45) = "00001" or salida_teclado(49 downto 45) = "11111" then --1
		expMatematica(207)<= uno(0);
		expMatematica(208)<= uno(1);
		expMatematica(209)<= uno(2);
		expMatematica(210)<= uno(3);
		expMatematica(211)<= uno(4);
		expMatematica(212)<= uno(5); 
	elsif salida_teclado(49 downto 45) = "00010" or salida_teclado(49 downto 45) = "11110" then --2
		expMatematica(207)<= dos(0);
		expMatematica(208)<= dos(1);
		expMatematica(209)<= dos(2);
		expMatematica(210)<= dos(3);
		expMatematica(211)<= dos(4);
		expMatematica(212)<= dos(5);
	elsif salida_teclado(49 downto 45) = "00011" or salida_teclado(49 downto 45) = "11101" then --3
		expMatematica(207)<= tres(0);
		expMatematica(208)<= tres(1);
		expMatematica(209)<= tres(2);
		expMatematica(210)<= tres(3);
		expMatematica(211)<= tres(4);
		expMatematica(212)<= tres(5);
	elsif salida_teclado(49 downto 45) = "00100" or salida_teclado(49 downto 45) = "11100" then --4
		expMatematica(207)<= cuatro(0);
		expMatematica(208)<= cuatro(1);
		expMatematica(209)<= cuatro(2);
		expMatematica(210)<= cuatro(3);
		expMatematica(211)<= cuatro(4);
		expMatematica(212)<= cuatro(5);
	elsif salida_teclado(49 downto 45) = "00101" or salida_teclado(49 downto 45) = "11011" then --5
		expMatematica(207)<= cinco(0);
		expMatematica(208)<= cinco(1);
		expMatematica(209)<= cinco(2);
		expMatematica(210)<= cinco(3);
		expMatematica(211)<= cinco(4);
		expMatematica(212)<= cinco(5);
	elsif salida_teclado(49 downto 45) = "00110" or salida_teclado(49 downto 45) = "11010" then --6
		expMatematica(207)<= seis(0);
		expMatematica(208)<= seis(1);
		expMatematica(209)<= seis(2);
		expMatematica(210)<= seis(3);
		expMatematica(211)<= seis(4);
		expMatematica(212)<= seis(5);
	elsif salida_teclado(49 downto 45) = "00111" or salida_teclado(49 downto 45) = "11001" then --7
		expMatematica(207)<= siete(0);
		expMatematica(208)<= siete(1);
		expMatematica(209)<= siete(2);
		expMatematica(210)<= siete(3);
		expMatematica(211)<= siete(4);
		expMatematica(212)<= siete(5);
	elsif salida_teclado(49 downto 45) = "01000" or salida_teclado(49 downto 45) = "11000" then --8
		expMatematica(207)<= ocho(0);
		expMatematica(208)<= ocho(1);
		expMatematica(209)<= ocho(2);
		expMatematica(210)<= ocho(3);
		expMatematica(211)<= ocho(4);
		expMatematica(212)<= ocho(5);
	elsif salida_teclado(49 downto 45) = "01001" or salida_teclado(49 downto 45) = "10111" then --9
		expMatematica(207)<= nueve(0);
		expMatematica(208)<= nueve(1);
		expMatematica(209)<= nueve(2);
		expMatematica(210)<= nueve(3);
		expMatematica(211)<= nueve(4);
		expMatematica(212)<= nueve(5);
	else -- 0
		expMatematica(207)<= cero(0);
		expMatematica(208)<= cero(1);
		expMatematica(209)<= cero(2);
		expMatematica(210)<= cero(3);
		expMatematica(211)<= cero(4);
		expMatematica(212)<= cero(5);
	end if;
	
end process expMatCal;

--ESPACIOS (1 columnas de ceros)
--antes de la X o el sen o cos
expMatematica(11)<=(others=>'0');
expMatematica(34)<=(others=>'0');
expMatematica(55)<=(others=>'0');
expMatematica(83)<=(others=>'0');
expMatematica(104)<=(others=>'0');
expMatematica(125)<=(others=>'0');
expMatematica(154)<=(others=>'0');
expMatematica(183)<=(others=>'0');
--antes del número
expMatematica(18)<=(others=>'0');
expMatematica(41)<=(others=>'0');
expMatematica(62)<=(others=>'0');
expMatematica(73)<=(others=>'0');
expMatematica(90)<=(others=>'0');
expMatematica(111)<=(others=>'0');
expMatematica(132)<=(others=>'0');
expMatematica(161)<=(others=>'0');
expMatematica(190)<=(others=>'0');
--antes del signo (menos en el primero)
expMatematica(22)<=(others=>'0');
expMatematica(45)<=(others=>'0');
expMatematica(66)<=(others=>'0');
expMatematica(77)<=(others=>'0');
expMatematica(94)<=(others=>'0');
expMatematica(115)<=(others=>'0');
expMatematica(136)<=(others=>'0');
expMatematica(165)<=(others=>'0');
--para el exponente
expMatematica(3)<=(others=>'0');
expMatematica(5)<=(others=>'0');
expMatematica(26)<=(others=>'0');
expMatematica(28)<=(others=>'0');
expMatematica(47)<=(others=>'0');
expMatematica(49)<=(others=>'0');
expMatematica(98)<=(others=>'0');
expMatematica(119)<=(others=>'0');
--dentro del sen y cos
expMatematica(142)<=(others=>'0');
expMatematica(171)<=(others=>'0');
expMatematica(148)<=(others=>'0');
expMatematica(177)<=(others=>'0');
--del log
expMatematica(194)<=(others=>'0');
expMatematica(200)<=(others=>'0');
expMatematica(206)<=(others=>'0');
expMatematica(213)<=(others=>'0');

-- Las posiciones mayores que anchoExp no se usan
expMatematica(anchoExp+1 to 255)<=(others=>"00000000000");
end Behavioral;

