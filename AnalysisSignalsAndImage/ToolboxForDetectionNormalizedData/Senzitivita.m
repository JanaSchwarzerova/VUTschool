clear all; close all; clc
%% Projekt �. 10 � Statistick� vyhodnocen� = SENZITIVITA

% Statistick� vyhodnocenen� senzitivity dektoru pomoc� algoritmu p�i pou�it� L�cov�n� 
% V tomto skriptu se na��t� 130 o��, jedn� se o 13 o�� po 10 fotk�ch
% Skript prov�d� spr�vn� p�i�azovan� fotografii k referen�n� fotce pro dan�
% oko. Ur�uje po�et spr�vn� detekce a fale�n� negativn�ch v�sledk�. 
% Pot� z t�chto �daj� ur�� senzitivitu algoritmu.

%Pomocn� prom�n� pro statistick� vyhodnocen�
pom_shoda = 0;
pom_neshoda = 0;

%% Na�ten� dat ************************************************************

for i = 1:13
obrazek1=['Referencni_',num2str(i),'.bmp']; 
    for j = 1:9
    obrazek2=['0',num2str(j),'_L',num2str(i),'.bmp']; 
    I = imread(obrazek1);
    I_2 = imread(obrazek2);

%% P�edzpracov�n� *********************************************************

    I = rgb2gray(im2double(I));    %Referen�n� oko (vykreslujeme, pro ilustraci)
    I_2 = rgb2gray(im2double(I_2));%Oko slou��c� k ur�en� detekce, 
                               %toto oko, ji� nevykreslujeme k urychlen�
                               %algoritmu (a� na konci k porovn�n�) 

    I_bw = im2bw(I,0.2);               %P�eveden� na �ernob�l� obraz
    I_bw_2 = im2bw(I_2,0.2);           %Pro druh� oko

    % Odstan�n� 'odlesk�' v zornici:
    prah1 = 100;                       % Nastaven� minim�ln�ho po�tu pixel� 
    BW = bwareaopen(I_bw,prah1);       % v bin�rn�m obraze vyhled� a odstran� objekty, kter� maj� m�� pixel�, ne� P
    BW_2 = bwareaopen(I_bw_2,prah1);   % Pro druh� oko

    % Negativ (aby se daly odstranit dal�� mal� oblasti - odstranit jde jen b�l� oblasti):
    Negativ = 1-BW;
    Negativ_2 = 1-BW_2;%Pro druh� oko
    R = regionprops(Negativ,'Area');
    R_2 = regionprops(Negativ_2,'Area');%Pro druh� oko

    prah2 = 3000;                       % Nastaven� minim�ln�ho po�tu pixel� 
    BW = bwareaopen(Negativ,prah2);     % v bin�rn�m obraze vyhled� a odstran� 
                                    % objekty, kter� maj� m�� pixel�, ne�
                                    % pra2
    BW_2 = bwareaopen(Negativ_2,prah2); %Pro druh� oko
    S = regionprops(BW, 'Area'); 

%% SEGMENTACE *************************************************************

    % Zji�tov�n� optim�ln�ch parametr� pro segmentaci:
    centroid = regionprops(BW,'centroid');      %Ur�en� centroidu (st�edu oka, konkr�tn� �o�ky)
    centroid_2 = regionprops(BW_2,'centroid');  %Pro druh� oko
    centroid = cat(1, centroid.Centroid);
    centroid_2 = cat(1, centroid_2.Centroid);   %Pro druh� oko
    extremy = regionprops(BW,'Extrema');        %Zjist� sou�adnice extr�mn�ch hodnot
                                            %[top-left top-right right-top right-bottom 
                                            % bottom-right bottom-left left-bottom left-top]
    extremy_2 = regionprops(BW_2,'Extrema');    %Pro druh� oko 

    bottom_left=extremy(1).Extrema(5,:);        %Sou�adnice doln�ho lev�ho rohu
    bottom_left_2=extremy_2(1).Extrema(5,:);    %Pro druh� oko 

    %Vzd�lenost sou�adnice top-left a bottom left (ur�uje n�m polom�r �o�ky):
    polomer_cocky=sqrt((centroid(2)-bottom_left(2))^2+(bottom_left(1)-centroid(1))^2);
    polomer_cocky_2=sqrt((centroid_2(2)-bottom_left_2(2))^2+(bottom_left_2(1)-centroid_2(1))^2);

    %Vypo�et polom�ru duhovky: 
    polomer_duhovky = polomer_cocky*1.8; 
    theta = 0:pi/50:2*pi;
    kruznice_x = polomer_duhovky * cos(theta) + centroid(1); 
    kruznice_y = polomer_duhovky * sin(theta) + centroid(2);
                                         %Pro druh� oko: 
    polomer_duhovky_2 = polomer_cocky_2*1.8; 
    theta_2 = 0:pi/50:2*pi;
    kruznice_x_2 = polomer_duhovky_2 * cos(theta_2) + centroid_2(1); 
    kruznice_y_2 = polomer_duhovky_2 * sin(theta_2) + centroid_2(2);

%__________________________SAMOTN� SEGMETNACE______________________________
    [segmentovany_obraz_polovina,segmentovany_obraz] = segmentace(I,centroid,extremy); 
                                                            %Pro druh� oko:
    [segmentovany_obraz_polovina_2,segmentovany_obraz_2] = segmentace(I_2,centroid_2,extremy_2);

    %O�ez�n� obrazu (oblast z�jmu): 
    orezany_obraz = polovina(segmentovany_obraz_polovina);
    orezany_obraz_2 = polovina(segmentovany_obraz_polovina_2);


%% L�cov�n� ***************************************************************
    [matchedPoints1,matchedPoints2] = funkce_licovani(orezany_obraz,orezany_obraz_2);

%% ROZHODOVAC� PRAVIDLO PRO DETEKCI ***************************************
        if matchedPoints1.Count>=5
        % Jestli�e bude po�et nalezen�ch shodn�ch bod� v�t�� nebo roven 5, nalezli
        % jsme shodu - oko stejn�ho �lov�ka; 
        % pokud ne, shoda nebyla nalezena a o�i jsou od dvou r�zn�ch lid�  
         pom_shoda = pom_shoda +1;
        else
         pom_neshoda = pom_neshoda +1;    
        end
    end
end

disp(['Po�et spr�vn� detekce je roven ',num2str(pom_shoda), ' fale�n� negativn�ch ',num2str(pom_neshoda)])

%% V�po�et senzitivity testu

senzitivita = (pom_shoda + pom_neshoda)/((pom_shoda + pom_neshoda)+pom_neshoda);

disp(['Sezitivita detektoru vy�la: ', num2str(senzitivita)])
