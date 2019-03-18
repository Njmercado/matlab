classdef Function
    properties
        tolerance
        polynomial
        counter
    end
    
    methods 
        function obj = Function()
            syms x
            
            obj.tolerance  = 0.00001;
            obj.polynomial = x^2-1; %Function by default
            counter = 0;
        end
        
        function y = RegulaFalsi(obj, p1, p2)
     
            syms x

            sw = true;
            root = 0;
            old_root = 0;
            obj.counter = 0;
            
            while(sw)
        
                fp1 = subs(obj.polynomial,x,p1);
                fp2 = subs(obj.polynomial,x,p2);
                root = (fp1*p2-fp2*p1)/(fp1-fp2);
                froot = subs(obj.polynomial,x,root);
        
                if(froot*fp1==0)
                    break
                else
                    
                    if(froot*fp1<0)
                        p2 = root;
                    else
                        p1 = root;
                    end
                    
                    error = abs(root-old_root)/root;
                    sw = ~(error < obj.tolerance);
                    old_root = root;
                end
        
                obj.counter = obj.counter + 1;
            end
            
            fprintf('Se realizó(aron) %1.0f iteracion(es)\n', obj.counter)
            y = root;
        end%Regula Falsi
        
        
        function y = Wilkinson(obj, n)
            syms x
            func = 1;
            
            for i=1:n
                func = func*(x-i);
            end
            
            y = expand(func);
        end%Wilkinson
        
        
        function y = NewtonRaphson(obj)
            
            syms x
            
            dp = diff(obj.polynomial); %Derivative
            newton = x - obj.polynomial/dp; %Newton function
            sw = 1;
            x_n = 0;
            x_0 = obj.NewtonRaphsonCondition();
            obj.counter = 0;
            
            while (sw==1)
                x_n = x_0;
                x_0 = subs(newton, x, x_0);
    
                error = abs(x_n-x_0)/x_n;
                
                obj.counter = obj.counter + 1;
                
                sw = ~(error<obj.tolerance);
            end
            
            fprintf('Se realizó(aron) %1.0f iteracion(es)\n', obj.counter)
            y = x_0;
            
        end%Newton Raphson
    
    end%Methods
    
    methods(Hidden)
        
        %This function allow me to choose a good beginning point.
        %Also help me to reduce cycles to process data.
        function y = NewtonRaphsonCondition(obj)
            
            syms x
            
            y = randi([5 10]);%Arbitrary interval. Could be whatever i want.
            d2p = diff(obj.polynomial, 2);%Second derivative
            t = y*subs(d2p, x, y);%Condition to get a good point. If this is gt 0, then in good.
            
            while(t<=0)
               
               y = randi([5 10]);
               t = y*subs(d2p, x, y);
            end
            
        end%Newton Raphson Condition
    
    end%Methods(Hidden)
end