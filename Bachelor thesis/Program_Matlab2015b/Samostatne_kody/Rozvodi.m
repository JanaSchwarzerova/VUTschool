function [Vystup_Sobel, Vystup_Robin, Vystup_Prewitt] = Rozvodi(Vstup_obraz)

% Rozvodi je funkce/algoritmus pro segmetaèní metodu rozvodí. 

% Vstup_obraz ... vstupní obraz, na kterém se provede segmentace 
% Vystup_Sobel ... výstupní obraz neboli segmentovaný obraz metodou rozvodi
%              ... gradientní obraz je zde získaný pomocí Sobbelovy masky
% Vystup_Robin ... výstupní obraz neboli segmentovaný obraz metodou rozvodi
%              ... gradientní obraz je zde získaný pomocí Robinsonovy masky
% Vystup_Prewitt ... výstupní obraz neboli segmentovaný obraz metodou rozvodi
%                ... gradientní obraz je zde získaný pomocí Prewittovy masky


%% __________________________________________________________________________
% ROZVODÍ

%************************************************************************** 
% Kód pøevzaný z: 
% Analýza biomedicínských obrazù (Poèítaèové cvièení)
% Autor: Ing. Petr Walek, Ing. Martin Lamoš, prof. Jiøí Jan
% Algoritmus 9.24: Segmentaèní metoda rozvodí

%Gradientní obraz získaný pomocí Sobelovy masky v obou smìrech
Sobel_x = [-1 0 1;-2 0 2;-1 0 1];
Sobel_y = [-1 0 1;-2 0 2;-1 0 1]';
F_x = conv2(Vstup_obraz,Sobel_x, 'same'); 
F_y = conv2(Vstup_obraz,Sobel_y, 'same');
F = sqrt(F_x.*F_x+F_y.*F_y);
F_kvant = grayslice(F,100); %Snížení poètu kvantovacích hladin 

Vysledek = watershed(F_kvant); %Segmentace metodou rozvodí
RGB_vysledek = label2rgb(Vysledek, 'spring', 'k', 'shuffle');

Vystup_Sobel = RGB_vysledek;

%Gradientní obraz získaný pomocí Robinsonovy masky v obou smìrech
Robinson_x = [-1 -1 -1;1 -2 1;1 1 1];
Robinson_y = [-1 -1 -1;1 -2 1;1 1 1]';
F_x = conv2(Vstup_obraz,Robinson_x, 'same');
F_y = conv2(Vstup_obraz,Robinson_y, 'same');
F = sqrt(F_x.*F_x+F_y.*F_y);
F_kvant = grayslice(F,50); %Snížení poètu kvantovacích hladin 

Vysledek = watershed(F_kvant); %Segmentace metodou rozvodí
RGB_vysledek = label2rgb(Vysledek,'spring', 'k', 'shuffle');

Vystup_Robin = RGB_vysledek;

%Gradientní obraz získaný pomocí Prewittùv operátor (5x5) v obou smìrech
Prewitt_x = [-2 -2 -2 -2 -2;-1 -1 -1 -1 -1;0 0 0 0 0;1 1 1 1 1;2 2 2 2 2];
Prewitt_y = [-2 -2 -2 -2 -2;-1 -1 -1 -1 -1;0 0 0 0 0;1 1 1 1 1;2 2 2 2 2]';

F_x = conv2(Vstup_obraz,Prewitt_x, 'same');
F_y = conv2(Vstup_obraz,Prewitt_y, 'same');
F = sqrt(F_x.*F_x+F_y.*F_y);
F_kvant = grayslice(F,50); %Snížení poètu kvantovacích hladin 

Vysledek = watershed(F_kvant); %Segmentace metodou rozvodí
RGB_vysledek = label2rgb(Vysledek, 'spring', 'k', 'shuffle');

Vystup_Prewitt = RGB_vysledek;
