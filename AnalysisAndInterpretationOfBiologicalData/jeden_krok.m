function [ref_x] = jeden_krok(r,okno)
%Funkce jeden_krok stanovuje vlnu/kmit, kter� je charakteristick�
%u konkr�n�ho nam��en�ho sign�lu pro jeden krok.

%Vstupy: 
%       r = vstupn� sign�l 
%       okno = d�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
%              sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
%              a t�m dostaneme charakteristickou vlnu/kmit jednoho kroku
%              - okno je doporu�en� defaultn� volit stejn� jako fvz
%V�stupy: 
%       ref_x = charakteristick� vlny/kmit jednoho kroku pro konkr�tn�
%               sign�l

    for i = 1:okno:length(r)-20 %Okno proj�d� sign�l 
        if i==1
            ref_x1 = r(i:i+9);
            ref_x2 = r(i+10:i+19);
        else
            ref_x1 = ref_x;
            ref_x2 = r(i+10:i+19);
        end
        for j = 1:length(ref_x1)
           ref_x(j)= mean([ref_x1(j),ref_x2(j)]); %Pr�m�ruj� se charakteristick� 
                                                  %vlny pro jednotliv� kroky
        end
    end
end

