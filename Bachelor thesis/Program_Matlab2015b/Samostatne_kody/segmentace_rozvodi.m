clc
close all
clear all  

%% Bakal��sk� pr�ce
% N�zev: Segmentace ultrazvukov�ch sekvenc�
% autor: Jana Schwarzerov�, u�o: 186686
% Verze Matlab R2015b

%% Segmentace Rozvod�

% ****************************Na�ten� dat**********************************                                       
%                                                    (Vyber jen jedny data)
   
   %Na�ten� um�le vytvo�en�ch dat:      
    Obr = imread('obr_rozvodi_2.png');     
   %I = imread('obr_rozvodi.png');     %Obr�zek pou�it� u nar�st�n� oblast�
                                       %k tomuto obr�zku je
                                       %p�id�n multiplikativn�
                                       %�um speckle
   %P�id�n� multiplikativn�ho �umu
   %v = 0.04;
   %Obr = imnoise(I,'speckle',v); % I je vstupn� obraz, 
                                  % 'speckle'� multiplikativn� �um
                                  %          � charakterizov�n rovnic� Obr = I+n*I
                                  %   -> "n" je rovnom�rn� rozd�len� n�hodn� �um
                                  %      se st�edn� hodnotou 0 a rozptylem "v"

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

[Vystup_Sobel, Vystup_Robin, Vystup_Prewitt] = Rozvodi(Vstup_obraz);

figure %Zobrazen� pro um�le vytvo�en� a fantomov� data
imshow ([Obr, Vystup_Sobel, Vystup_Robin, Vystup_Prewitt]);   

 %figure %Zobrazen� pro re�ln� data
 %imshowpair ([Obr,Obr,Obr], [Vystup_Sobel, Vystup_Robin, Vystup_Prewitt],'montage'); 

     