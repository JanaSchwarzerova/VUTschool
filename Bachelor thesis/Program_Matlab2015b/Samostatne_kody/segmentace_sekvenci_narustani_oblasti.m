clc
close all
clear all  

%% Bakal��sk� pr�ce
% N�zev: Segmentace ultrazvukov�ch sekvenc�
% autor: Jana Schwarzerov�, u�o: 186686
% Verze Matlab R2015b

%% Segmentace Nar�st�n� oblast� v �ase 

%P�eddefinov�n� pomocn�ch prom�nn�ch:
Vystup_data_narust_oblast = {};
Vstup_data_narust_oblast = {};
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

    %                       (Mo�nost v�b�ru mezi manu�ln�m nastaven�m sou�adnic 
    %                                         a defuatln�m nastaven�m sou�adnic)

    if pocitadlo == 0 
        otazka = questdlg('Bude� cht�t naj�t manu�ln� hodnotu �i defualtn� vstupn� sou�adnice?','V�b�r',...
                           'Manu�ln�','Defualtn�','Defualtn�');
            switch otazka
                case 'Manu�ln�'     %Pokud vybere�, �e chce� ur�it vstupn� hodnoty ze vstupn�ho obrazu  
                                    %ur�en� vstupn�ch hodnot do metody segmentace nar�st�n� oblast� manu�ln� 
                                    %pomoc� funkce getpts
                    imshow(Vstup_obraz,[])
                    [y,x]=getpts;
                    y=round(y(1));
                    x=round(x(1));
                 case 'Defualtn�'   %Pokud vybere�, �e chce� ur�it hodnoty defualtn�
                                    %Automatick� p�epnut� na v�b�r defualtn�ho nastaven� 
                    rozmery = size(Vstup_obraz);
                    x=round(rozmery(1)/2); %sou�adnice deufautln� nastaven�
                    y=round(rozmery(2)/2);                     
            end
    else
        s  = regionprops(Vystup_1,'centroid');
        y = round(s(1).Centroid(1));
        x = round(s(1).Centroid(2));
    end

    reg_max=0.1; %maxim�ln� interval intenzity 
                 %u realn�ch obraz� s pou�it�m nap�. Lee filtru je pot�eba 
                 %reg_max nastavit na ni��� hodnotu nap�. reg_max = 0.1  
                 %u fantomu mo�nost defualtn�ho nastaven� 0.2
             
    [Vystup] = Narust_oblast(Vstup_obraz, x, y, reg_max); 
  
    
    %Pou�it� morgolofigk�ch operac�: 
    Vystup_1 = im2double(Vystup); 
    r  = regionprops(Vystup_1,'MinorAxisLength');
    r = round(r.MinorAxisLength(1)/15);  
    SE = strel('diamond',r);
    Vystup_1 = imclose(Vystup,SE);
    Vystup_1 = imopen(Vystup_1,SE);   

    %Zobrazen�: 
    imshow(Obr,[]); 
    hold on;
    contour(Vystup_1,'g','LineWidth',4);
    contour(Vystup_1,'k','LineWidth',2);
    hold off;
 
    %Ulo�en� pro mo�nost n�sledn�ho zobrazen�
    Vystup_data_narust_oblast = [Vystup_data_narust_oblast,Vystup_1];
    Vstup_data_narust_oblast = [Vstup_data_narust_oblast,Vstup_obraz];
 
    pocitadlo = pocitadlo + 1;  
    pause(.01);
   end
   
   
% %________________________________________________________________________
%% Vykreslen� obrazu v bakal��ce

% Vykreslen� fantomu: *****************************************************

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
   

% Vykreslen� realn�ch dat: ************************************************

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
   
%% P��kaz pou�it� k ukl�d�n� v�sledk� 
%saveas(gcf,['Real_narust',num2str(i),'.jpg']);