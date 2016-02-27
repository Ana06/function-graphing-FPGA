----------------------------------------------------------------------------------
-- Company: Nameless2
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    12:10:21 11/10/2013 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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

--pantalla debe ser top
entity project is
    port
    (	 resetN: in std_logic;    -- reset
   	 clk: in std_logic;
		 ps2data: inout std_logic; 
		 ps2clk: inout std_logic;
   	 hsyncb: inout std_logic;    -- horizontal (line) sync
   	 vsyncb: out std_logic;    -- vertical (frame) sync
   	 rgb: out std_logic_vector(8 downto 0); -- red,green,blue colors
		 fin_principal: out std_logic;
       escalay: out std_logic_vector(4 downto 0); --Conectada a barra de leds
		 escalax: out std_logic_vector(7 downto 0)); -- Conectada a los 7 segmentos
end project;

architecture project_arch of project is


component puntos_muestra is
    Port ( caso : in std_logic_vector(1 downto 0);
				numPuntos : in std_logic_vector( 6 downto 0);
				enable, retro_muestra : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           fin : out STD_LOGIC;
			  entradaTeclado: in std_logic_vector(49 downto 0);
           punto_o : out STD_LOGIC_VECTOR(20 downto 0);
			  count_o: out std_logic_vector(3 downto 0));-- Para mostrar en el display de 7 segmentos
           
end component puntos_muestra;

component calculo is
	port(reset, clk, enable, integral: in std_logic;
		num: in std_logic_vector(20 downto 0);
		c: in std_logic_vector(49 downto 0);
		s: out std_logic_vector(20 downto 0);
		ready: out std_logic);
		
end component calculo;

component conversor is
	port( caso : in std_logic_vector(1 downto 0);
			numPuntos : in std_logic_vector(6 downto 0);
	      fin_pantalla: in std_logic;
			avanza: in std_logic;
			punto: in std_logic_vector(20 downto 0);
			reset, clk:in std_logic;
			punto1X, punto1Y, punto2X, punto2Y: out std_logic_vector(6 downto 0);
			enable_pantalla, fin_conv, inf: out std_logic;
			indice_o: out std_logic_vector(4 downto 0)); -- Para mostrarlo en la barra de LEDs
end component conversor;


component divisor is
     port (
        reset: in STD_LOGIC;
        clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
        clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
    );
end component;

component rams_2p is
    port (clk : in std_logic;
          we : in std_logic;
          addr1 : in std_logic_vector(6 downto 0);
          addr2 : in std_logic_vector(6 downto 0);
          di : in std_logic_vector(0 to 127);
          do1 : out std_logic_vector(0 to 127);
          do2 : out std_logic_vector(0 to 127)
	);
end component;


component reconocedor is
	port(ps2data: inout std_logic; 
			ps2clk: inout std_logic;
			reset: in std_logic;
			clk: in std_logic;
			fin : out std_logic;
			fin_coef: out std_logic_vector(15 downto 0);
			salida: out std_logic_vector(49 downto 0)); 
end component reconocedor;

component expresion is
	port(
		clk: in std_logic;
		salida_teclado: in std_logic_vector(49 downto 0);
      addr : in std_logic_vector(7 downto 0);
      do : out std_logic_vector(0 to 10)
	);
end component;

component numero is
	port(
		clk: in std_logic;
		s: in std_logic_vector(20 downto 0);
      addr : in std_logic_vector(5 downto 0);
      do : out std_logic_vector(0 to 9)
	);
end component;

type ESTADOS is (S1, S2, S3); --ESTADOS DE LA PANTALLA
signal ESTADO, SIG_ESTADO: ESTADOS;
type ESTADOSG is (inicial, leer, calc, a_memoria, integrar1, integrar2); --ESTADOS DEL CONTROLADOR PRINCIPAL
signal estadoGen, estadoGen_sig: ESTADOSG;

-- En la representación en coma fija
-- DEC es el número de bits reservados a la parte decimal (contando el signo, pues representamos en C2)
-- ENT es el número de bits reservados a la parte entera
constant ENT : integer := 11;
constant DEC : integer := 10;
constant nB : integer := 6; --nBits-1
constant nF : integer := 127; --nF-1
constant nC : integer := 255;	--nC-1
constant hInf : integer := 63;
constant hSup : integer := hInf + nF + 2;
constant vInf : integer := 63;
constant vSup : integer := vInf + nC + 2;
constant numPuntos : integer := 2;

signal clock, reset: std_logic;
--Señales de la pantalla
signal hcnt, fila, filaExp: std_logic_vector(9 downto 0);    -- horizontal pixel counter
signal vcnt, auxColumna: std_logic_vector(8 downto 0);    -- vertical line counter
signal columna: std_logic_vector(6 downto 0);
signal data: std_logic_vector(0 to nF); 
signal data_particular,data_particularExp, data_particularNum, we: std_logic;  			 
signal addr1, addr2, puntos1X, puntos1Y, puntos2X, puntos2Y: std_logic_vector(6 downto 0);
signal di, do1, do2, vAux, v: std_logic_vector(0 to 127);
signal b, j, jAux, a, i, iAux: std_logic_vector(nB downto 0);
signal aj, bi, biAux, ajAux: std_logic_vector(11 downto 0);
signal pinta_funcion, pinta_ejes, pinta_fondo, pinta_expresion, pinta_expY, pinta_expB, pinta_num:std_logic;
signal addrExp: std_logic_vector(7 downto 0);
signal addrNum: std_logic_vector(5 downto 0);
signal doExp: std_logic_vector(0 to 10);
signal doNum: std_logic_vector(0 to 9);
signal dataExp, dataNum: std_logic_vector(0 to 15);
signal columnaExp, columnaNum: std_logic_vector(3 downto 0);
signal fin_coef: std_logic_vector(15 downto 0);
signal noPintes, noPintesAux: std_logic;

--señales del controlador principal
signal caso: std_logic_vector(1 downto 0);
signal salida_teclado: std_logic_vector(49 downto 0);
signal integral, solo_positivos, solo_positivosAux, fin_muestra, fin_teclado, ready_calculo, enable_muestra, retro_muestra, fin_puntos, enable_calculo, fin_pantalla,enable_pantalla, avanza_conv, inf, inf1, inf2, puntos_centrales, x1, x2, x3, x4, x5, xl: std_logic;
signal punto, s, limite1, limite1Aux, limite2, limite2Aux, valorIntegral, valorIntegralAux: std_logic_vector(DEC+ENT-1 downto 0);
signal numPuntos2 : std_logic_vector(6 downto 0);
signal count: std_logic_vector(3 downto 0);
signal indice: std_logic_vector(4 downto 0);


begin
calcExp: expresion port map (clock, salida_teclado, addrExp, doExp);
calInt: numero port map (clock, valorIntegral, addrNum,doNum);
muestra: puntos_muestra port map(caso, numPuntos2, enable_muestra, retro_muestra, clock, reset, fin_muestra, salida_teclado,punto, count);
calculador: calculo port map(reset, clock, enable_calculo,integral, punto, salida_teclado, s, ready_calculo);
--Por comodidad las componentes de los puntos están intercambiadas
conver: conversor port map(caso, numPuntos2, fin_pantalla, avanza_conv, s, reset, clock, puntos1Y, puntos1X, puntos2Y, puntos2X, enable_pantalla, fin_puntos, puntos_centrales,indice);
reco: reconocedor port map(ps2data, ps2clk, reset, clock, fin_teclado, fin_coef, salida_teclado);
divisor1: divisor port map (reset, clk, clock);
ram: rams_2p port map(clock, we, addr1, addr2, di, do1, do2);


--PANTALLA

reset<= resetN;
a<=puntos2Y-puntos1Y;
b<=puntos2X-puntos1X when puntos2X>puntos1X else
	puntos1X-puntos2X;

auxColumna <= vcnt - (vInf+1);
columna<= auxColumna(nB+1 downto 1);
fila<= hcnt - (hInf+1);	
addr2 <=fila(nB downto 0)+1;
data(0 to 127) <=do2;
data_particular <=data(conv_integer(columna));


columnaExp<= auxColumna(3 downto 0);
filaExp<= hcnt - (32);	
addrExp <=filaExp(7 downto 0);
dataExp(0 to 10) <=doExp;
--Al resto de pos de dataExp le ponemos ceros
dataExp(11 to 15)<=(others=>'0');
data_particularExp <=dataExp(conv_integer(columnaExp));

columnaNum<= auxColumna(3 downto 0);
addrNum <=fila(5 downto 0);
dataNum(0 to 9) <=doNum;
--Al resto de pos de dataNum le ponemos ceros
dataNum(10 to 15)<=(others=>'0');
data_particularNum <=dataNum(conv_integer(columnaNum));

colorear: process(hcnt, vcnt, pinta_funcion, pinta_ejes, pinta_fondo, pinta_expresion, pinta_num, pinta_expY, pinta_expB)
begin
	if pinta_num = '1' or pinta_expY ='1' then
		rgb<="111111000";
	elsif pinta_expB ='1' then
		rgb<="001011110";
   elsif pinta_expresion = '1' then 
		rgb<="111111111";
	elsif pinta_funcion ='1' then
		rgb<="111001011";
	elsif pinta_ejes = '1' then
		rgb<="000000100";
	elsif pinta_fondo = '1' then
		rgb<="111111111";
	else rgb<="000000000";
	end if;
end process colorear;

pintar_fondo: process(hcnt, vcnt)
begin
	pinta_fondo<='0';
   if hcnt > hInf and hcnt < hSup then
   	if vcnt > vInf and vcnt < vSup then
			pinta_fondo<='1';
		end if;
	end if;
end process pintar_fondo;

pintar_ejes: process(hcnt, vcnt, solo_positivos)
begin
      pinta_ejes<='0';
      if hcnt > hInf and hcnt < hSup then
         if vcnt > vInf and vcnt < vSup then
					 if (vcnt=192 or vcnt=193) then pinta_ejes <= '1';
					 elsif solo_positivos ='0' and hcnt=128 then pinta_ejes <= '1';
					 elsif solo_positivos ='1' and hcnt=(vInf+1) then pinta_ejes <= '1';
					 --escala horizontal
					 elsif vcnt =194 and hcnt(2 downto 0)="000" then pinta_ejes <='1';
					 --escala vertical
					 elsif solo_positivos ='0' and hcnt=129 and (vcnt(3 downto 0) ="0000" or vcnt(3 downto 0) ="0001") then pinta_ejes <='1';
					 elsif solo_positivos ='1' and hcnt=vInf+2 and (vcnt(3 downto 0) ="0000" or vcnt(3 downto 0) ="0001") then pinta_ejes <='1';
					 end if;
              end if;
      end if;
end process pintar_ejes;

pintar_funcion: process(hcnt, vcnt, data_particular, noPintes)
begin
	pinta_funcion <= '0';
   if hcnt > hInf and hcnt < hSup then
   	if vcnt > vInf and vcnt < vSup then
					if data_particular='1' and noPintes = '1' then pinta_funcion <= '1';
			end if;
		end if;
	end if;
end process pintar_funcion;

pintar_expresion: process(hcnt, vcnt, data_particularExp, fin_coef)
begin
	pinta_expresion <= '0';
	pinta_expB <='0';
	pinta_expY <='0';
	if vcnt > vSup +15 and vcnt < (vSup+11)+15 then
		if (hcnt > 32 and hcnt < 42) then
			if data_particularExp='1' and fin_coef(0) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(0) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 53 and hcnt < 65) then
			if data_particularExp='1' and fin_coef(1) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(1) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 82 and hcnt < 94) then
			if data_particularExp='1' and fin_coef(2) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(2) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 111 and hcnt < 123) then
			if data_particularExp='1' and fin_coef(3) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(3) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 132 and hcnt < 144) then
			if data_particularExp='1' and fin_coef(4) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(4) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 153 and hcnt < 165) then
			if data_particularExp='1' and fin_coef(5) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(5) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 170 and hcnt <= 182) then
			if data_particularExp='1' and fin_coef(6) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(6) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 181 and hcnt < 193) then
			if data_particularExp='1' and fin_coef(7) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(7) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 202 and hcnt < 214) then
			if data_particularExp='1' and fin_coef(8) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(8) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt > 225 and hcnt < 237) then
			if data_particularExp='1' and fin_coef(9) ='0' then pinta_expB <='1';
			elsif data_particularExp='1' and fin_coef(9) ='1' then pinta_expY <='1';
			end if;
		elsif (hcnt >= 43 and hcnt <= 53) or (hcnt >= 65 and hcnt <= 82) or (hcnt >= 94 and hcnt <=111) or (hcnt >= 123 and hcnt <= 132) or (hcnt >= 144 and hcnt <=153) or (hcnt >= 165 and hcnt <=170) or (hcnt >= 193 and hcnt <=202)or (hcnt >= 214 and hcnt <=225) or (hcnt >= 237 and hcnt < 32+217)then
					if data_particularExp='1' then pinta_expresion <= '1';
			end if;
		end if;
	end if;
end process pintar_expresion;

pintar_integral: process(hcnt, vcnt, data_particularNum)
begin
	pinta_num <= '0';
    if hcnt > hInf and hcnt < hInf+64 then
   	if vcnt >= vInf -15 and vcnt < (vInf+10)-15 then
					if data_particularNum='1' then pinta_num <= '1';
			end if;
		end if;
	end if;
end process pintar_integral;

combinacional_pantalla: process(ESTADO, enable_pantalla, j, i, v, aj, bi, puntos1X, puntos1Y, puntos2X, puntos2Y, fin_puntos, vAux, inf, inf1, inf2, a, b,solo_positivos)
begin
di<=(others=>'0');
addr1<=(others=>'0');
biAux<=(others=>'0');
ajAux<=(others=>'0');
iAux<=(others=>'0');
jAux<=(others=>'0');
--vAux<=(others=>'0');
-- si lo pones por alguna razon deja de sintetizar, pero habria que ponerlo porque si no xilinx no
-- entiende las declaraciones parciales y pone latches
we<='0';
fin_pantalla<='0';
-- para quitar latches, cuando queramos usarlo lo pondremos explicitamente
	case ESTADO is
	when S1 =>
		if inf = '0' then
			di<=(others=>'0');
			addr1<=(others=>'0');
			biAux<=(others=>'0');
			ajAux<=(others=>'0');
			iAux<=(others=>'0');
			jAux<=(others=>'0');
			we<='0';
			fin_pantalla<='1';
			if fin_puntos = '1' then 
				vAux<= (others =>'0');
			else
				vAux<=v;
			end if;
			if  enable_pantalla ='1' then
				vAux(conv_integer(puntos1X))<= '1';
				SIG_ESTADO <= S2;
			else SIG_ESTADO <= S1;
			end if;
		else
			if solo_positivos = '1' then
				we <= '0';
				fin_pantalla <= '0';
				SIG_ESTADO <= S2;
				iAux <= (others=>'0');
				vAux<=(others=>'0');
			else
				we <= '1';
				fin_pantalla <= '0';
				if inf1 = '1' then --bit + sig bit + abajo
					vAux(conv_integer(puntos1X) to 127) <= (others=>'1');
					vAux(0 to conv_integer(puntos1X)-1) <= (others=>'0');
				else
					vAux(conv_integer(puntos1X)+1 to 127) <= (others=>'0');
					vAux(0 to conv_integer(puntos1X)) <= (others=>'1');
				end if;
				di <= v or vAux;
				addr1 <= puntos1Y;
				iAux(nB downto 1) <= (others=>'0');
				iAux(0) <= '1';
				SIG_ESTADO <= S2;
			end if;
		end if;
	when S2 =>
		if inf = '0' then
			fin_pantalla<='0';
			ajAux<=aj;
			biAux<=bi;
			iAux<=i;
			di<=(others=>'0');
			addr1<=(others=>'0');
			we<='0';
			vAux <= v;
			if a(nB downto 1) +aj <bi and j < b then
				if puntos2X>puntos1X then
					vAux(conv_integer(j+1+puntos1X))<= '1';
				else
					vAux(conv_integer(puntos1X-j-1))<= '1';
				end if;
				jAux<=j+1;
				ajAux <= aj+a;
				SIG_ESTADO <= S2;
			else
				di<=v;
				we<='1';
				addr1<=i+puntos1Y;
				iAux <= i+1;
				biAux <= bi+b;
				jAux <= j;
				vAux<=(others=>'0');
				if i < a then
					if a(nB downto 1) +aj >=bi+b  then
						if puntos2X>puntos1X then
							vAux(conv_integer(j+puntos1X))<=v(conv_integer(j+puntos1X));
						else
							vAux(conv_integer(puntos1X-j))<= v(conv_integer(puntos1X-j));
						end if;
					end if;
					SIG_ESTADO <= S2;
				else
					SIG_ESTADO <= S1;		
					vAux<=v;
				end if;
			end if;
		else
			we <= '1';
			fin_pantalla <= '0';
			di <= (others=>'0');
			addr1 <= puntos1Y+i;
			iAux <= i+1;
			vAux <= (others=>'0');
				if puntos1Y+iAux = puntos2Y then
					SIG_ESTADO <= S3;
				else
					SIG_ESTADO <= S2;
				end if;
		end if;
	when S3 =>
		we <= '1';
		fin_pantalla <= '1';
		if inf2 = '1' then --bit + sig bit + abajo
			vAux(conv_integer(puntos2X) to 127) <= (others=>'1');
			vAux(0 to conv_integer(puntos2X)-1) <= (others=>'0');
		else
			vAux(conv_integer(puntos2X)+1 to 127) <= (others=>'0');
			vAux(0 to conv_integer(puntos2X)) <= (others=>'1');
		end if;
		di <= vAux;
		addr1 <= puntos2Y;
		iAux <= (others=>'0');
		SIG_ESTADO <= S1;
	end case;
end process combinacional_pantalla;

sincrono: process(clock, reset)
begin
	-- Reset asincrono
	if reset = '1' then 
		ESTADO <= S1;
	elsif clock'event and clock = '1' then
		ESTADO <= SIG_ESTADO;
	end if;
end process sincrono;

registros_clock: process(vAux, clock, reset, jAux, iAux, ajAux, biAux, noPintesAux)
begin
	if reset = '1' then
		v<=(others=>'0');
		j<=(others=>'0');
		i<=(others=>'0');
		aj<=(others =>'0');
		bi<=(others =>'0');
		noPintes <='0';
	elsif clock'event and clock='1' then
		v<=vAux;
		j<=jAux;
		i<=iAux;
		aj<=ajAux;
		bi<=biAux;
		noPintes <=noPintesAux;
	end if;
end process registros_clock;

pA: process(clock,reset)
begin
    -- reset asynchronously clears pixel counter
    if reset='1' then
   	  hcnt <= "0000000000";
    -- horiz. pixel counter increments on rising edge of dot clock
    elsif (clock'event and clock='1') then
   	 -- horiz. pixel counter rolls-over after 381 pixels
   	 if hcnt<380 then
   		 hcnt <= hcnt + 1;
   	 else
   		  hcnt <= "0000000000";
   	 end if;
    end if;
end process pA;

pB: process(hsyncb,reset)
begin
    -- reset asynchronously clears line counter
    if reset='1' then
   	 vcnt <= "000000000";
    -- vert. line counter increments after every horiz. line
    elsif (hsyncb'event and hsyncb='1') then
   	 -- vert. line counter rolls-over after 528 lines
   	 if vcnt<527 then
   		 vcnt <= vcnt + 1;
   	 else
   		 vcnt <= "000000000";
   	 end if;
    end if;
end process pB;

C: process(clock,reset)
begin
    -- reset asynchronously sets horizontal sync to inactive
    if reset='1' then
   	 hsyncb <= '1';
    -- horizontal sync is recomputed on the rising edge of every dot clock
    elsif (clock'event and clock='1') then
   	 -- horiz. sync is low in this interval to signal start of a new line
   	 if (hcnt>=291 and hcnt<337) then
   		 hsyncb <= '0';
   	 else
   		 hsyncb <= '1';
   	 end if;
    end if;
end process;

D: process(hsyncb,reset)
begin
    -- reset asynchronously sets vertical sync to inactive
    if reset='1' then
   	 vsyncb <= '1';
    -- vertical sync is recomputed at the end of every line of pixels
    elsif (hsyncb'event and hsyncb='1') then
   	 -- vert. sync is low in this interval to signal start of a new frame
   	 if (vcnt>=490 and vcnt<492) then
   		 vsyncb <= '0';
   	 else
   		 vsyncb <= '1';
   	 end if;
    end if;
end process;


--CONTROLADOR PRINCIPAL

with salida_teclado(4 downto 0) select
x3 <= '0' when "00000",
		'1' when others;
with salida_teclado(9 downto 5) select
x2 <= '0' when "00000",
		'1' when others;
with salida_teclado(14 downto 10) select
x1 <= '0' when "00000",
		'1' when others;
with salida_teclado(49 downto 45) select
xl <= '0' when "00000",
		'1' when others;

x4 <= x1 or x2 or x3;
x5 <= x4 or xl;
inf <= puntos_centrales and x5;

--'0' es positivo, '1' es negativo
pinf1y2: process(salida_teclado, x1, x2, x3)
begin
	if salida_teclado(4) = '1' then
		inf1 <= '0';
		inf2 <= '1';
	elsif x3 = '1' then
		inf1 <= '1';
		inf2 <= '0';
	elsif salida_teclado(9) = '1' then
		inf1 <= '1';
		inf2 <= '1';
	elsif x2 = '1' then
		inf1 <= '0';
		inf2 <= '0';
	elsif salida_teclado(14) = '1' then
		inf1 <= '0';
		inf2 <= '1';
	elsif x1 = '1' then
		inf1 <= '1';
		inf2 <= '0';
	elsif salida_teclado(49) = '1' then -- a partir de aqui el limite lo domina el logaritmo
		inf1 <= '0'; -- para quitar latches
		inf2 <= '0';
	else -- o el caso de que no usemos los inf
		inf1 <= '0'; -- para quitar latches
		inf2 <= '1';
	end if;
end process pinf1y2;

sincronoGen: process(clock, reset)
begin
	if reset = '1' then
		estadoGen <= inicial;
	elsif clock'event and clock = '1' then
		estadoGen <= estadoGen_sig;
	end if;
end process sincronoGen;

--En función de si hay potencias negativas o solo evaluamos en puntos negativos (como en el caso del logaritmo
--elegimos un caso u otro: ver puntos_muestra.vhd y conversor.vhd)
p_numero: process(x4, solo_positivos)
begin
	if solo_positivos = '0' then
		caso <= "10";
		numPuntos2 <= "0100000";
	else
		if x4 = '0' then
			caso <= "00";
			numPuntos2 <= "0100001";
		else
			caso <= "01";
			numPuntos2 <= "0100000";
		end if;
	end if;
end process p_numero;

maquina_estadoGens: process(estadoGen, enable_muestra, enable_calculo, ready_calculo, fin_puntos, fin_teclado, fin_muestra, salida_teclado, solo_positivos, valorIntegral, limite1, limite2, noPintes, s)
begin
valorIntegralAux <= valorIntegral;
solo_positivosAux <= solo_positivos;
retro_muestra <= '0';
limite1Aux <= limite1;
limite2Aux <= limite2;
noPintesAux<=noPintes;

	case estadoGen is
	-- estadoGen de inicio
	when inicial =>
		integral <= '1';
		enable_muestra <= '0'; 	-- Cuando está a 1, la salida devuelve el siguiente punto de muestra a ser evaluado.
		enable_calculo <= '0';
		avanza_conv <= '0'; 		-- Avanza el conversor al siguiente estadoGen. En cada estadoGen con el prefijo S, se guarda 
										-- cada punto obtenido de calculo.vhd, con el fin de aplicar la conversión a coordenadas
										-- en memoria/pantalla.
		solo_positivosAux <= solo_positivos;
		estadoGen_sig <= leer;
		-- Criterio de divergencia de la integral
		if solo_positivos = '0' then
			if salida_teclado(9 downto 5) /= "00000" then
				if salida_teclado(9) = '0' then
					valorIntegralAux <= "011111111111111111111";
				else
					valorIntegralAux <= "100000000000000000000";
				end if;
			else valorIntegralAux <= limite2 - limite1;
			end if;
		else
			if salida_teclado(4 downto 0) /= "00000" then
				if salida_teclado(4) = '0' then
					valorIntegralAux <= "011111111111111111111";
				else
					valorIntegralAux <= "100000000000000000000";
				end if;
			elsif salida_teclado(9 downto 5) /= "00000" then
				if salida_teclado(9) = '0' then
					valorIntegralAux <= "011111111111111111111";
				else
					valorIntegralAux <= "100000000000000000000";
				end if;
			elsif salida_teclado(14 downto 10) /= "00000" then
				if salida_teclado(14) = '0' then
					valorIntegralAux <= "011111111111111111111";
				else
					valorIntegralAux <= "100000000000000000000";
				end if;
			else
				valorIntegralAux <= limite2 - limite1;
			end if;		
		end if;
		
	when leer =>
		integral <= '0';
		enable_muestra <= '0';
		enable_calculo <= '0';
		avanza_conv <= '0';
		if fin_teclado = '0' then
			solo_positivosAux <= solo_positivos;
			estadoGen_sig <= leer; 	-- fin_teclado indica el momento en el que salida_teclado tiene
		else 
			estadoGen_sig <= calc; -- la información adecuada (los coeficientes del polinomio)
			if salida_teclado(49 downto 45) = "00000" then
				solo_positivosAux <= '0';
			else solo_positivosAux <= '1';
			end if;
			avanza_conv <= '1';
		end if;
	-- calc: estadoGen de cálculo de la imagen de un punto muestra. Hay 14 puntos a calcular, por tanto antes de pasar al
	-- siguiente estadoGen, a_memoria, volvemos a pasar 13 veces a este estadoGen (cuando ready_calculo = 1, por tanto, se ha
	-- calculado la imagen del punto. En este caso, avanzamos el conversor y el módulo muestra)
	
	when calc =>
	integral <= '0';
		solo_positivosAux <= solo_positivos;
		avanza_conv <= '0';
		enable_calculo <= '1';
		if ready_calculo = '0' then
			estadoGen_sig <= calc;
			enable_muestra <= '0';
		else enable_muestra <= '1';
				avanza_conv <= '1';
				if fin_muestra = '0' then
					estadoGen_sig <= calc;
				else 
					estadoGen_sig <= a_memoria;
				end if;
		end if;
	-- estadoGen de transferencia a memoria/pantalla. En el módulo conversor, corresponde a los estadoGens con prefijo 
	when a_memoria =>
		integral <= '0';
		solo_positivosAux <= solo_positivos;
		avanza_conv <= '0';
		enable_muestra <= '0';
		enable_calculo <= '0';
		noPintesAux<='1';
		if fin_puntos = '1' then
			estadoGen_sig <= integrar1;
			integral <= '1';
		else
			estadoGen_sig <= a_memoria;
		end if;
		
	when integrar1 => 
		integral <= '1';
		solo_positivosAux <= solo_positivos;
		avanza_conv <= '0';
		enable_calculo <= '1';
		enable_muestra <= '0';
		if ready_calculo = '0' then
			estadoGen_sig <= integrar1;
		else retro_muestra <= '1';
			estadoGen_sig <= integrar2;
			limite1Aux <= s;				
		end if;
	
	when integrar2 =>
		integral <= '1';
		solo_positivosAux <= solo_positivos;
		avanza_conv <= '0';
		enable_calculo <= '1';
		enable_muestra <= '0';
		retro_muestra <= '0';
		if ready_calculo = '0' then
			estadoGen_sig <= integrar2;
		else enable_muestra <= '1';
			estadoGen_sig <= inicial;
			limite2Aux <= s;
		end if;
	
	end case;
end process maquina_estadoGens;

fin_principal <= fin_puntos;
escalay <= indice;

with count select
	escalax <= 	"11101101" when "1011",
					"11100110" when "1100",
					"11001111" when "1101",
					"11011011" when "1110",
					"10000110" when "1111",
					"00111111" when "0000",
					"00000110" when "0001",
					"11111111" when others;

registros_controlador: process (clock, estadoGen, solo_positivosAux, limite1Aux, limite2Aux, valorIntegralAux, reset)
begin
	if reset = '1' then 
		valorIntegral <= (others => '0');
		solo_positivos <= '0';
		limite1 <= (others => '0');
		limite2 <= (others => '0');
	elsif clock'event and clock = '1' then
		solo_positivos <= solo_positivosAux;
		limite1 <= limite1Aux;
		limite2 <= limite2Aux;
		valorIntegral <= valorIntegralAux;
	end if;
end process registros_controlador;

end project_arch;