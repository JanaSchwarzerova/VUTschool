function [ref_x] = jeden_krok(r,okno)
%Funkce jeden_krok stanovuje vlnu/kmit, který je charakteristický
%u konkréního namìøeného signálu pro jeden krok.

%Vstupy: 
%       r = vstupní signál 
%       okno = délka okna, které klouže po signálu, pomocí kterého se 
%              signál po urèitých charakteristických vlnách zprùmìruje
%              a tím dostaneme charakteristickou vlnu/kmit jednoho kroku
%              - okno je doporuèené defaultnì volit stejnì jako fvz
%Výstupy: 
%       ref_x = charakteristická vlny/kmit jednoho kroku pro konkrétní
%               signál

    for i = 1:okno:length(r)-20 %Okno projíždí signál 
        if i==1
            ref_x1 = r(i:i+9);
            ref_x2 = r(i+10:i+19);
        else
            ref_x1 = ref_x;
            ref_x2 = r(i+10:i+19);
        end
        for j = 1:length(ref_x1)
           ref_x(j)= mean([ref_x1(j),ref_x2(j)]); %Prùmìrují se charakteristické 
                                                  %vlny pro jednotlivé kroky
        end
    end
end

