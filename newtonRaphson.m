clc;
syms x

f = @(x) x^3+2*x^2+2*x-1
df = matlabFunction(diff(f(x)))
tolerance = 0,0000002
x_0 = 3 % Valor inicial

result = @(x) x - f(x)/df(x)

domain = [-Inf Inf]
range = [0 Inf]

n = 1
auxTolerance = 1
error = 0
x_n = 0

while (auxTolerance && n < 200)
    x_n = x_0;
    x_0 = result(x_0);
    
    n = n+1;
    
    error = abs(x_n-x_0)/x_n
    auxTolerance = ~(error<tolerance);
end

x_n
subs(f,x,x_n)

hold on

plot(f(x_n),'ro')
fplot(f(x))