function Vystup_obraz = Lee_Filtr(Vstup_obraz,sirka_okna)
%% Lee filtr
% inspirace od:
%   -> autor: Grzegorz Mianowski
%   -> https://www.mathworks.com/matlabcentral/fileexchange/28046-lee-filter

% Lee filtr je založen na pravdìpodobnostní funkci sigma Gaussova rozdìlení

% Vstup_obraz = ultrazvukový obraz, pøed zpracováním pomocí Lee filtru
%               musí být typu double
% Vystup_obraz = ultrazvukový obraz, po zpracovaní pomocí Lee filtru
% sirka_okna = šíøka použitého okna 

Vystup_obraz = Vstup_obraz; %Ošetøení stejného rozmìru obrazku vstupního a výstupního

prumer = imfilter(Vstup_obraz, fspecial('average', sirka_okna), 'replicate');
                            % Výpoèet prùmìru pomocí funkce imfilter – filtraèní operace
                            % 'replicate' – specifická možnost hranice u funkce imfilter
sigmas = sqrt((Vstup_obraz-prumer).^2/sirka_okna^2);
                            % Výpoèet sigma 
sigmas = imfilter(sigmas, fspecial('average', sirka_okna), 'replicate');
                            % Pøefiltrování sigma pomocí funkce imfilter

ENLs = (prumer./sigmas).^2;
sx2s = ((ENLs.*(sigmas).^2) - prumer.^2)./(ENLs + 1);
fbar = prumer + (sx2s.*(Vstup_obraz-prumer)./(sx2s + (prumer.^2 ./ENLs)));

%Výsledek
Vystup_obraz(prumer~=0) = fbar(prumer~=0);