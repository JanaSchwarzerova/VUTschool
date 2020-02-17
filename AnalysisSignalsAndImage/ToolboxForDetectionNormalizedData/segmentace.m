function [segmentovany_obraz_polovina,segmentovany_obraz] = segmentace(obr,centroid,extremy)
%Funkce segmentace má za úkol vysegmentovat spodní polovinu duhovku

%Princip:
%        Nastavení segmentovaného prahu, jako optimální vzdálenosti od
%        støedu èoèky, kvùli odstranìní míst, kde zasahují øasy, èi celkovì
%        spodní víèko
%        Pomocí regionprops pøi zpracování je rozmìøena duhovka, díky èemuž
%        zjistíme polomìr, ten následnì zvìtšíme 1.3krát -> a zvìtšený
%        polomìr se porovnává se støedem pixelu (vzdálenost od centroidu (støedu))
%        Pokud je vzdálenost vìtší, než polomìr tak informaci zachováváme,
%        pokud menší, informace je nepodstatná

%Vstupy: obr ... vstupní obraz
%        centroid ... støed nacházející se v èoèce
%        extremy ... souøadnice extrémních hodnot

%Výstupy: segmentovany_obraz_polovina ... výsledný segmentovaný obraz, dolní polovina 
%         segmentovany_obraz ... celý výslený segmentovaný obraz

%Urèení souøadnice dolního levého rohu
bottom_left=extremy(1).Extrema(5,:); 
%vzdálenost souøadnice top-left a left-bottom
polomer_cocky=sqrt((centroid(2)-bottom_left(2))^2+(bottom_left(1)-centroid(1))^2);
%Polomìr duhovky
polomer_duhovky = polomer_cocky*1.8; 

velikost_obrazu=size(obr);
radek=velikost_obrazu(1);
sloupec=velikost_obrazu(2);
segmentovany_obraz=[];
segmentovany_obraz_polovina=[]; 

 for i=1:radek
     for j=1:sloupec
         vzdalenost_aktualni_centorid=sqrt((i-centroid(2))^2+(j-centroid(1))^2);
         vzdalenost_aktual_pulka=sqrt((i-(centroid(1,2)+polomer_duhovky))^2+(j-j)^2); 
         if vzdalenost_aktualni_centorid <= polomer_duhovky 
         %Pokud je vzdálenost pixelu od centroidu menší než práh, uložím obraz
             segmentovany_obraz(i,j)=obr(i,j);
            if vzdalenost_aktualni_centorid <= polomer_cocky 
            %Pokud je vzdálenost pixelu menší než menší práh, vynuluju
                segmentovany_obraz(i,j)=0;
            end 
         else segmentovany_obraz(i,j)=0; 
            %Odstranìní zbytkù
         end
         if vzdalenost_aktual_pulka <= polomer_duhovky
             segmentovany_obraz_polovina(i,j)=segmentovany_obraz(i,j);
         else
             segmentovany_obraz_polovina(i,j)=0;
         end
     end
 end