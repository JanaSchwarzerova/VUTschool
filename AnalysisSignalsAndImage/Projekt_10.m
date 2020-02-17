clear all; close all; clc
%% Projekt �. 10                                                 10.12.2018
% N�zev:          Identifikace osob podle o�n� duhovky
%
% Zad�n�: 
% Navrhn�te a realizujte algoritmus pro identifikace osob podle o�n� duhovky 
% na dostupn� datab�zi. 
% Statisticky vyhodno�te �sp�nost navr�en�ho algoritmu a v�sledky diskutujte.

% Auto�i: 
%    Bc. Veronika Po�ustov�, Bc. Nikola Hu�ka�ov�, Bc. Jana Schwarzerov�

%% Na�ten� dat ************************************************************

obrazek1='01_L.bmp'; 
obrazek2='02_L.bmp'; 
I = imread(obrazek1);
I_2 = imread(obrazek2);

%% P�edzpracov�n� *********************************************************

I = rgb2gray(im2double(I));    %Referen�n� oko (vykreslujeme, pro ilustraci)
I_2 = rgb2gray(im2double(I_2));%Oko slou��c� k ur�en� detekce, 
                               %toto oko, ji� nevykreslujeme k urychlen�
                               %algoritmu (a� na konci k porovn�n�) 

%Vykreslen�
figure
subplot(2,3,1)
imshow(I)
title('Origin�ln� obraz')          %B�l� obraz

I_bw = im2bw(I,0.2);               %P�eveden� na �ernob�l� obraz
I_bw_2 = im2bw(I_2,0.2);           %Pro druh� oko

%Vykreslen�
title('�enob�l� obraz')
subplot(2,3,2)
imshow(I_bw)

% Odstan�n� 'odlesk�' v zornici:
prah1 = 100;                       % Nastaven� minim�ln�ho po�tu pixel� 
BW = bwareaopen(I_bw,prah1);       % v bin�rn�m obraze vyhled� a odstran� objekty, kter� maj� m�� pixel�, ne� P
BW_2 = bwareaopen(I_bw_2,prah1);   % Pro druh� oko

%Vykreslen�: 
subplot(2,3,3)
imshow(BW)
title('Odstran�n� odlesk�')

% Negativ (aby se daly odstranit dal�� mal� oblasti - odstranit jde jen b�l� oblasti):
Negativ = 1-BW;
Negativ_2 = 1-BW_2;%Pro druh� oko
R = regionprops(Negativ,'Area');
R_2 = regionprops(Negativ_2,'Area');%Pro druh� oko

%Vykreslen�: 
subplot(2,3,4)
imshow(Negativ)
title('Negativ')

prah2 = 3000;                       % Nastaven� minim�ln�ho po�tu pixel� 
BW = bwareaopen(Negativ,prah2);     % v bin�rn�m obraze vyhled� a odstran� 
                                    % objekty, kter� maj� m�� pixel�, ne�
                                    % pra2
BW_2 = bwareaopen(Negativ_2,prah2); %Pro druh� oko
S = regionprops(BW, 'Area'); 

%Vykreslen�
subplot(2,3,5)
imshow(BW)

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

%Vykreslen�
hold on
plot(centroid(:,1),centroid(:,2), 'b*')
hold off
title('Centroid')
subplot(2,3,6)
imshow(I)
hold on;
contour(BW,'b','LineWidth',1);
hold off;
title('Oblast zornice')
hold on
plot(centroid(:,1),centroid(:,2), 'b*')
hold off

%Vykreslen�
figure
subplot(2,3,1)
imshow(Negativ)
title('�ernob�l� negativ obrazu')

subplot(2,3,2)
imshow(I)
hold on;
contour(BW,'b','LineWidth',1);
hold off;
title('Oblast zornice')
hold on
plot(centroid(:,1),centroid(:,2), 'b*')
plot(bottom_left(1),bottom_left(2),'b*')
plot([bottom_left(1) centroid(1)],[bottom_left(2) centroid(2)],'b')

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

%Vykreslen�
subplot(2,3,3)
hold on
imshow(I);
h = plot(kruznice_x, kruznice_y,'r');
axis('equal');
title('Ur�en� segment. oblasti')
plot(centroid(:,1),centroid(:,2), 'b*')
hold off

%__________________________SAMOTN� SEGMETNACE______________________________
[segmentovany_obraz_polovina,segmentovany_obraz] = segmentace(I,centroid,extremy); 
                                                            %Pro druh� oko:
[segmentovany_obraz_polovina_2,segmentovany_obraz_2] = segmentace(I_2,centroid_2,extremy_2);

%Vykreslen�
subplot(2,3,4)
hold on
imshow(segmentovany_obraz)
plot(centroid(:,1),centroid(:,2), 'b*')
title('Segmentace cel� duhovky')
subplot(2,3,5)
hold on
imshow(segmentovany_obraz_polovina)
plot(centroid(:,1),centroid(:,2), 'b*')
title('Segmentace duhovky')

%O�ez�n� obrazu (oblast z�jmu): 
orezany_obraz = polovina(segmentovany_obraz_polovina);
orezany_obraz_2 = polovina(segmentovany_obraz_polovina_2);

%Vykreslen�
subplot(2,3,6)
imshow(orezany_obraz)
title('O�ezan� obraz')

%% L�cov�n� ***************************************************************
[matchedPoints1,matchedPoints2] = funkce_licovani(orezany_obraz,orezany_obraz_2);

%% ROZHODOVAC� PRAVIDLO PRO DETEKCI ***************************************
if matchedPoints1.Count>=5
    % Jestli�e bude po�et nalezen�ch shodn�ch bod� v�t�� nebo roven 5, nalezli
    % jsme shodu - oko stejn�ho �lov�ka; 
    % pokud ne, shoda nebyla nalezena a o�i jsou od dvou r�zn�ch lid�  
    figure; showMatchedFeatures(orezany_obraz,orezany_obraz_2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    title('Shoda nalezena')
else
    figure; showMatchedFeatures(orezany_obraz,orezany_obraz_2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    title('Shoda nebyla nalezena')     
end

