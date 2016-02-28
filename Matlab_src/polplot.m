% Engineer: Ana María Martínez Gómez, Aitor Alonso Lorenzo, Víctor Adolfo Gallego Alcalá
% Test para pintar funciones en Matlab

function [ ] = polplot(c)
signedc=c;
c=abs(c);
if c(1)>3;
    count=-2;
elseif c(2)>3 || c(1)>0;
    count=-1;
else
    count=0;
end

if c(7)>3;
    count=count+3;
elseif c(7)>0 || c(6)>3;
    count=count+2;
elseif c(6)>0 || c(5)>3;
    count=count+1;
end
v=2^count*[-2 -1.5 -1 -3/4 -1/2 -1/4 -1/8 1/8 1/4 1/2 3/4 1 1.5 2];
w=zeros(1,14);
for i=1:7
   w=w+signedc(i).*v.^(4-i);
end
plot (v,w);
end