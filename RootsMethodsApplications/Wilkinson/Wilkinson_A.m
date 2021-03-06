clc
clear
hold on all
syms x
addpath('../') %%Take files from others folders, in this case i using 'Function.m'

Function = Function();

%Ya que la teoria nos dice que las raices de este polinomio son iguales a
%todos los numeros naturales que se encuentren dentro del intervalo entre 
%el grado del polinomio resultante, y uno(1), entonces no es necesario
%usar algun metodo cerrado/abierto para obtener las raices de dicho
%polinomio.

n = 20
result = Function.Wilkinson(n)

fplot(result,[0 n+1],'linewidth',2)
for i=1:n
    plot(i,subs(result,x,i), 'rO')%Grafica todos los puntos(raices).
end
legend(['result: ', char(result)])
title('Wilkinson A')
