clear all; close all; clc
%% Projekt è. 10 – Statistické vyhodnocení = SENZITIVITA

% Statistické vyhodnocenení senzitivity dektoru pomocí algoritmu pøi použití Lícování 
% V tomto skriptu se naèítá 130 oèí, jedná se o 13 oèí po 10 fotkách
% Skript provádí správné pøiøazovaní fotografii k referenèní fotce pro dané
% oko. Urèuje poèet správné detekce a falešnì negativních výsledkù. 
% Poté z tìchto údajù urèí senzitivitu algoritmu.

%Pomocné promìné pro statistické vyhodnocení
pom_shoda = 0;
pom_neshoda = 0;

%% Naètení dat ************************************************************

for i = 1:13
obrazek1=['Referencni_',num2str(i),'.bmp']; 
    for j = 1:9
    obrazek2=['0',num2str(j),'_L',num2str(i),'.bmp']; 
    I = imread(obrazek1);
    I_2 = imread(obrazek2);

%% Pøedzpracování *********************************************************

    I = rgb2gray(im2double(I));    %Referenèní oko (vykreslujeme, pro ilustraci)
    I_2 = rgb2gray(im2double(I_2));%Oko sloužící k urèení detekce, 
                               %toto oko, již nevykreslujeme k urychlení
                               %algoritmu (až na konci k porovnání) 

    I_bw = im2bw(I,0.2);               %Pøevedení na èernobílý obraz
    I_bw_2 = im2bw(I_2,0.2);           %Pro druhé oko

    % Odstanìní 'odleskù' v zornici:
    prah1 = 100;                       % Nastavení minimálního poètu pixelù 
    BW = bwareaopen(I_bw,prah1);       % v binárním obraze vyhledá a odstraní objekty, které mají míò pixelù, než P
    BW_2 = bwareaopen(I_bw_2,prah1);   % Pro druhé oko

    % Negativ (aby se daly odstranit další malé oblasti - odstranit jde jen bílé oblasti):
    Negativ = 1-BW;
    Negativ_2 = 1-BW_2;%Pro druhé oko
    R = regionprops(Negativ,'Area');
    R_2 = regionprops(Negativ_2,'Area');%Pro druhé oko

    prah2 = 3000;                       % Nastavení minimálního poètu pixelù 
    BW = bwareaopen(Negativ,prah2);     % v binárním obraze vyhledá a odstraní 
                                    % objekty, které mají míò pixelù, než
                                    % pra2
    BW_2 = bwareaopen(Negativ_2,prah2); %Pro druhé oko
    S = regionprops(BW, 'Area'); 

%% SEGMENTACE *************************************************************

    % Zjištování optimálních parametrù pro segmentaci:
    centroid = regionprops(BW,'centroid');      %Urèení centroidu (støedu oka, konkrétnì èoèky)
    centroid_2 = regionprops(BW_2,'centroid');  %Pro druhé oko
    centroid = cat(1, centroid.Centroid);
    centroid_2 = cat(1, centroid_2.Centroid);   %Pro druhé oko
    extremy = regionprops(BW,'Extrema');        %Zjistí souøadnice extrémních hodnot
                                            %[top-left top-right right-top right-bottom 
                                            % bottom-right bottom-left left-bottom left-top]
    extremy_2 = regionprops(BW_2,'Extrema');    %Pro druhé oko 

    bottom_left=extremy(1).Extrema(5,:);        %Souøadnice dolního levého rohu
    bottom_left_2=extremy_2(1).Extrema(5,:);    %Pro druhé oko 

    %Vzdálenost souøadnice top-left a bottom left (urèuje nám polomìr èoèky):
    polomer_cocky=sqrt((centroid(2)-bottom_left(2))^2+(bottom_left(1)-centroid(1))^2);
    polomer_cocky_2=sqrt((centroid_2(2)-bottom_left_2(2))^2+(bottom_left_2(1)-centroid_2(1))^2);

    %Vypoèet polomìru duhovky: 
    polomer_duhovky = polomer_cocky*1.8; 
    theta = 0:pi/50:2*pi;
    kruznice_x = polomer_duhovky * cos(theta) + centroid(1); 
    kruznice_y = polomer_duhovky * sin(theta) + centroid(2);
                                         %Pro druhé oko: 
    polomer_duhovky_2 = polomer_cocky_2*1.8; 
    theta_2 = 0:pi/50:2*pi;
    kruznice_x_2 = polomer_duhovky_2 * cos(theta_2) + centroid_2(1); 
    kruznice_y_2 = polomer_duhovky_2 * sin(theta_2) + centroid_2(2);

%__________________________SAMOTNÁ SEGMETNACE______________________________
    [segmentovany_obraz_polovina,segmentovany_obraz] = segmentace(I,centroid,extremy); 
                                                            %Pro druhé oko:
    [segmentovany_obraz_polovina_2,segmentovany_obraz_2] = segmentace(I_2,centroid_2,extremy_2);

    %Oøezání obrazu (oblast zájmu): 
    orezany_obraz = polovina(segmentovany_obraz_polovina);
    orezany_obraz_2 = polovina(segmentovany_obraz_polovina_2);


%% Lícování ***************************************************************
    [matchedPoints1,matchedPoints2] = funkce_licovani(orezany_obraz,orezany_obraz_2);

%% ROZHODOVACÍ PRAVIDLO PRO DETEKCI ***************************************
        if matchedPoints1.Count>=5
        % Jestliže bude poèet nalezených shodných bodù vìtší nebo roven 5, nalezli
        % jsme shodu - oko stejného èlovìka; 
        % pokud ne, shoda nebyla nalezena a oèi jsou od dvou rùzných lidí  
         pom_shoda = pom_shoda +1;
        else
         pom_neshoda = pom_neshoda +1;    
        end
    end
end

disp(['Poèet správné detekce je roven ',num2str(pom_shoda), ' falešnì negativních ',num2str(pom_neshoda)])

%% Výpoèet senzitivity testu

senzitivita = (pom_shoda + pom_neshoda)/((pom_shoda + pom_neshoda)+pom_neshoda);

disp(['Sezitivita detektoru vyšla: ', num2str(senzitivita)])
