function Vystup_obraz = Frost_Filtr(Vstup_obraz,maska)
%% Frost filtr
% pøevzato od: 
%     -> autor: Debdoot Sheet
%     -> https://www.mathworks.com/matlabcentral/fileexchange/35073-frost-s-filter?s_tid=srchtitle

% Funkce Frost_Filtr provádí filtrování obrazového šumu na základì použití 
% adaptivního filtru, který navrhl Frost. Používá informace o ètvercových
% sousední maticích pixelu o rozmìrech 5x5 pixelù, pro odhad statistiky 
% šedé úrovnì ve výchozím nastavení.

% Funkce Frost_Filtr provádí filtrování s lokálními statistikami 
% vypoèítanými na základì sousedù, jak je uvedeno v lokálnì hodnocené matici MASK.

% Vstup_obraz = ultrazvukový obraz, pøed zpracováním pomocí Lee filtru
% Vystup_obraz = ultrazvukový obraz, po zpracovaní pomocí Lee filtru
% maska =  lokálnì hodnocená matice 

if nargin == 1       % nargin vrátí poèet vstupních argumentù pøedaných ve volání do právì probíhající funkce 
    maska = getnhood(strel('square',5)); 
                     % Informace o ètvercových sousední maticích pixelu 
                     % o rozmìrech 5x5 pixelù, pro odhad statistiky 
                     % šedé úrovnì ve výchozím nastavení.
elseif nargin == 2   % nargin vrátí poèet vstupních argumentù pøedaných ve volání do právì probíhající funkce 
    if ~islogical(maska)    % pokud maska není logicky hodnocená vyhodí se error
        error('Maska musí být logicky hodnocená matice');
    end
else                        % jakákoli jiná chyb, znaèí špatné volání funkce
    error('Špatné volání funkce Frost_Filtr'); 
end

Typ_obr = class(Vstup_obraz); % class vrátí øetìzec specifikující tøídu – "class" objektu
Rozmery_okna = size(maska);   % size vrátí rozmìry masky (šíøku i délku)

Vstup_obraz = padarray(Vstup_obraz,[floor(Rozmery_okna(1)/2) floor(Rozmery_okna(2)/2)],'symmetric','both');
% paddarray vyplní pøed prvním prvkem a za posledním prvkem podél zadané
% dimenze èísla, zaokrouhlená dolù a vydìlená dvìmi, nacházející se v
% Rozmery_okna(1) nebo Rozmery_okna(2)

[n_radek,n_sloupec] = size(Vstup_obraz); % size vrátí rozmìry masky (šíøku i délku)
Vystup_obraz = Vstup_obraz;      % Ošetøení stejného rozmìru obrazku vstupního a výstupního

[xInd_mrizka yInd_mrizka] = meshgrid(-floor(Rozmery_okna(1)/2):floor(Rozmery_okna(1)/2),-floor(Rozmery_okna(2)/2):floor(Rozmery_okna(2)/2));
% meshgird vytvoøí obdelníkovou møížku (matici èísel) xInd_mrizka a yInd_mrizka

exp_vaha = exp(-(xInd_mrizka.^2 + yInd_mrizka.^2).^0.5); %Vytvoøení exponenciální váhové hodnoty

for i=ceil(Rozmery_okna(1)/2):n_radek-floor(Rozmery_okna(1)/2)
    %for cyklus pro projetí celého obrazu oknem pro øádky
    for j=ceil(Rozmery_okna(2)/2):n_sloupec-floor(Rozmery_okna(2)/2)
        %for cyklus pro projetí celého obrazu oknem pro sloupce
        lokalni_okoli = Vstup_obraz(i-floor(Rozmery_okna(1)/2):i+floor(Rozmery_okna(1)/2),j-floor(Rozmery_okna(2)/2):j+floor(Rozmery_okna(2)/2));
                                                 %Vytvoøení lokalního okolí
        lokalni_okoli = lokalni_okoli(maska);    %aplikace lokálního okolí na masku
        lokalni_prumer = mean(lokalni_okoli(:)); %výpoèet lokálního prùmìru
        localVar = var(lokalni_okoli(:));        %výpoøet lokální odchylky
        alfa = sqrt(localVar)/lokalni_prumer;    %výpoèet úhlu alfa
        lokalni_vaha = alfa*(exp_vaha.^alfa);    %výpoèet lokální váhové hodnoty
        lokalni_vaha_Lin = lokalni_vaha(maska);  %aplikace lokální váhy na masku
        lokalni_vaha_Lin = lokalni_vaha_Lin/sum(lokalni_vaha_Lin(:)); 
        Vystup_obraz(i,j) = sum(lokalni_vaha_Lin.*lokalni_okoli);
    end
end

%Výstup funkce
Vystup_obraz = Vystup_obraz(ceil(Rozmery_okna(1)/2):n_radek-floor(Rozmery_okna(1)/2),ceil(Rozmery_okna(2)/2):n_sloupec-floor(Rozmery_okna(2)/2));
Vystup_obraz = cast(Vystup_obraz,Typ_obr); %cast – promìní Vystup_obraz na datový typ na jakém byl na zaèátku Vstup_obraz