% Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
% Generación de imágenes de puntos de muestra del eje X

ENT = 11; % Bits para la parte entera
DEC = 10; % Bits para la parte decimal

q = quantizer([ENT+DEC DEC]); % Se pueden modificar parámetros como el redondeo, etc

% Muestreados antiguos
y = 1/8*[-16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4,5,6,7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
yPos = 1/16*[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32];

x = 1/8*[0, 0.125, 0.25,-0.25,0.375, 0.5, -0.5,0.625, 0.75,-0.75,0.875, 1, -1, 1.125,1.25,-1.25,1.375, 1.5,-1.5,1.625, 1.75, -1.75,1.875, 2,-2,2.125,2.25,-2.25,2.375,2.5,-2.5,2.625,2.75,-2.75,2.875, 3,-3,3.125, 3.25,-3.25,3.375, 3.5,-3.5,3.625,3.75,-3.75,4,-4,4.25,4.5,-4.5,4.75,5,-5,5.25, 5.5,-5.5,5.75,6,-6,6.25,6.5,-6.5,6.75,7,-7,7.25,7.5,-7.5,8,-8,8.5,9,-9,9.5,10,-10,10.5,11,-11,11.5,12,-12,12.5,13,-13,13.5,14,-14,14.5,15,-15,16,-16,17, 18,-18,19, 20,-20,21, 22,-22,23, 24,-24,25, 26,-26,27, 28,-28,29, 30,-30, 32,-32,34, 36,-36,38, 40,-40,42, 44,-44,46, 48,-48,50,  52,-52, 54,56,-56,58, 60, -60, 64,-64,68, 72,-72,76, 80,-80,84, 88,-88,92, 96,-96,100, 104,-104,108, 112,-112,116, 120,-120,124, 128,-128];
xPos = 1/16*[0.25, 0.5,0.75, 1, 1.25, 1.5,1.75, 2,2.25, 2.5,2.75, 3,3.25,3.5,3.75,4,4.25,4.5,4.75, 5,5.25,5.5,5.75, 6,6.25,6.5,6.75, 7,7.25,7.5, 8,8.5, 9,9.5, 10,10.5, 11,11.5, 12,12.5, 13,13.5, 14,14.5, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 64, 68, 72, 76, 80, 84, 88, 92, 96, 100, 104, 108, 112, 116, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224, 232, 240, 256]; 

% Muestreados usados en la última versión del proyecto

%Set de puntos de muestra 1: En caso de log y no inversos. Dividimos [0,1] con paso 1/32
z1 = 1/32*[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32];

%Set de puntos de muestra 2: Caso de log con inversos 0 union [1/16,1]*2^count con paso 1/16. (Las 32 primeras componentes del vector equivalen al count = 0, el resto se obtienen variano estas como indica la fórmula)
z2 = 1/32*[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64,68, 72, 76, 80, 84, 88, 92, 96, 100,104,108,112,116,120,124,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,256,272,288,304,320,336,352,368,384,400,416,432,448,464,480,496,512];
     
%Set de puntos de muestra 3: Sin logaritmos (tomamos puntos negativos) [-1,-1/16]*2^count union [1/16,1]*2^count. (Las 32 primeras componentes del vector equivalen al count = 0, el resto se obtienen variano estas como indica la fórmula)
z3 = 1/16*[-16, -15, -14, -13, -12, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,-32, -30, -28, -26, -24, -22, -20, -18,18,20, 22, 24, 26, 28, 30, 32, -64, -60, -56, -52, -48, -44, -40, -36,36,40, 44, 48, 52, 56, 60, 64,-128,-120,-112,-104,-96,-88, -80, -72,72, 80,88, 96, 104,112,120,128,-256,-240,-224,-208,-192,-176,-160,-144    , 144,160,176,192,208,224,240,256];
            


z = [z2, z3];
a = unique(z); % Unimos los sets para obtener las tablas

%Descomentar las funciones deseadas

%num2bin(q, yPos)
% id = num2bin(q, b);
% idPos = num2bin(q, xPos);
% %bin2num(q, id) % Estas conversiones son para comprobar
% 
%invx = [num2bin(q, b.^-1), id]
% 
%senpix = [num2bin(q, sin(pi*b)), id]
% %bin2num(q, senx)
% 
%cospix = [num2bin(q, cos(pi*b)), id]
% %bin2num(q, cosx)
% 
%logx = [num2bin(q, log(b)), id] % Cuidado, al aplicarlo a los negativos hace el logaritmo complejo
% %bin2num(q, logx)
% 
%xlogxmx = [num2bin(q, b.*log(b) - b), id]
% num2bin(q, 0.1)

