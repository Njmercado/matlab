clear all;
clc;

%orden = input('Que grado de regresion desea (Por favor ingrese un numero mayor a 0): ')
orden = 2;
%x = input('Ingrese los valores de X: ')
x = [1 4 5 7];
%y = input('Ingrese los valores de Y: ')
y = [3 7 5 4];

m = zeros(orden+1, orden+1); %Matriz de ceros para llenar despues.
ys = zeros(1, orden+1);

[m n] = size(y); %Podria ser cualquiera, tanto x o y, la cuestion es que son del mismo tamaño

for i=1:orden+1
    
    for j=1:i
        
        k = i + j - 2;
        suma = 0;
        
        for l = 1: n
            suma = suma + x(1, l)^k;
        end
        
        m(i, j) = suma;
        m(j, i) = suma;
    end
    
    suma = 0;
    
    for l=1:n
        
        suma = suma + y(1, l)*x(1, l)^(i-1);
    end
    
    ys(1, i) = suma;
end

%Ahora hallo el resultado, coeficientes, de la ecuacion final.


a = ys*inv(m); %Coeficientes finales

syms x;

f = a(1, 3).*x.^2+a(1, 2).*x+a(1, 1);

disp('Resultado Final: ')
f