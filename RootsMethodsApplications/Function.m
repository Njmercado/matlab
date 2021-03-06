classdef Function
    properties
        tolerance
        polynomial
        counter
        errors
        count
    end
    
    methods 
        function obj = Function()%init
            syms x
            errors = [];
            count = [];
            obj.tolerance  = 0.00005;
            obj.polynomial = x^2-1; %Function by default
            obj.counter = 0;
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function y = RegulaFalsi(obj, p1, p2)
     
            syms x

            sw = 1;
            root = 0;
            old_root = 0;
            obj.counter = 0;
            obj.errors = [];
            obj.count = [];
            while sw
        
                fp1 = subs(obj.polynomial,x,p1);
                fp2 = subs(obj.polynomial,x,p2);
                root = (fp1*p2-fp2*p1)/(fp1-fp2);
                froot = subs(obj.polynomial,x,root);
        
                if(froot*fp1==0)
                    break;
                else
                    
                    if(froot*fp1<0)
                        p2 = root;
                    else
                        p1 = root;
                    end
                    
                    error = (abs(root-old_root)/root)*100;
                    sw = ~(error < obj.tolerance);
                    old_root = root;
                    obj.errors = [obj.errors error];
                    obj.count = [obj.count obj.counter];
                end
        
                obj.counter = obj.counter + 1;
            end
        
            obj.Message(obj.counter)
            y = root;
        end%Regula Falsi
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function y = Wilkinson(obj, n)
            syms x
            func = 1;
            
            for i=1:n
                func = func*(x-i);
            end
            
            y = expand(func);
        end%Wilkinson
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function y = NewtonRaphson(obj, x_0)
            
            syms x
            
            dp = diff(obj.polynomial); %Derivative
            obj.counter = 0;
            
            if dp~=0
                
                newton = x - obj.polynomial/dp; %Newton function
                sw = 1;
                x_n = 0;
                %[x_0, warning] = obj.NewtonRaphsonCondition(interval);
                
                %if warning
                    
                 %   fprintf('WARNING:\n')
                  %  fprintf('No hay certeza de que la función ingresada converga tan rapido como deberia\n')
                   % fprintf('ya que podría tener un punto de inflexion.\n\n')
                %end

                while sw
                    x_n = x_0;
                    x_0 = subs(newton, x, x_0);
    
                    error = (abs(x_n-x_0)/x_n)*100;
                
                    obj.counter = obj.counter + 1;
                
                    sw = ~(error<obj.tolerance);
                end
            
                obj.Message(obj.counter)
                y = x_0;
            else
                fprintf('No se puede hallar la raiz de la función, ya que la primera derivada es igual a 0')
            end
            
        end%Newton Raphson
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function y = Bisection(obj, a, b)
            
            syms x
            sw = 1;
            y = 0;
            y_old = 0;
            error = 0;
            obj.counter = 0;
            
            while(sw==1)

                y = (a+b)/2;

                if(subs(obj.polynomial,x,a)*subs(y,x,y)==0)
                    break;
                else
                    if(subs(obj.polynomial,x,a)*subs(obj.polynomial,x,y)<0)
                        b = y;
                    else
                        a = y;
                    end       
                end

                error = (abs(y-y_old)/y)*100;
                y_old = y;
                
                obj.counter = obj.counter + 1;
                
                sw = ~(error < obj.tolerance);
            end
            
            obj.Message(obj.counter)
        end%Bisection
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function y = Secant(obj, x0, x1)
            
            syms x
            sw = 1;
            y_old = 0;
            error = 0;
            
            while sw % Sw = 0

                y = (x1*subs(obj.polynomial,x,x0)-x0*subs(obj.polynomial,x,x1))/(subs(obj.polynomial,x,x0)- subs(obj.polynomial,x,x1));
                x0 = x1;
                x1 = y;
                obj.counter = obj.counter+1;
                error = (abs(y-y_old)/y)*100;
                y_old = y;
                sw = ~(error < obj.tolerance);
            end
            
            obj.Message(obj.counter)
        end%Secant
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function y = FixedPoint(obj, x_0)
            
            syms x;
            dg = diff(obj.polynomial,x);
            y=x_0;
            obj.counter = 0;
            
            if abs(subs(dg,x,y)) < 1
                
                error = 0;
                sw = 1;
                
                while sw
                 
                    xi = subs(obj.polynomial, x, y);
                    
                    error = abs((xi-y)/xi)*100;
                    sw = ~(error<obj.tolerance);
                    
                    obj.counter = obj.counter + 1;
                    
                    y = xi;
                end
                
            else
                disp('El metodo no converge con el punto dado.')
                y = NaN;
            end
        
            obj.Message(obj.counter)
        end%Fixed Point
        
    end%Methods
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    methods(Hidden)
        
        %This function allow me to choose a good beginning point.
        %Also help me to reduce cycles to process data.
        function [y, warning] = NewtonRaphsonCondition(obj, interval)
            
            syms x;
            
            a = interval(1);
            b = interval(2);
            
            y = (b-a)*rand(1,1,'double')+a;
            d2p = diff(obj.polynomial, 2);%Second derivative
            d2p = solve(d2p, x);%Reduce as much as possible.
            t = 0;
            
            if d2p~=0 %Not const
            
                t = y*subs(d2p, x, y);%Condition to get a good point. If this is gt 0, then in good.
            
                while(t<0)
               
                    y = (b-a)*rand(1,1,'double')+a;
                    t = y*subs(d2p, x, y);
                end
                
            else
                warning = 1;
            end
            
        end%Newton Raphson Condition
    
        
        function message = Message(obj, count)
            fprintf('Se realizó(aron) %1.0f iteracion(es)\n\n', count)
        end %Message
        
    end%Methods(Hidden)
end