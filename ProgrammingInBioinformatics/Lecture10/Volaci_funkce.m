function [ vystup ] = Volaci_funkce( a,b,c,d )

%Volací funkce 
%Vstupy: (ètyøi promìnné, celá èísla)
%        a,b,c,d
% a  ... poèet øádkù
% b  ... poèet sloupcù 
% c  ... krát
% d  ... mínus

%Matice se naplní náhodnými èísly v rozsahu -100 až 100.
matice = randi([-100 100],a,b);

matice = [2,10,52;-25,4,-71;37,0,-13];

%Volání rekurzivní funkce 
vystup = Rekurz_funkce( matice,c,d,1,1);


end

