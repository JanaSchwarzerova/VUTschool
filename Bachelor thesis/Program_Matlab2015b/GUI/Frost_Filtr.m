function Vystup_obraz = Frost_Filtr(Vstup_obraz,maska)
%% Frost filtr
% p�evzato od: 
%     -> autor: Debdoot Sheet
%     -> https://www.mathworks.com/matlabcentral/fileexchange/35073-frost-s-filter?s_tid=srchtitle

% Funkce Frost_Filtr prov�d� filtrov�n� obrazov�ho �umu na z�klad� pou�it� 
% adaptivn�ho filtru, kter� navrhl Frost. Pou��v� informace o �tvercov�ch
% sousedn� matic�ch pixelu o rozm�rech 5x5 pixel�, pro odhad statistiky 
% �ed� �rovn� ve v�choz�m nastaven�.

% Funkce Frost_Filtr prov�d� filtrov�n� s lok�ln�mi statistikami 
% vypo��tan�mi na z�klad� soused�, jak je uvedeno v lok�ln� hodnocen� matici MASK.

% Vstup_obraz = ultrazvukov� obraz, p�ed zpracov�n�m pomoc� Lee filtru
% Vystup_obraz = ultrazvukov� obraz, po zpracovan� pomoc� Lee filtru
% maska =  lok�ln� hodnocen� matice 

if nargin == 1       % nargin vr�t� po�et vstupn�ch argument� p�edan�ch ve vol�n� do pr�v� prob�haj�c� funkce 
    maska = getnhood(strel('square',5)); 
                     % Informace o �tvercov�ch sousedn� matic�ch pixelu 
                     % o rozm�rech 5x5 pixel�, pro odhad statistiky 
                     % �ed� �rovn� ve v�choz�m nastaven�.
elseif nargin == 2   % nargin vr�t� po�et vstupn�ch argument� p�edan�ch ve vol�n� do pr�v� prob�haj�c� funkce 
    if ~islogical(maska)    % pokud maska nen� logicky hodnocen� vyhod� se error
        error('Maska mus� b�t logicky hodnocen� matice');
    end
else                        % jak�koli jin� chyb, zna�� �patn� vol�n� funkce
    error('�patn� vol�n� funkce Frost_Filtr'); 
end

Typ_obr = class(Vstup_obraz); % class vr�t� �et�zec specifikuj�c� t��du � "class" objektu
Rozmery_okna = size(maska);   % size vr�t� rozm�ry masky (���ku i d�lku)

Vstup_obraz = padarray(Vstup_obraz,[floor(Rozmery_okna(1)/2) floor(Rozmery_okna(2)/2)],'symmetric','both');
% paddarray vypln� p�ed prvn�m prvkem a za posledn�m prvkem pod�l zadan�
% dimenze ��sla, zaokrouhlen� dol� a vyd�len� dv�mi, nach�zej�c� se v
% Rozmery_okna(1) nebo Rozmery_okna(2)

[n_radek,n_sloupec] = size(Vstup_obraz); % size vr�t� rozm�ry masky (���ku i d�lku)
Vystup_obraz = Vstup_obraz;      % O�et�en� stejn�ho rozm�ru obrazku vstupn�ho a v�stupn�ho

[xInd_mrizka yInd_mrizka] = meshgrid(-floor(Rozmery_okna(1)/2):floor(Rozmery_okna(1)/2),-floor(Rozmery_okna(2)/2):floor(Rozmery_okna(2)/2));
% meshgird vytvo�� obdeln�kovou m��ku (matici ��sel) xInd_mrizka a yInd_mrizka

exp_vaha = exp(-(xInd_mrizka.^2 + yInd_mrizka.^2).^0.5); %Vytvo�en� exponenci�ln� v�hov� hodnoty

for i=ceil(Rozmery_okna(1)/2):n_radek-floor(Rozmery_okna(1)/2)
    %for cyklus pro projet� cel�ho obrazu oknem pro ��dky
    for j=ceil(Rozmery_okna(2)/2):n_sloupec-floor(Rozmery_okna(2)/2)
        %for cyklus pro projet� cel�ho obrazu oknem pro sloupce
        lokalni_okoli = Vstup_obraz(i-floor(Rozmery_okna(1)/2):i+floor(Rozmery_okna(1)/2),j-floor(Rozmery_okna(2)/2):j+floor(Rozmery_okna(2)/2));
                                                 %Vytvo�en� lokaln�ho okol�
        lokalni_okoli = lokalni_okoli(maska);    %aplikace lok�ln�ho okol� na masku
        lokalni_prumer = mean(lokalni_okoli(:)); %v�po�et lok�ln�ho pr�m�ru
        localVar = var(lokalni_okoli(:));        %v�po�et lok�ln� odchylky
        alfa = sqrt(localVar)/lokalni_prumer;    %v�po�et �hlu alfa
        lokalni_vaha = alfa*(exp_vaha.^alfa);    %v�po�et lok�ln� v�hov� hodnoty
        lokalni_vaha_Lin = lokalni_vaha(maska);  %aplikace lok�ln� v�hy na masku
        lokalni_vaha_Lin = lokalni_vaha_Lin/sum(lokalni_vaha_Lin(:)); 
        Vystup_obraz(i,j) = sum(lokalni_vaha_Lin.*lokalni_okoli);
    end
end

%V�stup funkce
Vystup_obraz = Vystup_obraz(ceil(Rozmery_okna(1)/2):n_radek-floor(Rozmery_okna(1)/2),ceil(Rozmery_okna(2)/2):n_sloupec-floor(Rozmery_okna(2)/2));
Vystup_obraz = cast(Vystup_obraz,Typ_obr); %cast � prom�n� Vystup_obraz na datov� typ na jak�m byl na za��tku Vstup_obraz