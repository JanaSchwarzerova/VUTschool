clc
close all
clear all  

%% Bakaláøská práce
% Název: Segmentace ultrazvukových sekvencí
% autor: Jana Schwarzerová, uèo: 186686
% Verze Matlab R2015b

%% Segmentace Narùstání oblastí v èase 

%Pøeddefinování pomocných promìnných:
Vystup_data_narust_oblast = {};
Vstup_data_narust_oblast = {};
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
     %x = 5; % Pøeddefinované okno mediánové filtrace (možnost libovolnì mìnit)
     %Vystup_obraz = medfilt2(Vstup_obraz,[x x]);
     % figure %Možnost zobrazení
     % imshowpair(Vstup_obraz, Vystup_obraz, 'montage')
     %Vstup_obraz = Vystup_obraz; %Pøepsání pro pozdìjší použití
  
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

    %                       (Možnost výbìru mezi manuálním nastavením souøadnic 
    %                                         a defuatlním nastavením souøadnic)

    if pocitadlo == 0 
        otazka = questdlg('Budeš chtít najít manuálnì hodnotu èi defualtnì vstupní souøadnice?','Výbìr',...
                           'Manuálnì','Defualtnì','Defualtnì');
            switch otazka
                case 'Manuálnì'     %Pokud vybereš, že chceš urèit vstupní hodnoty ze vstupního obrazu  
                                    %urèení vstupních hodnot do metody segmentace narùstání oblastí manuálnì 
                                    %pomocí funkce getpts
                    imshow(Vstup_obraz,[])
                    [y,x]=getpts;
                    y=round(y(1));
                    x=round(x(1));
                 case 'Defualtnì'   %Pokud vybereš, že chceš urèit hodnoty defualtnì
                                    %Automatické pøepnutí na výbìr defualtního nastavení 
                    rozmery = size(Vstup_obraz);
                    x=round(rozmery(1)/2); %souøadnice deufautlnì nastavené
                    y=round(rozmery(2)/2);                     
            end
    else
        s  = regionprops(Vystup_1,'centroid');
        y = round(s(1).Centroid(1));
        x = round(s(1).Centroid(2));
    end

    reg_max=0.1; %maximální interval intenzity 
                 %u realných obrazù s použitím napø. Lee filtru je potøeba 
                 %reg_max nastavit na nižší hodnotu napø. reg_max = 0.1  
                 %u fantomu možnost defualtního nastavení 0.2
             
    [Vystup] = Narust_oblast(Vstup_obraz, x, y, reg_max); 
  
    
    %Použití morgolofigkých operací: 
    Vystup_1 = im2double(Vystup); 
    r  = regionprops(Vystup_1,'MinorAxisLength');
    r = round(r.MinorAxisLength(1)/15);  
    SE = strel('diamond',r);
    Vystup_1 = imclose(Vystup,SE);
    Vystup_1 = imopen(Vystup_1,SE);   

    %Zobrazení: 
    imshow(Obr,[]); 
    hold on;
    contour(Vystup_1,'g','LineWidth',4);
    contour(Vystup_1,'k','LineWidth',2);
    hold off;
 
    %Uložení pro možnost následného zobrazení
    Vystup_data_narust_oblast = [Vystup_data_narust_oblast,Vystup_1];
    Vstup_data_narust_oblast = [Vstup_data_narust_oblast,Vstup_obraz];
 
    pocitadlo = pocitadlo + 1;  
    pause(.01);
   end
   
   
% %________________________________________________________________________
%% Vykreslení obrazu v bakaláøce

% Vykreslení fantomu: *****************************************************

% pom_vstup_obr_0 = Vstup_data_narust_oblast{1};
% pom_vstup_obr_1 = Vstup_data_narust_oblast{2};
% pom_vstup_obr_2 = Vstup_data_narust_oblast{3};
% pom_vstup_obr_3 = Vstup_data_narust_oblast{4};
% pom_vstup_obr_4 = Vstup_data_narust_oblast{5};

% pom_vystup_obr_0 = Vystup_data_narust_oblast{1};
% pom_vystup_obr_1 = [zeros(273,325),Vystup_data_narust_oblast{2}];
% pom_vystup_obr_2 = [zeros(273,650),Vystup_data_narust_oblast{3}];
% pom_vystup_obr_3 = [zeros(273,975),Vystup_data_narust_oblast{4}];
% pom_vystup_obr_4 = [zeros(273,1300),Vystup_data_narust_oblast{5}]; 

% figure
% imshow([pom_vstup_obr_0,pom_vstup_obr_1,pom_vstup_obr_2,pom_vstup_obr_3 ...
%        ,pom_vstup_obr_4]); 
% hold on;
% contour(pom_vystup_obr_0,'g','LineWidth',4);
% contour(pom_vystup_obr_0,'k','LineWidth',2);
% contour(pom_vystup_obr_1,'g','LineWidth',4);
% contour(pom_vystup_obr_1,'k','LineWidth',2);
% contour(pom_vystup_obr_2,'g','LineWidth',4);
% contour(pom_vystup_obr_2,'k','LineWidth',2);
% contour(pom_vystup_obr_3,'g','LineWidth',4);
% contour(pom_vystup_obr_3,'k','LineWidth',2);
% contour(pom_vystup_obr_4,'g','LineWidth',4);
% contour(pom_vystup_obr_4,'k','LineWidth',2);
% hold off; 

% figure
% imshow([Vystup_data_narust_oblast{1},Vystup_data_narust_oblast{2},...
%         Vystup_data_narust_oblast{3},Vystup_data_narust_oblast{4}...
%        ,Vystup_data_narust_oblast{5}]); 
   

% Vykreslení realných dat: ************************************************

% pom_vstup_obr_0 = Vstup_data_narust_oblast{1};
% pom_vstup_obr_1 = Vstup_data_narust_oblast{2};
% pom_vstup_obr_2 = Vstup_data_narust_oblast{3};
% pom_vstup_obr_3 = Vstup_data_narust_oblast{4};
% pom_vstup_obr_4 = Vstup_data_narust_oblast{5};

% pom_vystup_obr_0 = Vystup_data_narust_oblast{1};
% pom_vystup_obr_1 = [zeros(289,151),Vystup_data_narust_oblast{2}];
% pom_vystup_obr_2 = [zeros(289,302),Vystup_data_narust_oblast{3}];
% pom_vystup_obr_3 = [zeros(289,453),Vystup_data_narust_oblast{4}];
% pom_vystup_obr_4 = [zeros(289,604),Vystup_data_narust_oblast{5}];

% figure
% imshow([[pom_vstup_obr_0,[]],[pom_vstup_obr_1,[]],[pom_vstup_obr_2,[]],[pom_vstup_obr_3,[]] ...
%        ,[pom_vstup_obr_4,[]]]); 
% hold on;
% contour(pom_vystup_obr_0,'g','LineWidth',4);
% contour(pom_vystup_obr_0,'k','LineWidth',2);
% contour(pom_vystup_obr_1,'g','LineWidth',4);
% contour(pom_vystup_obr_1,'k','LineWidth',2);
% contour(pom_vystup_obr_2,'g','LineWidth',4);
% contour(pom_vystup_obr_2,'k','LineWidth',2);
% contour(pom_vystup_obr_3,'g','LineWidth',4);
% contour(pom_vystup_obr_3,'k','LineWidth',2);
% contour(pom_vystup_obr_4,'g','LineWidth',4);
% contour(pom_vystup_obr_4,'k','LineWidth',2);
% hold off;
% figure
% imshow([Vystup_data_narust_oblast{1},Vystup_data_narust_oblast{2},...
%         Vystup_data_narust_oblast{3},Vystup_data_narust_oblast{4}...
%        ,Vystup_data_narust_oblast{5}]); 
   
%% Pøíkaz použitý k ukládání výsledkù 
%saveas(gcf,['Real_narust',num2str(i),'.jpg']);