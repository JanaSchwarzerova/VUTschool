function [ hodnota ] = Rekurz_funkce( a,b,c,d,e )

%Rekurzivn� funkce
%Vstupy: (p�t vstupn�ch parametr�, cel� ��sla)
%        a,b,c,d,e
% a ... vytvo�en� matice z volac� funkce
% b ... kr�t (z volac� funkce)
% c ... m�nust (z volac� funkce)
% d,e ... starotovac� pozice v matici
% V�stup: 
% hodnota ... jedna hodnota, kter� se uvnit� funkce po��t�

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
    
    %Pravidlo v�b�ru
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

