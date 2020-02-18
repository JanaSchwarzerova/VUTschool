function [Vystup_1,Vystup_2,Vystup_3] = Prahovani(Vstup_obraz,Prah_1, Prah_3_D, Prah_3_H)

% Prahovani je funkce, ve které jsou znázornìny tøi rùzné algoritmy prahování
% Vstup_obraz ... vstupní obraz, na kterém se provede segmentace prahování
%                 všemi zde znázornìnými algoritmy
% Prah_1 ... urèení základního prahu v Prvním algoritmu
% Prah_3_D ... urèení dolního prahu v Tøetím algortimu
% Prah_3_H ... urèení horního prahu v Tøetím algortimu
% Vystup_1 ... výstupní obraz neboli segmentovaný obraz prvním alegoritmem
%              tedy jednoduchým/základním prahováním
% Vystup_2 ... výstupní obraz neboli segmentovaný obraz druhým alegoritmem
%              pomocí funkce graythresh
% Výstup_3 ... výstupní obraz neboli segmentovaný obraz tøetím alegoritmem
%              tedy dvojitým prahováním 

%% __________________________________________________________________________
% PRAHOVÁNÍ
%
%*************************První algoritmus*********************************
%_________________ ZÁKLADNÍ PRAHOVÁNÍ neboli prosté________________________  
% 
% Kód pøevzatý z: 
% Analýza biomedicínských obrazù (Poèítaèové cvièení)
% Autor: Ing. Petr Walek, Ing. Martin Lamoš, prof. Jiøí Jan
% Algoritmus 9.22: Prosté a dvojité prahování

Vystup_1 = zeros(size(Vstup_obraz));
Vystup_1 (Vstup_obraz>Prah_1)= 1; %Nadprahové hodnoty se zmìní na jednièku
Vystup_1 (Vstup_obraz<Prah_1)= 0; %Podprahové na nulu

%*************************Druhý algoritmus*********************************
% _____________________Pomocí funkce graythresh ___________________________

Prah_2 = graythresh(Vstup_obraz);     %Urèení globální prahové hodnoty pomocí metody Otu
Vystup_2 = im2bw(Vstup_obraz,Prah_2); %Pøevedení obrazu na binární obraz pomocí prahové hodnoty

%*************************Tøetí algoritmus*********************************
%________________________ DVOJTÉ PRAHOVÁNÍ ________________________________  
% 
% Kód pøevzatý z: 
% Analýza biomedicínských obrazù (Poèítaèové cvièení)
% Autor: Ing. Petr Walek, Ing. Martin Lamoš, prof. Jiøí Jan
% Algoritmus 9.22: Prosté a dvojité prahování

Vystup_3 = zeros(size(Vstup_obraz));
Vystup_3 = zeros(size(Vstup_obraz));
Vystup_3(Vstup_obraz>Prah_3_D & Vstup_obraz<Prah_3_H)= 1; %Nadprahové hodnoty dolního prahu a 
                                                          %podprahové horního se zmìní na jednièku
Vystup_3(Vstup_obraz<Prah_3_D & Vstup_obraz>Prah_3_H)= 0; %Podprahová hodnoty dolního prahu a 
                                                          %nadprahové horního se zmìní na nulu

