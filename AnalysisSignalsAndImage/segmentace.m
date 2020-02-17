function [segmentovany_obraz_polovina,segmentovany_obraz] = segmentace(obr,centroid,extremy)
%Funkce segmentace m� za �kol vysegmentovat spodn� polovinu duhovku

%Princip:
%        Nastaven� segmentovan�ho prahu, jako optim�ln� vzd�lenosti od
%        st�edu �o�ky, kv�li odstran�n� m�st, kde zasahuj� �asy, �i celkov�
%        spodn� v��ko
%        Pomoc� regionprops p�i zpracov�n� je rozm��ena duhovka, d�ky �emu�
%        zjist�me polom�r, ten n�sledn� zv�t��me 1.3kr�t -> a zv�t�en�
%        polom�r se porovn�v� se st�edem pixelu (vzd�lenost od centroidu (st�edu))
%        Pokud je vzd�lenost v�t��, ne� polom�r tak informaci zachov�v�me,
%        pokud men��, informace je nepodstatn�

%Vstupy: obr ... vstupn� obraz
%        centroid ... st�ed nach�zej�c� se v �o�ce
%        extremy ... sou�adnice extr�mn�ch hodnot

%V�stupy: segmentovany_obraz_polovina ... v�sledn� segmentovan� obraz, doln� polovina 
%         segmentovany_obraz ... cel� v�slen� segmentovan� obraz

%Ur�en� sou�adnice doln�ho lev�ho rohu
bottom_left=extremy(1).Extrema(5,:); 
%vzd�lenost sou�adnice top-left a left-bottom
polomer_cocky=sqrt((centroid(2)-bottom_left(2))^2+(bottom_left(1)-centroid(1))^2);
%Polom�r duhovky
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
         %Pokud je vzd�lenost pixelu od centroidu men�� ne� pr�h, ulo��m obraz
             segmentovany_obraz(i,j)=obr(i,j);
            if vzdalenost_aktualni_centorid <= polomer_cocky 
            %Pokud je vzd�lenost pixelu men�� ne� men�� pr�h, vynuluju
                segmentovany_obraz(i,j)=0;
            end 
         else segmentovany_obraz(i,j)=0; 
            %Odstran�n� zbytk�
         end
         if vzdalenost_aktual_pulka <= polomer_duhovky
             segmentovany_obraz_polovina(i,j)=segmentovany_obraz(i,j);
         else
             segmentovany_obraz_polovina(i,j)=0;
         end
     end
 end