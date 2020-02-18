function Vystup_obraz = Lee_Filtr(Vstup_obraz,sirka_okna)
%% Lee filtr
% inspirace od:
%   -> autor: Grzegorz Mianowski
%   -> https://www.mathworks.com/matlabcentral/fileexchange/28046-lee-filter

% Lee filtr je zalo�en na pravd�podobnostn� funkci sigma Gaussova rozd�len�

% Vstup_obraz = ultrazvukov� obraz, p�ed zpracov�n�m pomoc� Lee filtru
%               mus� b�t typu double
% Vystup_obraz = ultrazvukov� obraz, po zpracovan� pomoc� Lee filtru
% sirka_okna = ���ka pou�it�ho okna 

Vystup_obraz = Vstup_obraz; %O�et�en� stejn�ho rozm�ru obrazku vstupn�ho a v�stupn�ho

prumer = imfilter(Vstup_obraz, fspecial('average', sirka_okna), 'replicate');
                            % V�po�et pr�m�ru pomoc� funkce imfilter � filtra�n� operace
                            % 'replicate' � specifick� mo�nost hranice u funkce imfilter
sigmas = sqrt((Vstup_obraz-prumer).^2/sirka_okna^2);
                            % V�po�et sigma 
sigmas = imfilter(sigmas, fspecial('average', sirka_okna), 'replicate');
                            % P�efiltrov�n� sigma pomoc� funkce imfilter

ENLs = (prumer./sigmas).^2;
sx2s = ((ENLs.*(sigmas).^2) - prumer.^2)./(ENLs + 1);
fbar = prumer + (sx2s.*(Vstup_obraz-prumer)./(sx2s + (prumer.^2 ./ENLs)));

%V�sledek
Vystup_obraz(prumer~=0) = fbar(prumer~=0);