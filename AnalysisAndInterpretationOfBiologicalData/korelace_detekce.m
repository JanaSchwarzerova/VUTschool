function [K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah)
%Funkce korelace_detekce vypo��t� korelaci mezi charakteristickou vlnkou/kmitem 
%pro jeden krok a nam��en�m sign�lem a n�sledn� detekuje p�es nastaven�
%prahy jednotliv� kroky

%Vstupy: 
%       r = vstupn� sign�l 
%       ref_x = charakteristick� vlny/kmit jednoho kroku pro konkr�tn�
%               sign�l

%V�stupy: 
%       K = v�stupn� korelace
%       P2 = detekce jednotliv�ch krok� 

ref_x = ref_x(end:-1:1); %P�evr�cen� vlny jednoho kroku
K = conv(r,ref_x);       %Proveden� korelace

%Nalezen� p�k� signalizuj�c� jednotliv� kroky
[P2,pozice2] = findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah);

end

