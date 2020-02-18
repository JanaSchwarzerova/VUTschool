function [Vystup_Sobel, Vystup_Robin, Vystup_Prewitt] = Rozvodi(Vstup_obraz)

% Rozvodi je funkce/algoritmus pro segmeta�n� metodu rozvod�. 

% Vstup_obraz ... vstupn� obraz, na kter�m se provede segmentace 
% Vystup_Sobel ... v�stupn� obraz neboli segmentovan� obraz metodou rozvodi
%              ... gradientn� obraz je zde z�skan� pomoc� Sobbelovy masky
% Vystup_Robin ... v�stupn� obraz neboli segmentovan� obraz metodou rozvodi
%              ... gradientn� obraz je zde z�skan� pomoc� Robinsonovy masky
% Vystup_Prewitt ... v�stupn� obraz neboli segmentovan� obraz metodou rozvodi
%                ... gradientn� obraz je zde z�skan� pomoc� Prewittovy masky


%% __________________________________________________________________________
% ROZVOD�

%************************************************************************** 
% K�d p�evzan� z: 
% Anal�za biomedic�nsk�ch obraz� (Po��ta�ov� cvi�en�)
% Autor: Ing. Petr Walek, Ing. Martin Lamo�, prof. Ji�� Jan
% Algoritmus 9.24: Segmenta�n� metoda rozvod�

%Gradientn� obraz z�skan� pomoc� Sobelovy masky v obou sm�rech
Sobel_x = [-1 0 1;-2 0 2;-1 0 1];
Sobel_y = [-1 0 1;-2 0 2;-1 0 1]';
F_x = conv2(Vstup_obraz,Sobel_x, 'same'); 
F_y = conv2(Vstup_obraz,Sobel_y, 'same');
F = sqrt(F_x.*F_x+F_y.*F_y);
F_kvant = grayslice(F,100); %Sn�en� po�tu kvantovac�ch hladin 

Vysledek = watershed(F_kvant); %Segmentace metodou rozvod�
RGB_vysledek = label2rgb(Vysledek, 'spring', 'k', 'shuffle');

Vystup_Sobel = RGB_vysledek;

%Gradientn� obraz z�skan� pomoc� Robinsonovy masky v obou sm�rech
Robinson_x = [-1 -1 -1;1 -2 1;1 1 1];
Robinson_y = [-1 -1 -1;1 -2 1;1 1 1]';
F_x = conv2(Vstup_obraz,Robinson_x, 'same');
F_y = conv2(Vstup_obraz,Robinson_y, 'same');
F = sqrt(F_x.*F_x+F_y.*F_y);
F_kvant = grayslice(F,50); %Sn�en� po�tu kvantovac�ch hladin 

Vysledek = watershed(F_kvant); %Segmentace metodou rozvod�
RGB_vysledek = label2rgb(Vysledek,'spring', 'k', 'shuffle');

Vystup_Robin = RGB_vysledek;

%Gradientn� obraz z�skan� pomoc� Prewitt�v oper�tor (5x5) v obou sm�rech
Prewitt_x = [-2 -2 -2 -2 -2;-1 -1 -1 -1 -1;0 0 0 0 0;1 1 1 1 1;2 2 2 2 2];
Prewitt_y = [-2 -2 -2 -2 -2;-1 -1 -1 -1 -1;0 0 0 0 0;1 1 1 1 1;2 2 2 2 2]';

F_x = conv2(Vstup_obraz,Prewitt_x, 'same');
F_y = conv2(Vstup_obraz,Prewitt_y, 'same');
F = sqrt(F_x.*F_x+F_y.*F_y);
F_kvant = grayslice(F,50); %Sn�en� po�tu kvantovac�ch hladin 

Vysledek = watershed(F_kvant); %Segmentace metodou rozvod�
RGB_vysledek = label2rgb(Vysledek, 'spring', 'k', 'shuffle');

Vystup_Prewitt = RGB_vysledek;
