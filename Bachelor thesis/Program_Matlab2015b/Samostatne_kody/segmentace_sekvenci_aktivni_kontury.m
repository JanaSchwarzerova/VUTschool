clc
close all
clear all  

%% Bakal��sk� pr�ce
% N�zev: Segmentace ultrazvukov�ch sekvenc�
% autor: Jana Schwarzerov�, u�o: 186686
% Verze Matlab R2015b

%% Segmentace Nar�st�n� oblast� v �ase 

%P�eddefinov�n� pomocn�ch prom�nn�ch:
Vystup_data_aktiv_kontur={};
Vstup_data_aktiv_kontur = {};
pocitadlo = 0;  

% ****************************Na�ten� dat**********************************                                       
%                                                    (Vyber jen jedny data - jen jeden Obr)   
   
  %Na�ten� fantomu
   %for i=0:4 
    %Obr = imread(['sedy_',num2str(i),'.bmp']);   

  %Na�ten� re�ln�ch dat:                              (Vyber jen jednu sekvenci co chce� na��st)
   load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
   %load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat')
   %load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat')
   for i=100:105                            %Pokud budete cht�t postupovat od 
                                            %v�t��ho ��sla pom men�� nutno
                                            %zadat takto nap�. i=100:-1:20
    Obr = data1{i};
    %Obr = data2{i}; 
    
   %Na�ten� libovoln�ch dat
   %for i=x:y  %x,y zvol adekv�tn� k vybran�m dat�m 
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

    if pocitadlo == 0    
       pocatecni_maska = zeros(size(Vstup_obraz));
       pocatecni_maska = roipoly(Vstup_obraz);
    else 
       pocatecni_maska = zeros(size(Vstup_obraz));
       pocatecni_maska = Vystup;        
    end 
    
     max_it = 400; %Maxim�ln� po�et iterac�
    [mapa] = Aktiv_kontur(Vstup_obraz, pocatecni_maska, max_it);

     Vystup = im2double(mapa);
     r  = regionprops(Vystup,'MinorAxisLength');
     pom_max = max([r.MinorAxisLength]);
     r = round(pom_max/50);  
     SE = strel('diamond',r);
     Vystup = imopen(Vystup,SE);

    %Vykreslen� 
    imshow(Obr,'initialmagnification',200,'displayrange',[0 255]); 
    hold on;
    contour(Vystup, [0 0], 'g','LineWidth',4);
    contour(Vystup, [0 0], 'k','LineWidth',2);
    hold off;
    
    %Ukl�d�n� v�sledn�ch dat pro aktivn� kontury 
    Vstup_data_aktiv_kontur = [Vstup_data_aktiv_kontur,Vstup_obraz];
    Vystup_data_aktiv_kontur = [Vystup_data_aktiv_kontur,Vystup];
    
    pocitadlo = pocitadlo + 1;  
    pause(.01);
 end
   
   
% %________________________________________________________________________
%% Vykreslen� obrazu v bakal��ce

% Vykreslen� fantomu: *****************************************************

% pom_vstup_obr_0 = Vstup_data_aktiv_kontur{1};
% pom_vstup_obr_1 = Vstup_data_aktiv_kontur{2};
% pom_vstup_obr_2 = Vstup_data_aktiv_kontur{3};
% pom_vstup_obr_3 = Vstup_data_aktiv_kontur{4};
% pom_vstup_obr_4 = Vstup_data_aktiv_kontur{5};

% pom_vystup_obr_0 = Vystup_data_aktiv_kontur{1};
% pom_vystup_obr_1 = [zeros(273,325),Vystup_data_aktiv_kontur{2}];
% pom_vystup_obr_2 = [zeros(273,650),Vystup_data_aktiv_kontur{3}];
% pom_vystup_obr_3 = [zeros(273,975),Vystup_data_aktiv_kontur{4}];
% pom_vystup_obr_4 = [zeros(273,1300),Vystup_data_aktiv_kontur{5}];

% figure
% imshow([pom_vstup_obr_0,pom_vstup_obr_1,pom_vstup_obr_2,pom_vstup_obr_3 ...
%        ,pom_vstup_obr_4]); 
% hold on;
% contour(pom_vystup_obr_0,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_0,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_1,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_1,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_2,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_2,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_3,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_3,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_4,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_4,[0 0],'k','LineWidth',2);
% hold off;

% figure
% imshow([Vystup_data_aktiv_kontur{1},Vystup_data_aktiv_kontur{2},...
%         Vystup_data_aktiv_kontur{3},Vystup_data_aktiv_kontur{4}...
%        ,Vystup_data_aktiv_kontur{5}]); 

%Vykreslen� pro re�ln� data:***********************************************

% pom_vstup_obr_0 = Vstup_data_aktiv_kontur{1};
% pom_vstup_obr_1 = Vstup_data_aktiv_kontur{2};
% pom_vstup_obr_2 = Vstup_data_aktiv_kontur{3};
% pom_vstup_obr_3 = Vstup_data_aktiv_kontur{4};
% pom_vstup_obr_4 = Vstup_data_aktiv_kontur{5};

% pom_vystup_obr_0 = Vystup_data_aktiv_kontur{1};
% pom_vystup_obr_1 = [zeros(289,151),Vystup_data_aktiv_kontur{2}];
% pom_vystup_obr_2 = [zeros(289,302),Vystup_data_aktiv_kontur{3}];
% pom_vystup_obr_3 = [zeros(289,453),Vystup_data_aktiv_kontur{4}];
% pom_vystup_obr_4 = [zeros(289,604),Vystup_data_aktiv_kontur{5}];

% figure
% imshow([pom_vstup_obr_0,pom_vstup_obr_1,pom_vstup_obr_2,pom_vstup_obr_3 ...
%        ,pom_vstup_obr_4]);
% hold on;
% contour(pom_vystup_obr_0,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_0,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_1,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_1,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_2,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_2,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_3,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_3,[0 0],'k','LineWidth',2);
% contour(pom_vystup_obr_4,[0 0],'g','LineWidth',4);
% contour(pom_vystup_obr_4,[0 0],'k','LineWidth',2);
% hold off;
% figure
% imshow([Vystup_data_aktiv_kontur{1},Vystup_data_aktiv_kontur{2},...
%         Vystup_data_aktiv_kontur{3},Vystup_data_aktiv_kontur{4}...
%        ,Vystup_data_aktiv_kontur{5}]); 

%% P��kaz pou�it� k ukl�d�n� v�sledk� 
%saveas(gcf,['Real_aktiv',num2str(i),'.jpg']);