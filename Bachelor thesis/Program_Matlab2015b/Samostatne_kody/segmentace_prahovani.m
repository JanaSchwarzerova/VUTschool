clc
close all
clear all  

%% Bakal��sk� pr�ce
% N�zev: Segmentace ultrazvukov�ch sekvenc�
% autor: Jana Schwarzerov�, u�o: 186686
% Verze Matlab R2015b

%% Segmentace Prahov�n�m

% ****************************Na�ten� dat**********************************                                       
%                                                    (Vyber jen jedny data)
   
   %Na�ten� um�le vytvo�en�ch dat:      
   Obr = imread('obr_prahovani_1.png');    
     %Obr = imread('obr_prahovani_2.png');

   %Na�ten� fantomov�ch dat: 
     %Obr = imread('koncentrace_sem_1.bmp');
     %Obr = imread('koncentrace_sem_2.bmp');
   
   %Na�ten� re�ln�ch dat: 
     %load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     %Obr = data1{110};
     
   %Na�ten� libovoln�ch dat. 
     %Obr = %Zde vypl�te libovoln� V� obraz
   
  %O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
  [Vstup_obraz] = Osetreni_obr(Obr);
  
  % *********************P�edzpracov�n� obraz�****************************
  %             (Pokud chce� p�edzpracovat data, vyber libovolnou filtraci)
  
  %Medi�nov� filtrace......................................................
  x = 5; % P�eddefinovan� okno medi�nov� filtrace (mo�nost libovoln� m�nit)
  Vystup_obraz = medfilt2(Vstup_obraz,[x x]);
    % figure %Mo�nost zobrazen�
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  Vstup_obraz = Vystup_obraz; %P�eps�n� pro pozd�j�� pou�it�
  
  %Lee filtrace............................................................
  %x = 5; % P�eddefinovan� okno Lee filtrace (mo�nost libovoln� m�nit)
  %Vystup_obraz = Lee_Filtr(Vstup_obraz, x);
    % figure %Mo�nost zobrazen�
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  %Vstup_obraz = Vystup_obraz; %P�eps�n� pro pozd�j�� pou�it�
  
  %Frost filtrace..........................................................
  %Vystup_obraz = Frost_Filtr(Vstup_obraz,getnhood(strel('disk',5,0)));
                                                 % strel('disk',5,0)) ... morfologicky strukturovan� 
                                                 %                        prvek ve form� elipsy (disku)
                                                 %                        s matic� 5x5 
    % figure %Mo�nost zobrazen�
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  %Vstup_obraz = Vystup_obraz; %P�eps�n� pro pozd�j�� pou�it�                                             

%***************************Samotn� segmentace*****************************

%Doporu�en� hodnoty pro um�le vytvo�en� data:
    Prah = 130/255;  %ur�en� z�kladn�ho prahu v jednoduch�m prahov�n�
    PrahD = 20/255;  %ur�en� doln�ho prahu v dvojt�m prahov�n�
    PrahH = 200/255; %ur�en� horn�ho prahu v dvojt�m prahov�n�

%Doporu�en� hodnoty pro um�le fantomov� data:
%     Prah = 80/255;  %ur�en� z�kladn�ho prahu v jednoduch�m prahov�n�
%     PrahD = 20/255;  %ur�en� doln�ho prahu v dvojt�m prahov�n�
%     PrahH = 200/255; %ur�en� horn�ho prahu v dvojt�m prahov�n�

%Doporu�en� hodnoty pro re�ln� data:
%     Prah = 130/255;  %ur�en� z�kladn�ho prahu v jednoduch�m prahov�n�
%     PrahD = 5/255;  %ur�en� doln�ho prahu v dvojt�m prahov�n�
%     PrahH = 100/255; %ur�en� horn�ho prahu v dvojt�m prahov�n�

%Zavol�n� funkce prahov�n�:
[Vystup_1,Vystup_2,Vystup_3] = Prahovani(Vstup_obraz,Prah, PrahD, PrahH);

%Vykreslen� v�sledk�: 

figure %Zobrazen� jednoduch�ho prahov�n�
imshowpair(Obr, Vystup_1, 'montage')
title('Jednoduch� neboli z�kladn� prahov�n�')

figure %Zobrazen� prahovan� pomoc� funkce graythresh
imshowpair(Obr, Vystup_2, 'montage')
title('Prahov�n� pomoc� funkce Graythresh')

figure %Zobrazen� dvojt�ho prahov�n�
imshowpair(Obr, Vystup_3, 'montage')
title('Dvojt� prahov�n�')


%% N�sledn� vykreslen�, kter� je zobrazen� i BP s pomoc� roipoly

% figure % N�sledn� vykreslen� pomoc� funkce roipoly
% pom = roipoly(Vstup_obraz);
% pom = im2double(pom);
% imshow(pom)
% figure %Vykreslen� v�sledn�ch obraz� v jedno s roipoly:
% imshow([Vstup_obraz,pom,Vystup_1,Vystup_2,Vystup_3])
% figure %Vykreslen� v�sledn�ch obraz� v jedno bez roipoly:
% imshow([Vstup_obraz,Vystup_1,Vystup_2,Vystup_3])
