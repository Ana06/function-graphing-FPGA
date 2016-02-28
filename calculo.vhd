----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
-- 
-- Create Date:    12:22:13 12/18/2013 
-- Design Name: 
-- Module Name:   calculo - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity calculo is
	port(reset, clk, enable, integral: in std_logic;
		num: in std_logic_vector(20 downto 0);
		c: in std_logic_vector(49 downto 0);
		s: out std_logic_vector(20 downto 0);
		ready: out std_logic);
end calculo;

architecture Behavioral of calculo is

component inversor is
	port( valor: in std_logic_vector(20 downto 0);
		inverso: out std_logic_vector(20 downto 0));
end component inversor;

component logaritmo is
    Port ( valor : in  STD_LOGIC_VECTOR (20 downto 0);
           log : out  STD_LOGIC_VECTOR (20 downto 0);
		   xlogmx : out  STD_LOGIC_VECTOR (20 downto 0));
end component logaritmo;

component trigo is
    Port ( valor : in  STD_LOGIC_VECTOR (20 downto 0);
           sen : out  STD_LOGIC_VECTOR (20 downto 0);
           cos : out  STD_LOGIC_VECTOR (20 downto 0));
end component trigo;

constant b: integer:=11;
constant d: integer:=10;
constant tres: std_logic_vector(20 downto 0):= "000000000000101010101"; -- Un tercio
constant pi: std_logic_vector(20 downto 0):= "000000000000101000101"; -- Inverso de pi
signal inum, sen, cos, log,xlogmx, acc, acc2, accsig, accsig2, mult1, mult2, cumsum, cumsumsig: std_logic_vector(b+d-1 downto 0);
signal rmultaux: std_logic_vector(2*(b+d)-1 downto 0);
signal rmult: std_logic_vector(b+d-1 downto 0);
signal estado, estadosig: std_logic_vector(4 downto 0);

begin

inversa: inversor port map(num, inum);
trigonometrico: trigo port map(num, sen, cos);
loga: logaritmo port map(num, log, xlogmx);

rmultaux <= mult1*mult2;
rmult <= rmultaux(b+2*d-1 downto d);
s <= cumsum;

pestado: process(estado, enable)
begin
	if estado = "11111" then
		if enable = '1' then
			estadosig <= "00000";
		else
			estadosig <= "11111";
		end if;
	elsif estado = "01101" then
		if enable = '1' then
			estadosig <= "11111";
		else
			estadosig <= "01101";
		end if;
	elsif estado < "01101" then
		estadosig <= estado+1;
	else
		estadosig <= "11111";
	end if;
end process pestado;

asinc: process(estado, cumsum, rmult, acc, enable, num, c, inum, acc2, integral, sen, cos, log, xlogmx)
begin
	ready <= '0';
	accsig <= acc;
	accsig2 <= acc2;
	mult1 <= num; --para quitar latches, cuando se usen, aunque sean los mismos,se pondra de forma explicita
	mult2 <= num; --para quitar latches, cuando se usen, aunque sean los mismos,se pondra de forma explicita
	if integral = '0' then
		if estado = "11111" then
			cumsumsig(b+d-1 downto 5+d) <= (others => c(19));
			cumsumsig(4+d downto d) <= c(19 downto 15);
			cumsumsig(d-1 downto 0) <= (others => '0');
		elsif estado = "00000" then
			mult1 <= num;
			mult2(b+d-1 downto 5+d) <= (others => c(24));
			mult2(4+d downto d) <= c(24 downto 20);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "00001" then
			mult1 <= num;
			mult2 <= num;
			accsig <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00010" then
			mult1 <= acc;
			mult2(b+d-1 downto 5+d) <= (others => c(29));
			mult2(4+d downto d) <= c(29 downto 25);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "00011" then
			mult1 <= num;
			mult2 <= acc;
			accsig <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00100" then
			mult1 <= acc;
			mult2(b+d-1 downto 5+d) <= (others => c(34));
			mult2(4+d downto d) <= c(34 downto 30);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "00101" then
			mult1 <= inum;
			mult2(b+d-1 downto 5+d) <= (others => c(14));
			mult2(4+d downto d) <= c(14 downto 10);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "00110" then
			mult1 <= inum;
			mult2 <= inum;
			accsig <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00111" then
			mult1 <= acc;
			mult2(b+d-1 downto 5+d) <= (others => c(9));
			mult2(4+d downto d) <= c(9 downto 5);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01000" then
			mult1 <= acc;
			mult2 <= inum;
			accsig <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "01001" then
			mult1 <= acc;
			mult2(b+d-1 downto 5+d) <= (others => c(4));
			mult2(4+d downto d) <= c(4 downto 0);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01010" then
			mult1 <= sen;
			mult2(b+d-1 downto 5+d) <= (others => c(44));
			mult2(4+d downto d) <= c(44 downto 40);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01011" then
			mult1 <= cos;
			mult2(b+d-1 downto 5+d) <= (others => c(39));
			mult2(4+d downto d) <= c(39 downto 35);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01100" then
			mult1 <= log;
			mult2(b+d-1 downto 5+d) <= (others => c(49));
			mult2(4+d downto d) <= c(49 downto 45);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		else
			ready <= '1';
			cumsumsig <= cumsum;
		end if;
	else
		if estado = "11111" then
			mult1 <= num;
			mult2(b+d-1 downto 5+d) <= (others => c(19));
			mult2(4+d downto d) <= c(19 downto 15);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= rmult(20 downto 0);
		elsif estado = "00000" then
			mult1 <= num;
			mult2 <= num;
			if rmult(20) = '0' then
				accsig <= '0' & rmult(20 downto 1);
			else
				accsig <= '1' & rmult(20 downto 1);
			end if;
			accsig2 <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00001" then
			mult1 <= acc;
			mult2(b+d-1 downto 5+d) <= (others => c(24));
			mult2(4+d downto d) <= c(24 downto 20);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
			accsig2 <= acc2;
		elsif estado = "00010" then
			mult1 <= num;
			mult2 <= acc2;
			accsig <= rmult;
			accsig2 <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00011" then
			mult1 <= acc;
			mult2 <= tres;
			accsig2 <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00100" then
			mult1 <= acc2;
			mult2(b+d-1 downto 5+d) <= (others => c(29));
			mult2(4+d downto d) <= c(29 downto 25);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "00101" then
			mult1 <= num;
			mult2 <= acc;
			accsig <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "00110" then
			mult1 <= acc;
			mult2(b+d-1 downto 5+d) <= (others => c(34));
			mult2(4+d downto d) <= c(34 downto 30);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult(20 downto 2);
		elsif estado = "00111" then
			mult1 <= 0-cos;
			mult2 <= pi;
			accsig2 <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "01000" then
			mult1 <= acc2;
			mult2(b+d-1 downto 5+d) <= (others => c(44));
			mult2(4+d downto d) <= c(44 downto 40);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01001" then
			mult1 <= sen;
			mult2 <= pi;
			accsig2 <= rmult;
			cumsumsig <= cumsum;
		elsif estado = "01010" then
			mult1 <= acc2;
			mult2(b+d-1 downto 5+d) <= (others => c(39));
			mult2(4+d downto d) <= c(39 downto 35);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01011" then
			mult1 <= xlogmx;
			mult2(b+d-1 downto 5+d) <= (others => c(49));
			mult2(4+d downto d) <= c(49 downto 45);
			mult2(d-1 downto 0) <= (others => '0');
			cumsumsig <= cumsum + rmult;
		elsif estado = "01100" then
			cumsumsig <= cumsum;
		else
			ready <= '1';
			cumsumsig <= cumsum;
		end if;
	end if;
end process asinc;

sinc: process(reset, clk)
begin
	if reset='1' then
		estado <= (others => '1');
		cumsum <= (others => '0');
		acc <= (others => '0');
		acc2 <= (others => '0');
	elsif clk'event and clk='1' then
		estado <= estadosig;
		acc <= accsig;
		acc2 <= accsig2;
		cumsum <= cumsumsig;
	end if;
end process sinc;
end Behavioral;


