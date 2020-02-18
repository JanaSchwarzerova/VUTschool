clc
close all
clear all  

%% Bakaláøská práce
% Název: Segmentace ultrazvukových sekvencí
% autor: Jana Schwarzerová, uèo: 186686
% Verze Matlab R2015b

%% Segmentace Rozvodí

% ****************************Naètení dat**********************************                                       
%                                                    (Vyber jen jedny data)
   
   %Naètení umìle vytvoøených dat:      
    Obr = imread('obr_rozvodi_2.png');     
   %I = imread('obr_rozvodi.png');     %Obrázek použitý u narùstání oblastí
                                       %k tomuto obrázku je
                                       %pøidán multiplikativní
                                       %šum speckle
   %Pøidání multiplikativního šumu
   %v = 0.04;
   %Obr = imnoise(I,'speckle',v); % I je vstupní obraz, 
                                  % 'speckle'– multiplikativní šum
                                  %          – charakterizován rovnicí Obr = I+n*I
                                  %   -> "n" je rovnomìrnì rozdìlený náhodný šum
                                  %      se støední hodnotou 0 a rozptylem "v"

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

[Vystup_Sobel, Vystup_Robin, Vystup_Prewitt] = Rozvodi(Vstup_obraz);

figure %Zobrazení pro umìle vytvoøené a fantomové data
imshow ([Obr, Vystup_Sobel, Vystup_Robin, Vystup_Prewitt]);   

 %figure %Zobrazení pro reálné data
 %imshowpair ([Obr,Obr,Obr], [Vystup_Sobel, Vystup_Robin, Vystup_Prewitt],'montage'); 

     