function [ hodnota ] = Rekurz_funkce( a,b,c,d,e )

%Rekurzivní funkce
%Vstupy: (pìt vstupních parametrù, celá èísla)
%        a,b,c,d,e
% a ... vytvoøená matice z volací funkce
% b ... krát (z volací funkce)
% c ... mínust (z volací funkce)
% d,e ... starotovací pozice v matici
% Výstup: 
% hodnota ... jedna hodnota, která se uvnitø funkce poèítá

[poc_radku,poc_sloupcu] = size(a);

if (d == poc_radku) || (e == poc_sloupcu)
    hodnota = a(d,e);
else
    hodnota = a(d,e);
    zdola = Rekurz_funkce( a,b,c,d+1,e );
    zprava = Rekurz_funkce( a,b,c,d,e+1 );
    diagonal = Rekurz_funkce( a,b,c,d+1,e+1 ); 
    
    zdola = (zdola*b)-c;
    zprava = (zprava*b)-c;
    diagonal = (diagonal*b)-c;
    
    %Pravidlo výbìru
    [~, pozice] = min(abs([1-abs(zdola),1-abs(zprava),1-abs(diagonal)]));
    
    if pozice == 1
    hodnota = abs(zdola) + hodnota;
    elseif pozice == 2
    hodnota = abs(zprava) + hodnota;
    elseif pozice == 3
    hodnota = abs(diagonal) + hodnota;
    end
end


end

