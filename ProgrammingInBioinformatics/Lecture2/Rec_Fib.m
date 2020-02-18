%% Fibbonacciho posloupnost

function [ vysledek ] = Rec_Fib(n)
    
    if n == 2 || n < 2
    vysledek = 1;
    else
    vysledek = Rec_Fib(n-1)+Rec_Fib(n-2);
    end

end