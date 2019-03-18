clc
clear
syms x
hold on all
Function = Function();

n = 15;

P = Function.Wilkinson(n);

Function.polynomial = P;

root = Function.RegulaFalsi(0.95, 1.05)
froot = subs(P,x,root)

fplot(P,[0 n])
plot(root,froot,'rO')
legend(['P(X) = ', char(P)])
grid on
grid minor

%Analizando la grafica me pude dar cuenta que los puntos que funcionarian
%para poder realizar el debido proceso son: '0,95' y '1,05'. Los puntos
%hallados, no son los unicos puntos que cumplen con la condición, hay la
%misma cantidad de punto que el doble del grado del polinomio.
