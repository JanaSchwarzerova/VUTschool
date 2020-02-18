function [ V ] = Mem_Fibo(n,V)

    %if V(n) == 0
        if n < 2 || n == 2 
            V(n) = 1;
            
        else  
            if V(n-1) == 0
            V = Mem_Fibo(n-1,V);
            end
            if V(n-2) == 0
            V = Mem_Fibo(n-2,V);
            end
            V(n) = V(n-1)+V(n-2);
        end
        
    %end
    
end