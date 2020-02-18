clc
close all
clear all  

%% Bakal��sk� pr�ce
% N�zev: Segmentace ultrazvukov�ch sekvenc�
% autor: Jana Schwarzerov�, u�o: 186686
% Verze Matlab R2015b

%% Segmentace Nar�st�n� oblast�

% ****************************Na�ten� dat**********************************                                       
%                                                    (Vyber jen jedny data)   
   %Na�ten� fantomov�ch dat: 
     %Obr = imread('koncentrace_sem_1.bmp');
     %Obr = imread('koncentrace_sem_2.bmp');
   
   %Na�ten� re�ln�ch dat: 
     load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
     Obr = data1{110};
     
   %Na�ten� libovoln�ch dat. 
     %Obr = %Zde vypl�te libovoln� V� obraz
   
  %O�et�en� v��i 3D obraz�m a spr�vn�mu form�tov�n�  
  [Vstup_obraz] = Osetreni_obr(Obr);
  
  % *********************P�edzpracov�n� obraz�****************************
  %             (Pokud chce� p�edzpracovat data, vyber libovolnou filtraci)
  
  %Medi�nov� filtrace......................................................
  %x = 5; % P�eddefinovan� okno medi�nov� filtrace (mo�nost libovoln� m�nit)
  %Vystup_obraz = medfilt2(Vstup_obraz,[x x]);
    % figure %Mo�nost zobrazen�
    % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
  %Vstup_obraz = Vystup_obraz; %P�eps�n� pro pozd�j�� pou�it�
  
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

pocatecni_maska = roipoly(Vstup_obraz);
max_it = 800; %Maxim�ln� po�et iterac�
              %��m v�c iterac�, t�m p�esn�j�� segmentace, ale pomalej�� v�po�et
[mapa] = Aktiv_kontur(Vstup_obraz, pocatecni_maska, max_it);

%Vykreslen� 
imshow(Obr,'initialmagnification',200,'displayrange',[0 255]); 
hold on;
contour(mapa, [0 0], 'g','LineWidth',4);
contour(mapa, [0 0], 'k','LineWidth',2);
hold off;
