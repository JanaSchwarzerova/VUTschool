function [Vystup_1,Vystup_2,Vystup_3] = Prahovani(Vstup_obraz,Prah_1, Prah_3_D, Prah_3_H)

% Prahovani je funkce, ve kter� jsou zn�zorn�ny t�i r�zn� algoritmy prahov�n�
% Vstup_obraz ... vstupn� obraz, na kter�m se provede segmentace prahov�n�
%                 v�emi zde zn�zorn�n�mi algoritmy
% Prah_1 ... ur�en� z�kladn�ho prahu v Prvn�m algoritmu
% Prah_3_D ... ur�en� doln�ho prahu v T�et�m algortimu
% Prah_3_H ... ur�en� horn�ho prahu v T�et�m algortimu
% Vystup_1 ... v�stupn� obraz neboli segmentovan� obraz prvn�m alegoritmem
%              tedy jednoduch�m/z�kladn�m prahov�n�m
% Vystup_2 ... v�stupn� obraz neboli segmentovan� obraz druh�m alegoritmem
%              pomoc� funkce graythresh
% V�stup_3 ... v�stupn� obraz neboli segmentovan� obraz t�et�m alegoritmem
%              tedy dvojit�m prahov�n�m 

%% __________________________________________________________________________
% PRAHOV�N�
%
%*************************Prvn� algoritmus*********************************
%_________________ Z�KLADN� PRAHOV�N� neboli prost�________________________  
% 
% K�d p�evzat� z: 
% Anal�za biomedic�nsk�ch obraz� (Po��ta�ov� cvi�en�)
% Autor: Ing. Petr Walek, Ing. Martin Lamo�, prof. Ji�� Jan
% Algoritmus 9.22: Prost� a dvojit� prahov�n�

Vystup_1 = zeros(size(Vstup_obraz));
Vystup_1 (Vstup_obraz>Prah_1)= 1; %Nadprahov� hodnoty se zm�n� na jedni�ku
Vystup_1 (Vstup_obraz<Prah_1)= 0; %Podprahov� na nulu

%*************************Druh� algoritmus*********************************
% _____________________Pomoc� funkce graythresh ___________________________

Prah_2 = graythresh(Vstup_obraz);     %Ur�en� glob�ln� prahov� hodnoty pomoc� metody Otu
Vystup_2 = im2bw(Vstup_obraz,Prah_2); %P�eveden� obrazu na bin�rn� obraz pomoc� prahov� hodnoty

%*************************T�et� algoritmus*********************************
%________________________ DVOJT� PRAHOV�N� ________________________________  
% 
% K�d p�evzat� z: 
% Anal�za biomedic�nsk�ch obraz� (Po��ta�ov� cvi�en�)
% Autor: Ing. Petr Walek, Ing. Martin Lamo�, prof. Ji�� Jan
% Algoritmus 9.22: Prost� a dvojit� prahov�n�

Vystup_3 = zeros(size(Vstup_obraz));
Vystup_3 = zeros(size(Vstup_obraz));
Vystup_3(Vstup_obraz>Prah_3_D & Vstup_obraz<Prah_3_H)= 1; %Nadprahov� hodnoty doln�ho prahu a 
                                                          %podprahov� horn�ho se zm�n� na jedni�ku
Vystup_3(Vstup_obraz<Prah_3_D & Vstup_obraz>Prah_3_H)= 0; %Podprahov� hodnoty doln�ho prahu a 
                                                          %nadprahov� horn�ho se zm�n� na nulu

