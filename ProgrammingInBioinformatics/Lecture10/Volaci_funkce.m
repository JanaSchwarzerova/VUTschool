function [ vystup ] = Volaci_funkce( a,b,c,d )

%Volac� funkce 
%Vstupy: (�ty�i prom�nn�, cel� ��sla)
%        a,b,c,d
% a  ... po�et ��dk�
% b  ... po�et sloupc� 
% c  ... kr�t
% d  ... m�nus

%Matice se napln� n�hodn�mi ��sly v rozsahu -100 a� 100.
matice = randi([-100 100],a,b);

matice = [2,10,52;-25,4,-71;37,0,-13];

%Vol�n� rekurzivn� funkce 
vystup = Rekurz_funkce( matice,c,d,1,1);


end

