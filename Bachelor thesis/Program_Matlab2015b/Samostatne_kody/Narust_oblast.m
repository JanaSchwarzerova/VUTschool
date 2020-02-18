function [Vystup] = Narust_oblast(Vstup_obraz, x, y, reg_max)

% Narust_oblas je funkce/algoritmus pro metodu narùstání oblastí. 

% Vstup_obraz ... vstupní obraz, na kterém se provede segmentace 
% Vystup ... vıstupní obraz neboli segmentovanı obraz metodou narùstní
%            oblastí
% Nastavení souøadnic:
% x ... souøadnice x, od které zaène oblast narùstat
% y ... souøadnice y, od které zaène oblast narùstat
% 
% Poèáteèní podmínky: 
% reg_max ... maximální interval intenzity (defualtnì 0.2)
%% __________________________________________________________________________
% NARÙSTANÍ OBLASTÍ
%
%**************************************************************************
% Kód pøevzatı z: 
%      -> https://www.mathworks.com/matlabcentral/fileexchange/19084-region-growing
%      -> Autor: D. Kroon, University of Twent
%

% Jednoduchı, ale úèinnı pøíklad "Region Growing" z jediného místa semen.
% Oblast je iterativnì vytváøena porovnáním všech nepøidìlenıch sousedních 
% pixelù s regionem. Rozdíl mezi hodnotou intenzity pixelu a støední 
% hodnotou regionu se pouívá jako míra podobnosti. 
% Pixel s nejmenším rozdílem, kterı je tímto zpùsobem mìøen, je pøidìlen regionu.
% Tento proces se zastaví, kdy rozdíl intenzity mezi støedem regionu 
% a novım pixelem se zvìtší nad urèitou hranici

Vystup = zeros(size(Vstup_obraz)); % Nadefinování vıstupního obrazu
Vystup_obr_sizes = size(Vstup_obraz);    % Rozmìry vıstupního obrazu

intenzita_oblasti = Vstup_obraz(x,y); % Segmentovaná oblast

% Volná pamì pro ukládání sousední oblasti (segmentované)
soused_volny = 500;                %Volná pamìt sousední oblasti
soused_pos=0;                      %Pozice sousední oblasti
soused_list = zeros(soused_volny,3); 
pixel_vzdalenost=0;                %Vzdálenost nejnovìjšího regionu k prostøedními regionu
reg_sirka = 1;                     %Šíøka poèáteèního regionu
pom_soused=[-1 0; 1 0; 0 -1;0 1];  %Nadefinování sousedního místa 

% Zaèneme tak, aby vzdálenost mezi regionem a monımi pixely byla vìtší
% ne urèitá prahová hodnota
while((pixel_vzdalenost<reg_max)&&(reg_sirka<numel(Vstup_obraz)))

    % Pøidání nového sousedního pixelu
    for j=1:4,
        % Vıpoèet sousední souøadnice
        x_soused = x +pom_soused(j,1);
        y_soused = y +pom_soused(j,2);
        % Ošetøení abychom mìli poøád souøadnice uvnitø obrazu
        ins=(x_soused>=1)&&(y_soused>=1)&&(x_soused<=Vystup_obr_sizes(1))&&(y_soused<=Vystup_obr_sizes(2));        
        % Pøidání sousední souøadnice, pokud není uvnitø nebo souèástí
        % segmentované oblastí
        if(ins&&(Vystup(x_soused,y_soused)==0)) 
                soused_pos = soused_pos+1;
                soused_list(soused_pos,:) = [x_soused y_soused Vstup_obraz(x_soused,y_soused)];
                Vystup(x_soused,y_soused)=1;
        end
    end
    % Pøepsání sousedních pozic promìnné (pro volnou pamìt)
    if(soused_pos+10>soused_volny)
       soused_volny=soused_volny+500;
       soused_list((soused_pos+1):soused_volny,:)=0; 
    end    
    % Pøidání pixele s intenzitou, která je nejbliší regionu do oblasti
    vzdalenost = abs(soused_list(1:soused_pos,3)-intenzita_oblasti);
    [pixel_vzdalenost, index] = min(vzdalenost);
    Vystup(x,y)=2; 
    reg_sirka=reg_sirka+1;    
    % Vıpoèet nového regionálního prùmìru
    intenzita_oblasti= (intenzita_oblasti*reg_sirka + soused_list(index,3))/(reg_sirka+1);    
    % Uloení souøadnic x,y pro další iteraci (pro další pøidávání sousedních pixelù)
    x = soused_list(index,1); 
    y = soused_list(index,2);    
    % Kontrola pro odstranìní pixelu, ze seznamu sousedních pixelù 
    soused_list(index,:)=soused_list(soused_pos,:);
    soused_pos=soused_pos-1;
end

% Vrácení segmentované oblasti jako matici na vıstupní
Vystup=Vystup>1;

