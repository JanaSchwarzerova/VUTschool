function [K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah)
%Funkce korelace_detekce vypoèítá korelaci mezi charakteristickou vlnkou/kmitem 
%pro jeden krok a namìøeným signálem a následnì detekuje pøes nastavené
%prahy jednotlivé kroky

%Vstupy: 
%       r = vstupní signál 
%       ref_x = charakteristická vlny/kmit jednoho kroku pro konkrétní
%               signál

%Výstupy: 
%       K = výstupní korelace
%       P2 = detekce jednotlivých krokù 

ref_x = ref_x(end:-1:1); %Pøevrácení vlny jednoho kroku
K = conv(r,ref_x);       %Provedení korelace

%Nalezení píkù signalizující jednotlivé kroky
[P2,pozice2] = findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah);

end

