clc
close all
clear all  

%% Bakaláøská práce
% Název: Segmentace ultrazvukových sekvencí
% autor: Jana Schwarzerová, uèo: 186686
% Verze Matlab R2015b

%% Segmentace Narùstání oblastí v èase 

%Pøeddefinování pomocných promìnných:
Vystup_data_aktiv_kontur={};
Vstup_data_aktiv_kontur = {};
pocitadlo = 0;  

% ****************************Naètení dat**********************************                                       
%                                                    (Vyber jen jedny data - jen jeden Obr)   
   
  %Naètení fantomu
   %for i=0:4 
    %Obr = imread(['sedy_',num2str(i),'.bmp']);   

  %Naètení reálných dat:                              (Vyber jen jednu sekvenci co chceš naèíst)
   load('per02_2_4_trig_DR50_inp_con_mreg_121120.mat') 
   %load('per02_2_8_trig_DR50_inp_con_mreg_121113.mat')
   %load('per02_2_13_trig_DR50_inp_con_mreg_121120.mat')
   for i=100:105                            %Pokud budete chtít postupovat od 
                                            %vìtšího èísla pom menší nutno
                                            %zadat takto napø. i=100:-1:20
    Obr = data1{i};
    %Obr = data2{i}; 
    
   %Naètení libovolných dat
   %for i=x:y  %x,y zvol adekvátnì k vybraným datùm 
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

    if pocitadlo == 0    
       pocatecni_maska = zeros(size(Vstup_obraz));
       pocatecni_maska = roipoly(Vstup_obraz);
    else 
       pocatecni_maska = zeros(size(Vstup_obraz));
       pocatecni_maska = Vystup;        
    end 
    
     max_it = 400; %Maximální poèet iterací
    [mapa] = Aktiv_kontur(Vstup_obraz, pocatecni_maska, max_it);

     Vystup = im2double(mapa);
     r  = regionprops(Vystup,'MinorAxisLength');
     pom_max = max([r.MinorAxisLength]);
     r = round(pom_max/50);  
     SE = strel('diamond',r);
     Vystup = imopen(Vystup,SE);

    %Vykreslení 
    imshow(Obr,'initialmagnification',200,'displayrange',[0 255]); 
    hold on;
    contour(Vystup, [0 0], 'g','LineWidth',4);
    contour(Vystup, [0 0], 'k','LineWidth',2);
    hold off;
    
    %Ukládání výsledných dat pro aktivní kontury 
    Vstup_data_aktiv_kontur = [Vstup_data_aktiv_kontur,Vstup_obraz];
    Vystup_data_aktiv_kontur = [Vystup_data_aktiv_kontur,Vystup];
    
    pocitadlo = pocitadlo + 1;  
    pause(.01);
 end
   
   
% %________________________________________________________________________
%% Vykreslení obrazu v bakaláøce

% Vykreslení fantomu: *****************************************************

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

%Vykreslení pro reálné data:***********************************************

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

%% Pøíkaz použitý k ukládání výsledkù 
%saveas(gcf,['Real_aktiv',num2str(i),'.jpg']);