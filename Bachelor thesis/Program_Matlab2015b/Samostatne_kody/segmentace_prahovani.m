clc
close all
clear all  

%% Bakaláøská práce
% Název: Segmentace ultrazvukových sekvencí
% autor: Jana Schwarzerová, uèo: 186686
% Verze Matlab R2015b

%% Segmentace Prahováním

% ****************************Naètení dat**********************************                                       
%                                                    (Vyber jen jedny data)
   
   %Naètení umìle vytvoøených dat:      
   Obr = imread('obr_prahovani_1.png');    
     %Obr = imread('obr_prahovani_2.png');

   %Naètení fantomových dat: 
     %Obr = imread('koncentrace_sem_1.bmp');
     %Obr = imread('koncentrace_sem_2.bmp');
   
   %Naètení reálných dat: 
     %load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     %Obr = data1{110};
     
   %Naètení libovolných dat. 
     %Obr = %Zde vyplòte libovolný Váš obraz
   
  %Ošetøení vùèi 3D obrazùm a správnému formátování  
  [Vstup_obraz] = Osetreni_obr(Obr);
  
  % *********************Pøedzpracování obrazù****************************
  %             (Pokud chceš pøedzpracovat data, vyber libovolnou filtraci)
  
  %Mediánová filtrace......................................................
  x = 5; % Pøeddefinované okno mediánové filtrace (možnost libovolnì mìnit)
  Vystup_obraz = medfilt2(Vstup_obraz,[x x]);
    % figure %Možnost zobrazení
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  Vstup_obraz = Vystup_obraz; %Pøepsání pro pozdìjší použití
  
  %Lee filtrace............................................................
  %x = 5; % Pøeddefinované okno Lee filtrace (možnost libovolnì mìnit)
  %Vystup_obraz = Lee_Filtr(Vstup_obraz, x);
    % figure %Možnost zobrazení
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  %Vstup_obraz = Vystup_obraz; %Pøepsání pro pozdìjší použití
  
  %Frost filtrace..........................................................
  %Vystup_obraz = Frost_Filtr(Vstup_obraz,getnhood(strel('disk',5,0)));
                                                 % strel('disk',5,0)) ... morfologicky strukturovaný 
                                                 %                        prvek ve formì elipsy (disku)
                                                 %                        s maticí 5x5 
    % figure %Možnost zobrazení
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  %Vstup_obraz = Vystup_obraz; %Pøepsání pro pozdìjší použití                                             

%***************************Samotná segmentace*****************************

%Doporuèené hodnoty pro umìle vytvoøená data:
    Prah = 130/255;  %urèení základního prahu v jednoduchém prahování
    PrahD = 20/255;  %urèení dolního prahu v dvojtém prahování
    PrahH = 200/255; %urèení horního prahu v dvojtém prahování

%Doporuèené hodnoty pro umìle fantomové data:
%     Prah = 80/255;  %urèení základního prahu v jednoduchém prahování
%     PrahD = 20/255;  %urèení dolního prahu v dvojtém prahování
%     PrahH = 200/255; %urèení horního prahu v dvojtém prahování

%Doporuèené hodnoty pro reálná data:
%     Prah = 130/255;  %urèení základního prahu v jednoduchém prahování
%     PrahD = 5/255;  %urèení dolního prahu v dvojtém prahování
%     PrahH = 100/255; %urèení horního prahu v dvojtém prahování

%Zavolání funkce prahování:
[Vystup_1,Vystup_2,Vystup_3] = Prahovani(Vstup_obraz,Prah, PrahD, PrahH);

%Vykreslení výsledkù: 

figure %Zobrazení jednoduchého prahování
imshowpair(Obr, Vystup_1, 'montage')
title('Jednoduché neboli základní prahování')

figure %Zobrazení prahovaní pomocí funkce graythresh
imshowpair(Obr, Vystup_2, 'montage')
title('Prahování pomocí funkce Graythresh')

figure %Zobrazení dvojtého prahování
imshowpair(Obr, Vystup_3, 'montage')
title('Dvojté prahování')


%% Následné vykreslení, které je zobrazené i BP s pomocí roipoly

% figure % Následné vykreslení pomocí funkce roipoly
% pom = roipoly(Vstup_obraz);
% pom = im2double(pom);
% imshow(pom)
% figure %Vykreslení výsledných obrazù v jedno s roipoly:
% imshow([Vstup_obraz,pom,Vystup_1,Vystup_2,Vystup_3])
% figure %Vykreslení výsledných obrazù v jedno bez roipoly:
% imshow([Vstup_obraz,Vystup_1,Vystup_2,Vystup_3])
