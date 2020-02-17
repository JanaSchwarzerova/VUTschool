function [orezany_obraz] = polovina(segmentovany_obraz)
% Funkce polovina m� za �kol o�ezato oblast z�jmu 
% Vstup: segmentovany_obraz ... vstupn� obraz
% V�stup: orezany_obraz... v�stupn� o�ezan� obraz, na kter�m se nach�z� 
%                          oblast z�jmu, kterou n�sledn� detekujeme 

 %O�ez�n� ��dk�
 [radek,~] = size(segmentovany_obraz);
 pul = [];
 for i = 1:radek
     soucet(i) = sum(segmentovany_obraz(i,:));
 end
 
 %O�ez�n� sloupc�
 [~, pozice] = find(soucet ~= 0);
 pul = [];
 pul = segmentovany_obraz(pozice,:);
 [~, sloupecp] = size(pul);
 for i = 1:sloupecp
     soucet(i) = sum(segmentovany_obraz(:,i));
 end
 
 %O�ezan� obraz
 [~, pozicep] = find(soucet ~= 0);
 orezany_obraz = [];
 orezany_obraz = pul(:,pozicep);
 
end