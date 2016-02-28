----------------------------------------------------------------------------------
-- Company: Nameless2
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    13:10:11 02/26/2014 
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
--use work.tipos.all


entity numero is
	port(
		clk: in std_logic;
		s: in std_logic_vector(20 downto 0);
      addr : in std_logic_vector(5 downto 0);
      do : out std_logic_vector(0 to 9)
	);
end numero;

architecture Behavioral of numero is
	constant anchoExp: integer:=216;
	type matriz is array(0 to 63) of  std_logic_vector(9 downto 0);
	signal num: matriz;
	signal miInt, miInt1, miInt2,  miInt3, tuInt, tuInt1, tuInt2: std_logic_vector(9 downto 0);
	signal ultraAux: std_logic_vector(20 downto 0);
	type coeficiente is array (0 to 5) of std_logic_vector(9 downto 0);
	constant nada: coeficiente:= 	((others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'), (others=>'0'));
	constant cero: coeficiente:= 	("1111111111", "1111111111", "1100000011", "1100000011", "1111111111", "1111111111");
	constant uno: coeficiente:=  	((others=>'0'), (others=>'0'), "1111111111", "1111111111", (others=>'0'), (others=>'0'));
	constant dos: coeficiente:=  	("1100111111", "1100111111", "1100110011", "1100110011", "1111110011", "1111110011");
	constant tres: coeficiente:= 	("1100000011", "1100110011", "1100110011", "1100110011", "1111111111", "1111111111");
	constant cuatro: coeficiente:=	("1111110000", "1111110000", "0000110000", "0000110000", "1111111111", "1111111111");
	constant cinco: coeficiente:= 	("1111110011", "1111110011", "1100110011", "1100110011", "1100111111", "1100111111");
	constant seis: coeficiente:= 	("1111111111", "1111111111", "1100110011", "1100110011", "1100111111", "1100111111");
	constant siete: coeficiente:=	("1100000000", "1100000000", "1100110000", "1111111111", "1111111111", "0000110000");
	constant ocho: coeficiente:= 	("1111111111", "1111111111", "1100110011", "1100110011", "1111111111", "1111111111");
	constant nueve: coeficiente:= 	("1111110000", "1111110000", "1100110000", "1100110000", "1111111111", "1111111111");
	constant medioInf: coeficiente:= ("0000100000", "0011011000", "0100000100", "0100000100", "0010001000", "0001010000");
begin
--OBTENER TROZO DE LA EXPRESIÓN PEDIDO
expPedida: process (clk)
	begin
		if rising_edge(clk) then
			do <= num(conv_integer(addr));
      end if;	
end process expPedida;

--EXPRESIÓN

--ESPACIOS (1 columna de ceros)
num(3)<=(others=>'0');
num(17)<=(others=>'0');
num(24)<=(others=>'0');
num(31)<=(others=>'0');
num(34)<=(others=>'0');
num(41)<=(others=>'0');
num(48)<=(others=>'0');

ultraAux <= 0-s;
calculo: process(s, ultraAux)
begin
--SIGNO
	if s(20) = '0' then -- si es + no se muestra nada pues es el primer sumando
		num(0)<=(others=>'0');
		num(1)<=(others=>'0');
		num(2)<=(others=>'0');	
		miInt <= s(19 downto 10);
		tuInt <= s(9 downto 0);
	else -- signo -
		num(0)<="0000110000";
		num(1)<="0000110000";
		num(2)<="0000110000";
		miInt <= ultraAux(19 downto 10);
		tuInt <= ultraAux(9 downto 0);
	end if;	
end process calculo;

calcula: process(miInt, s)
begin
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(4)<= medioInf(0);
		num(5)<= medioInf(1);
		num(6)<= medioInf(2);
		num(7)<= medioInf(3);
		num(8)<= medioInf(4);
		num(9)<= medioInf(5);
		miInt1 <= miInt;
	--El mayor numero que pueden dar en valor absoluto es 1024
	elsif miInt >= 1000 then --primer numero un 1
		num(4)<= uno(0);
		num(5)<= uno(1);
		num(6)<= uno(2);
		num(7)<= uno(3);
		num(8)<= uno(4);
		num(9)<= uno(5);
		miInt1 <= miInt -1000;
	else --primer numero es un cero asi que no lo pintamos
		num(4)<= nada(0);
		num(5)<= nada(1);
		num(6)<= nada(2);
		num(7)<= nada(3);
		num(8)<= nada(4);
		num(9)<= nada(5);
		miInt1 <= miInt;
	end if;
	
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(10)<="0000100000";
		-- NO PUNTO
		num(32)<=(others=>'0');
		num(33)<=(others=>'0');
	else
		num(10)<=(others=>'0');
		--PUNTO
		num(32)<="0000001111";
		num(33)<="0000001111";
	end if;
end process calcula;

calcula1: process(miInt1, s, miInt)
begin
	--El mayor numero que puede llegar es 900
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(11)<= medioInf(5);
		num(12)<= medioInf(4);
		num(13)<= medioInf(3);
		num(14)<= medioInf(2);
		num(15)<= medioInf(1);
		num(16)<= medioInf(0);
		miInt2 <= miInt1;
	elsif miInt1 >= 900 then --segundo numero un 9
		num(11)<= nueve(0);
		num(12)<= nueve(1);
		num(13)<= nueve(2);
		num(14)<= nueve(3);
		num(15)<= nueve(4);
		num(16)<= nueve(5);
		miInt2 <= miInt1 - 900;
	elsif miInt1 >= 800 then --segundo numero un 8
		num(11)<= ocho(0);
		num(12)<= ocho(1);
		num(13)<= ocho(2);
		num(14)<= ocho(3);
		num(15)<= ocho(4);
		num(16)<= ocho(5);
		miInt2 <= miInt1 - 800;
	elsif miInt1 >= 700 then --segundo numero un 7
		num(11)<= siete(0);
		num(12)<= siete(1);
		num(13)<= siete(2);
		num(14)<= siete(3);
		num(15)<= siete(4);
		num(16)<= siete(5);
		miInt2 <= miInt1 - 700;
	elsif miInt1 >= 600 then --segundo numero un 6
		num(11)<= seis(0);
		num(12)<= seis(1);
		num(13)<= seis(2);
		num(14)<= seis(3);
		num(15)<= seis(4);
		num(16)<= seis(5);
		miInt2 <= miInt1 - 600;
	elsif miInt1 >= 500 then --segundo numero un 5
		num(11)<= cinco(0);
		num(12)<= cinco(1);
		num(13)<= cinco(2);
		num(14)<= cinco(3);
		num(15)<= cinco(4);
		num(16)<= cinco(5);
		miInt2 <= miInt1 - 500;
	elsif miInt1 >= 400 then --segundo numero un 4
		num(11)<= cuatro(0);
		num(12)<= cuatro(1);
		num(13)<= cuatro(2);
		num(14)<= cuatro(3);
		num(15)<= cuatro(4);
		num(16)<= cuatro(5);
		miInt2 <= miInt1 - 400;
	elsif miInt1 >= 300 then --segundo numero un 3
		num(11)<= tres(0);
		num(12)<= tres(1);
		num(13)<= tres(2);
		num(14)<= tres(3);
		num(15)<= tres(4);
		num(16)<= tres(5);
		miInt2 <= miInt1 - 300;
	elsif miInt1 >= 200 then --segundo numero un 2
		num(11)<= dos(0);
		num(12)<= dos(1);
		num(13)<= dos(2);
		num(14)<= dos(3);
		num(15)<= dos(4);
		num(16)<= dos(5);
		miInt2 <= miInt1 - 200;
	elsif miInt1 >= 100 then --segundo numero un 1
		num(11)<= uno(0);
		num(12)<= uno(1);
		num(13)<= uno(2);
		num(14)<= uno(3);
		num(15)<= uno(4);
		num(16)<= uno(5);
		miInt2 <= miInt1 - 100;
	elsif miInt >= 1000 then -- segundo numero es 0 pero el primero no
		num(11)<= cero(0);
		num(12)<= cero(1);
		num(13)<= cero(2);
		num(14)<= cero(3);
		num(15)<= cero(4);
		num(16)<= cero(5);
		miInt2 <= miInt1;
	else -- primer y segundo numero son 0 asi que no lo pintamos
		num(11)<= nada(0);
		num(12)<= nada(1);
		num(13)<= nada(2);
		num(14)<= nada(3);
		num(15)<= nada(4);
		num(16)<= nada(5);
		miInt2 <= miInt1;
	end if;
end process calcula1;

calcula2: process(miInt2, s,miInt, miInt1)
begin
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(18)<= (others=>'0');
		num(19)<= (others=>'0');
		num(20)<= (others=>'0');
		num(21)<= (others=>'0');
		num(22)<= (others=>'0');
		num(23)<= (others=>'0');
		miInt3 <= miInt2;
	--El mayor numero que puede llegar es 90
	elsif miInt2 >= 90 then --tercer numero un 9
		num(18)<= nueve(0);
		num(19)<= nueve(1);
		num(20)<= nueve(2);
		num(21)<= nueve(3);
		num(22)<= nueve(4);
		num(23)<= nueve(5);
		miInt3 <= miInt2 - 90;
	elsif miInt2 >= 80 then --tercer numero un 8
		num(18)<= ocho(0);
		num(19)<= ocho(1);
		num(20)<= ocho(2);
		num(21)<= ocho(3);
		num(22)<= ocho(4);
		num(23)<= ocho(5);
		miInt3 <= miInt2 - 80;
	elsif miInt2 >= 70 then --tercer numero un 7
		num(18)<= siete(0);
		num(19)<= siete(1);
		num(20)<= siete(2);
		num(21)<= siete(3);
		num(22)<= siete(4);
		num(23)<= siete(5);
		miInt3 <= miInt2 - 70;
	elsif miInt2 >= 60 then --tercer numero un 6
		num(18)<= seis(0);
		num(19)<= seis(1);
		num(20)<= seis(2);
		num(21)<= seis(3);
		num(22)<= seis(4);
		num(23)<= seis(5);
		miInt3 <= miInt2 - 60;
	elsif miInt2 >= 50 then --tercer numero un 5
		num(18)<= cinco(0);
		num(19)<= cinco(1);
		num(20)<= cinco(2);
		num(21)<= cinco(3);
		num(22)<= cinco(4);
		num(23)<= cinco(5);
		miInt3 <= miInt2 - 50;
	elsif miInt2 >= 40 then --tercer numero un 4
		num(18)<= cuatro(0);
		num(19)<= cuatro(1);
		num(20)<= cuatro(2);
		num(21)<= cuatro(3);
		num(22)<= cuatro(4);
		num(23)<= cuatro(5);
		miInt3 <= miInt2 - 40;
	elsif miInt2 >= 30 then --tercer numero un 3
		num(18)<= tres(0);
		num(19)<= tres(1);
		num(20)<= tres(2);
		num(21)<= tres(3);
		num(22)<= tres(4);
		num(23)<= tres(5);
		miInt3 <= miInt2 - 30;
	elsif miInt2 >= 20 then --tercer numero un 2
		num(18)<= dos(0);
		num(19)<= dos(1);
		num(20)<= dos(2);
		num(21)<= dos(3);
		num(22)<= dos(4);
		num(23)<= dos(5);
		miInt3 <= miInt2 - 20;
	elsif miInt2 >= 10 then --tercer numero un 1
		num(18)<= uno(0);
		num(19)<= uno(1);
		num(20)<= uno(2);
		num(21)<= uno(3);
		num(22)<= uno(4);
		num(23)<= uno(5);
		miInt3 <= miInt2 - 10;
	elsif miInt >= 1000  or miInt1 >=100 then -- tercero numero es 0 pero el primero o el segundo no
		num(18)<= cero(0);
		num(19)<= cero(1);
		num(20)<= cero(2);
		num(21)<= cero(3);
		num(22)<= cero(4);
		num(23)<= cero(5);
		miInt3 <= miInt2;
	else -- primer y tercer numero son 0 asi que no lo pintamos
		num(18)<= nada(0);
		num(19)<= nada(1);
		num(20)<= nada(2);
		num(21)<= nada(3);
		num(22)<= nada(4);
		num(23)<= nada(5);
		miInt3 <= miInt2;
	end if;
end process calcula2;

calcula3: process(miInt3,s)
begin
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(25)<= (others=>'0');
		num(26)<= (others=>'0');
		num(27)<= (others=>'0');
		num(28)<= (others=>'0');
		num(29)<= (others=>'0');
		num(30)<= (others=>'0');
	--Quedan los numeros del 0 al 9
	elsif miInt3 =9 then --cuarto numero un 9
		num(25)<= nueve(0);
		num(26)<= nueve(1);
		num(27)<= nueve(2);
		num(28)<= nueve(3);
		num(29)<= nueve(4);
		num(30)<= nueve(5);
	elsif miInt3 =8 then --cuarto numero un 8
		num(25)<= ocho(0);
		num(26)<= ocho(1);
		num(27)<= ocho(2);
		num(28)<= ocho(3);
		num(29)<= ocho(4);
		num(30)<= ocho(5);
	elsif miInt3 =7 then --cuarto numero un 7
		num(25)<= siete(0);
		num(26)<= siete(1);
		num(27)<= siete(2);
		num(28)<= siete(3);
		num(29)<= siete(4);
		num(30)<= siete(5);
	elsif miInt3 =6 then --cuarto numero un 6
		num(25)<= seis(0);
		num(26)<= seis(1);
		num(27)<= seis(2);
		num(28)<= seis(3);
		num(29)<= seis(4);
		num(30)<= seis(5);
	elsif miInt3 =5 then --cuarto numero un 5
		num(25)<= cinco(0);
		num(26)<= cinco(1);
		num(27)<= cinco(2);
		num(28)<= cinco(3);
		num(29)<= cinco(4);
		num(30)<= cinco(5);
	elsif miInt3 =4 then --cuarto numero un 4
		num(25)<= cuatro(0);
		num(26)<= cuatro(1);
		num(27)<= cuatro(2);
		num(28)<= cuatro(3);
		num(29)<= cuatro(4);
		num(30)<= cuatro(5);
	elsif miInt3 =3 then --cuarto numero un 3
		num(25)<= tres(0);
		num(26)<= tres(1);
		num(27)<= tres(2);
		num(28)<= tres(3);
		num(29)<= tres(4);
		num(30)<= tres(5);
	elsif miInt3 =2 then --cuarto numero un 2
		num(25)<= dos(0);
		num(26)<= dos(1);
		num(27)<= dos(2);
		num(28)<= dos(3);
		num(29)<= dos(4);
		num(30)<= dos(5);
	elsif miInt3 =1 then --cuarto numero un 1
		num(25)<= uno(0);
		num(26)<= uno(1);
		num(27)<= uno(2);
		num(28)<= uno(3);
		num(29)<= uno(4);
		num(30)<= uno(5);
	else -- cuarto numero un 0
		num(25)<= cero(0);
		num(26)<= cero(1);
		num(27)<= cero(2);
		num(28)<= cero(3);
		num(29)<= cero(4);
		num(30)<= cero(5);
	end if;
end process calcula3;

calcula4: process(tuInt, s)
begin
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(35)<= (others=>'0');
		num(36)<= (others=>'0');
		num(37)<= (others=>'0');
		num(38)<= (others=>'0');
		num(39)<= (others=>'0');
		num(40)<= (others=>'0');
		tuInt1 <= tuInt;
	elsif tuInt >= "1110011001" then
		num(35)<= nueve(0);
		num(36)<= nueve(1);
		num(37)<= nueve(2);
		num(38)<= nueve(3);
		num(39)<= nueve(4);
		num(40)<= nueve(5);
		tuInt1 <= tuInt - "1110011001";
	elsif tuInt >= "1100110011" then
		num(35)<= ocho(0);
		num(36)<= ocho(1);
		num(37)<= ocho(2);
		num(38)<= ocho(3);
		num(39)<= ocho(4);
		num(40)<= ocho(5);
		tuInt1 <= tuInt - "1100110011";
	elsif tuInt >= "1011001100" then
		num(35)<= siete(0);
		num(36)<= siete(1);
		num(37)<= siete(2);
		num(38)<= siete(3);
		num(39)<= siete(4);
		num(40)<= siete(5);
		tuInt1 <= tuInt - "1011001100";
	elsif tuInt >= "1001100110" then
		num(35)<= seis(0);
		num(36)<= seis(1);
		num(37)<= seis(2);
		num(38)<= seis(3);
		num(39)<= seis(4);
		num(40)<= seis(5);
		tuInt1 <= tuInt - "1001100110";
	elsif tuInt >= "1000000000" then
		num(35)<= cinco(0);
		num(36)<= cinco(1);
		num(37)<= cinco(2);
		num(38)<= cinco(3);
		num(39)<= cinco(4);
		num(40)<= cinco(5);
		tuInt1 <= tuInt - "1000000000";
	elsif tuInt >= "0110011001" then
		num(35)<= cuatro(0);
		num(36)<= cuatro(1);
		num(37)<= cuatro(2);
		num(38)<= cuatro(3);
		num(39)<= cuatro(4);
		num(40)<= cuatro(5);
		tuInt1 <= tuInt - "0110011001";
	elsif tuInt >= "0100110011" then
		num(35)<= tres(0);
		num(36)<= tres(1);
		num(37)<= tres(2);
		num(38)<= tres(3);
		num(39)<= tres(4);
		num(40)<= tres(5);
		tuInt1 <= tuInt - "0100110011";
	elsif tuInt >= "0011001100" then
		num(35)<= dos(0);
		num(36)<= dos(1);
		num(37)<= dos(2);
		num(38)<= dos(3);
		num(39)<= dos(4);
		num(40)<= dos(5);
		tuInt1 <= tuInt - "0011001100";
	elsif tuInt >= "0001100110" then
		num(35)<= uno(0);
		num(36)<= uno(1);
		num(37)<= uno(2);
		num(38)<= uno(3);
		num(39)<= uno(4);
		num(40)<= uno(5);
		tuInt1 <= tuInt - "0001100110";
	else
		num(35)<= cero(0);
		num(36)<= cero(1);
		num(37)<= cero(2);
		num(38)<= cero(3);
		num(39)<= cero(4);
		num(40)<= cero(5);
		tuInt1 <= tuInt;
	end if;
end process calcula4;

calcula5: process(tuInt, tuInt1, s)
begin
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(42)<= (others=>'0');
		num(43)<= (others=>'0');
		num(44)<= (others=>'0');
		num(45)<= (others=>'0');
		num(46)<= (others=>'0');
		num(47)<= (others=>'0');
		tuInt2 <= tuInt1;
	elsif tuInt1 >= "0001011100" then
		num(42)<= nueve(0);
		num(43)<= nueve(1);
		num(44)<= nueve(2);
		num(45)<= nueve(3);
		num(46)<= nueve(4);
		num(47)<= nueve(5);
		tuInt2 <= tuInt1 - "0001011100";
	elsif tuInt1 >= "0001010001" then
		num(42)<= ocho(0);
		num(43)<= ocho(1);
		num(44)<= ocho(2);
		num(45)<= ocho(3);
		num(46)<= ocho(4);
		num(47)<= ocho(5);
		tuInt2 <= tuInt1 - "0001010001";
	elsif tuInt1 >= "0001000111" then
		num(42)<= siete(0);
		num(43)<= siete(1);
		num(44)<= siete(2);
		num(45)<= siete(3);
		num(46)<= siete(4);
		num(47)<= siete(5);
		tuInt2 <= tuInt1 - "0001000111";
	elsif tuInt1 >= "0000111101" then
		num(42)<= seis(0);
		num(43)<= seis(1);
		num(44)<= seis(2);
		num(45)<= seis(3);
		num(46)<= seis(4);
		num(47)<= seis(5);
		tuInt2 <= tuInt1 - "0000111101";
	elsif tuInt1 >= "0000110011" then
		num(42)<= cinco(0);
		num(43)<= cinco(1);
		num(44)<= cinco(2);
		num(45)<= cinco(3);
		num(46)<= cinco(4);
		num(47)<= cinco(5);
		tuInt2 <= tuInt1 - "0000110011";
	elsif tuInt1 >= "0000101000" then
		num(42)<= cuatro(0);
		num(43)<= cuatro(1);
		num(44)<= cuatro(2);
		num(45)<= cuatro(3);
		num(46)<= cuatro(4);
		num(47)<= cuatro(5);
		tuInt2 <= tuInt1 - "0000101000";
	elsif tuInt1 >= "0000011110" then
		num(42)<= tres(0);
		num(43)<= tres(1);
		num(44)<= tres(2);
		num(45)<= tres(3);
		num(46)<= tres(4);
		num(47)<= tres(5);
		tuInt2 <= tuInt1 - "0000011110";
	elsif tuInt1 >= "0000010100" then
		num(42)<= dos(0);
		num(43)<= dos(1);
		num(44)<= dos(2);
		num(45)<= dos(3);
		num(46)<= dos(4);
		num(47)<= dos(5);
		tuInt2 <= tuInt1 - "0000010100";
	elsif tuInt1 >= "0000001010" then
		num(42)<= uno(0);
		num(43)<= uno(1);
		num(44)<= uno(2);
		num(45)<= uno(3);
		num(46)<= uno(4);
		num(47)<= uno(5);
		tuInt2 <= tuInt1 - "0000001010";
	else
		num(42)<= cero(0);
		num(43)<= cero(1);
		num(44)<= cero(2);
		num(45)<= cero(3);
		num(46)<= cero(4);
		num(47)<= cero(5);
		tuInt2 <= tuInt;
	end if;
end process calcula5;

calcula6: process(tuInt2, s)
begin
	if s = "100000000000000000000" or s = "011111111111111111111" then
		num(49)<= (others=>'0');
		num(50)<= (others=>'0');
		num(51)<= (others=>'0');
		num(52)<= (others=>'0');
		num(53)<= (others=>'0');
		num(54)<= (others=>'0');
	elsif tuInt2 >= "0000001001" then
		num(49)<= nueve(0);
		num(50)<= nueve(1);
		num(51)<= nueve(2);
		num(52)<= nueve(3);
		num(53)<= nueve(4);
		num(54)<= nueve(5);
	elsif tuInt2 >= "0000001000" then
		num(49)<= ocho(0);
		num(50)<= ocho(1);
		num(51)<= ocho(2);
		num(52)<= ocho(3);
		num(53)<= ocho(4);
		num(54)<= ocho(5);
	elsif tuInt2 >= "0000000111" then
		num(49)<= siete(0);
		num(50)<= siete(1);
		num(51)<= siete(2);
		num(52)<= siete(3);
		num(53)<= siete(4);
		num(54)<= siete(5);
	elsif tuInt2 >= "0000000110" then
		num(49)<= seis(0);
		num(50)<= seis(1);
		num(51)<= seis(2);
		num(52)<= seis(3);
		num(53)<= seis(4);
		num(54)<= seis(5);
	elsif tuInt2 >= "0000000101" then
		num(49)<= cinco(0);
		num(50)<= cinco(1);
		num(51)<= cinco(2);
		num(52)<= cinco(3);
		num(53)<= cinco(4);
		num(54)<= cinco(5);
	elsif tuInt2 >= "0000000100" then
		num(49)<= cuatro(0);
		num(50)<= cuatro(1);
		num(51)<= cuatro(2);
		num(52)<= cuatro(3);
		num(53)<= cuatro(4);
		num(54)<= cuatro(5);
	elsif tuInt2 >= "0000000011" then
		num(49)<= tres(0);
		num(50)<= tres(1);
		num(51)<= tres(2);
		num(52)<= tres(3);
		num(53)<= tres(4);
		num(54)<= tres(5);
	elsif tuInt2 >= "0000000010" then
		num(49)<= dos(0);
		num(50)<= dos(1);
		num(51)<= dos(2);
		num(52)<= dos(3);
		num(53)<= dos(4);
		num(54)<= dos(5);
	elsif tuInt2 >= "0000000001" then
		num(49)<= uno(0);
		num(50)<= uno(1);
		num(51)<= uno(2);
		num(52)<= uno(3);
		num(53)<= uno(4);
		num(54)<= uno(5);
	else
		num(49)<= cero(0);
		num(50)<= cero(1);
		num(51)<= cero(2);
		num(52)<= cero(3);
		num(53)<= cero(4);
		num(54)<= cero(5);
	end if;
end process calcula6;

-- Las posiciones mayores o iguales que 55 las asignamos a 0
num(55 to 63)<=(others=>"0000000000");
end Behavioral;