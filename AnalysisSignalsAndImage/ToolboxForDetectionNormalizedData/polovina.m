function [orezany_obraz] = polovina(segmentovany_obraz)
% Funkce polovina má za úkol oøezato oblast zájmu 
% Vstup: segmentovany_obraz ... vstupní obraz
% Výstup: orezany_obraz... výstupní oøezaný obraz, na kterém se nachází 
%                          oblast zájmu, kterou následnì detekujeme 

 %Oøezání øádkù
 [radek,~] = size(segmentovany_obraz);
 pul = [];
 for i = 1:radek
     soucet(i) = sum(segmentovany_obraz(i,:));
 end
 
 %Oøezání sloupcù
 [~, pozice] = find(soucet ~= 0);
 pul = [];
 pul = segmentovany_obraz(pozice,:);
 [~, sloupecp] = size(pul);
 for i = 1:sloupecp
     soucet(i) = sum(segmentovany_obraz(:,i));
 end
 
 %Oøezaný obraz
 [~, pozicep] = find(soucet ~= 0);
 orezany_obraz = [];
 orezany_obraz = pul(:,pozicep);
 
end