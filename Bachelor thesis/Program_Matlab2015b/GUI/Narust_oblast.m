function [Vystup] = Narust_oblast(Vstup_obraz, x, y, reg_max)

% Narust_oblas je funkce/algoritmus pro metodu nar�st�n� oblast�. 

% Vstup_obraz ... vstupn� obraz, na kter�m se provede segmentace 
% Vystup ... v�stupn� obraz neboli segmentovan� obraz metodou nar�stn�
%            oblast�
% Nastaven� sou�adnic:
% x ... sou�adnice x, od kter� za�ne oblast nar�stat
% y ... sou�adnice y, od kter� za�ne oblast nar�stat
% 
% Po��te�n� podm�nky: 
% reg_max ... maxim�ln� interval intenzity (defualtn� 0.2)
%% __________________________________________________________________________
% NAR�STAN� OBLAST�
%
%**************************************************************************
% K�d p�evzat� z: 
%      -> https://www.mathworks.com/matlabcentral/fileexchange/19084-region-growing
%      -> Autor: D. Kroon, University of Twent
%

% Jednoduch�, ale ��inn� p��klad "Region Growing" z jedin�ho m�sta semen.
% Oblast je iterativn� vytv��ena porovn�n�m v�ech nep�id�len�ch sousedn�ch 
% pixel� s regionem. Rozd�l mezi hodnotou intenzity pixelu a st�edn� 
% hodnotou regionu se pou��v� jako m�ra podobnosti. 
% Pixel s nejmen��m rozd�lem, kter� je t�mto zp�sobem m��en, je p�id�len regionu.
% Tento proces se zastav�, kdy� rozd�l intenzity mezi st�edem regionu 
% a nov�m pixelem se zv�t�� nad ur�itou hranici

Vystup = zeros(size(Vstup_obraz)); % Nadefinov�n� v�stupn�ho obrazu
Vystup_obr_sizes = size(Vstup_obraz);    % Rozm�ry v�stupn�ho obrazu

intenzita_oblasti = Vstup_obraz(x,y); % Segmentovan� oblast

% Voln� pam� pro ukl�d�n� sousedn� oblasti (segmentovan�)
soused_volny = 500;                %Voln� pam�t sousedn� oblasti
soused_pos=0;                      %Pozice sousedn� oblasti
soused_list = zeros(soused_volny,3); 
pixel_vzdalenost=0;                %Vzd�lenost nejnov�j��ho regionu k prost�edn�mi regionu
reg_sirka = 1;                     %���ka po��te�n�ho regionu
pom_soused=[-1 0; 1 0; 0 -1;0 1];  %Nadefinov�n� sousedn�ho m�sta 

% Za�neme tak, aby vzd�lenost mezi regionem a mo�n�mi pixely byla v�t��
% ne� ur�it� prahov� hodnota
while((pixel_vzdalenost<reg_max)&&(reg_sirka<numel(Vstup_obraz)))

    % P�id�n� nov�ho sousedn�ho pixelu
    for j=1:4,
        % V�po�et sousedn� sou�adnice
        x_soused = x +pom_soused(j,1);
        y_soused = y +pom_soused(j,2);
        % O�et�en� abychom m�li po��d sou�adnice uvnit� obrazu
        ins=(x_soused>=1)&&(y_soused>=1)&&(x_soused<=Vystup_obr_sizes(1))&&(y_soused<=Vystup_obr_sizes(2));        
        % P�id�n� sousedn� sou�adnice, pokud nen� uvnit� nebo sou��st�
        % segmentovan� oblast�
        if(ins&&(Vystup(x_soused,y_soused)==0)) 
                soused_pos = soused_pos+1;
                soused_list(soused_pos,:) = [x_soused y_soused Vstup_obraz(x_soused,y_soused)];
                Vystup(x_soused,y_soused)=1;
        end
    end
    % P�eps�n� sousedn�ch pozic prom�nn� (pro volnou pam�t)
    if(soused_pos+10>soused_volny)
       soused_volny=soused_volny+500;
       soused_list((soused_pos+1):soused_volny,:)=0; 
    end    
    % P�id�n� pixele s intenzitou, kter� je nejbli��� regionu do oblasti
    vzdalenost = abs(soused_list(1:soused_pos,3)-intenzita_oblasti);
    [pixel_vzdalenost, index] = min(vzdalenost);
    Vystup(x,y)=2; 
    reg_sirka=reg_sirka+1;    
    % V�po�et nov�ho region�ln�ho pr�m�ru
    intenzita_oblasti= (intenzita_oblasti*reg_sirka + soused_list(index,3))/(reg_sirka+1);    
    % Ulo�en� sou�adnic x,y pro dal�� iteraci (pro dal�� p�id�v�n� sousedn�ch pixel�)
    x = soused_list(index,1); 
    y = soused_list(index,2);    
    % Kontrola pro odstran�n� pixelu, ze seznamu sousedn�ch pixel� 
    soused_list(index,:)=soused_list(soused_pos,:);
    soused_pos=soused_pos-1;
end

% Vr�cen� segmentovan� oblasti jako matici na v�stupn�
Vystup=Vystup>1;

