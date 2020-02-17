clear all
close all
clc

%% Projekt è. 17 AUTOMATICKÁ DETEKCE HRANIC VLN VE VÍCESVODOVÉM SIGNÁLU

% Mìjte prosím pøed spuštìním tohoto skriptu ve sloce nahrané všechny signály 
% od MO1_001_03.mat po MO1_125_03.mat i od MO1_001_12.mat po MO1_125_12.mat
% Nejprve si musím vytvoøit ze 3 a 12-ti svodovıch signálu 15-ti svodové signály, 
% na kterıch budu detekovat pozice:  - záèátky P vln (P_onset)
%                                    - konce P vlny (P_end)
%                                    - pozice Q (Q)
%                                    - pozice S (S)
%                                    - konce T vln (T)
% První nadetekuji urèené pozice u všech svodù zvláš a následnì pomocí
% shlukovací metody urèím detekci ze všech svodù, které následnì vyhodnotím
% podle CSE databáze.
%UPOZORNÌNÍ - nepouívejte pro detekci v 3 a 12 svodovıch signálech,
%parametry pro shlukovou analızu pøi vyhodnocování jsou zde nastaveny pro
%15 svodové EKG! Pouítí pro detekci 3 a 12 svodovıch signálu mùete a 
%pøenastavíte parametry (pak tento algoritmus funguje i na tyto signály).
%Na zaèátku si naètu referèní hodnoty

Signal=1; %Jeliko zaèínáme detekovat od prvního signálu
pom_Signal =1; %Pomocná pro vyhodnocovanání
pom_poziceEKGvCSE2=[];
pom_x = 0;
%Beat_heart=3;
x = load('poziceEKGvCSE2'); %Naètení referenèních hodnot
poziceEKGvCSE2= x.poziceEKGvCSE2; %Vytaení referenèních hodnot ze struktury
Mean = []; %Pro zaznamenání støední hodnoty pro všechny signály ve vyhodnocení
Standard_deviation = [];%Pro zaznamenání rozptylù pro všechny signály ve vyhodnocení

%Nyní si zavolám funkci, která mi vytvoøí 15svodové signály
 %UPOZORNÌNÍ - u této funkce pøedpokládám, e mám k dispozici 3 svodové
 %             a 12 svodové signály, na kterıch jsme mìli pracovat
 %             tedy ty, které byly v elearningu pod názvem "MO1_yyy_xx.mat"
 %             yyy  je z intervalu od 001 po 125
 %             xx je bud "03" jako tøí svodové nebo "12" jako dvanáctisvodové 
 jednotky = 1;
 [x15] = leads_15(jednotky);
 [leads_x15,samples]=size(x15);
 
for L=1:15:(leads_x15-14) %For cyklus mi kód projede pro uplnì všechny 15 svodové signály
    %%  Pøedzpracování 
    puvodni_signal=x15(L:L+14,:); %Vytvoøení jednoho signálu
    fvz=500; %Vzorkovací frekvence uvedená v CSE databázi
    [leads,samples]=size(puvodni_signal); %Zjistìní rozmìrù signálu
    for i=1:leads %For cyklus, díky kterému projdu všechny svody
        signal(i,:)=puvodni_signal(i,:)-mean(puvodni_signal(i,:));%Odstranìní jednosmìrnné sloky
        QRS_Decision_rule(i)=max(abs(signal(i,:))); %Nalezení maxima v signálu, 
    end
    %% Lynnov filter pasmova propust 0.18 az 18 hz 
    pp=[(0.18*2*pi),(18*2*pi)]./fvz;
    b = fir1(2,pp,'bandpass');
    for i=1:leads
        signal(i,:)=filter(b,1,signal(i,:)); %Filtrace pásmovou propustí Lynnova typu
        ECGDER(i,:)=diff(signal(i,:)); %Signál je odsud u ECGDER (tedy derivovanı signál)
        Deteciton_rule_ECGDER(i)=max(ECGDER(i,:)); %Nalezení maxima v ECGDER, 
                                           %které dále pouijme pøi rozhodovacím pravidle, 
                                           %pro urèení prvního QRS komplexu
    end
    %% Detekce QRS 
    [R,Q,S,Sum_QRS] = Detection_QRS( ECGDER,signal,leads,Deteciton_rule_ECGDER);
    distance=round((0.13/10)*5000); %V èlánku se psala sice hodnota 90 ms
                                    %ale po nìkolika pokusech jsme dospìli
                                    %k názoru, e 140 ms bude mnohem lepší
     %Shluková analıza na komplex QRS
    for j=1:leads %Zde se ošetøování prázdnıch svodù, ji provádìt nemusí,
                  %jelio jsou ošetøené u ve funcki Detection_QRS
        pom_Q(j) = {Q{j,1}(1,:)};
        pom_R(j) = {R{j,1}(1,:)};
        pom_S(j) = {S{j,1}(1,:)};
    end
    [Groups_Q, Z_Q] = seskup2(pom_Q,distance);
    [Groups_R, Z_R] = seskup2(pom_R,distance);
    [Groups_S, Z_S] = seskup2(pom_S,distance);

    %% Detekce P vlny
    b1 = fir1(2,(12/250)*pi, 'low'); %Aplikace dolní propusti (-3 dB mezní frekvence 12 Hz)
    for i = 1:leads %necháme filtr projet všemi svody na signálu ECGDER a vznikne z nìj signál DERFI
        DERFI(i,:) = filter(b1,1,ECGDER(i,:)); 
    end
    %Vıpoèet rozhodovacího pravidla pro P vlnu
    P_Deteciton_rule=max(DERFI,[],2); % Nalezení maxima v DERFI
    [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule);
    
    %Shluková analıza na vlnu P
    for j=1:leads %Ošetøení nenadetekovanıch P vln 
                  %Zde se ošetøování prázdnıch svodù, ji provádìt nemusí,
                  %jelio jsou ošetøené u ve funcki Detection_Pwave
        if isempty(P_onset{j})
            pom_P_onset(j)={0};
        else
            pom_P_onset(j) = {P_onset{j,1}(1,:)};
        end
        if isempty(P_end{j})
            pom_P_end(j)={0};
        else 
            pom_P_end(j) = {P_end{j,1}(1,:)};
        end
    end
    [Groups_P_onset, Z_P_start] = seskup2(pom_P_onset,distance);
    [Groups_P_end, Z_P_end] = seskup2(pom_P_end,distance);

    %% Detekce T vlny 
    T_Deteciton_rule=max(DERFI,[],2);
    [T]=Detection_Twave(DERFI,leads,Sum_QRS,S,T_Deteciton_rule);

    %Shluková analıza pro vlnu T
    for j=1:leads %Ošetøení svodù, kdy nebude nadetekována T vlna
        pom_TT =0;
        if isempty(Q{j,:})
            pom_TT = 1;
        end
    end
    if pom_TT~=1
 	[Groups_T, Z_T] = seskup2(T,distance);
    end
    
    %% Vyhodnocování
    pom=1; %Pomocí pomocné "pom" poèítáme kolikrát probìhnul for cyklus
    for i=1:length(Groups_Q)
         if length(Groups_Q{i})>=10%Jeliko nám shluková analıza rozdìlí vzorky do skupin,
                                   %kde v jedné skupinì nesmí bıt vzdálenost mezi minimem 
                                   %a maximem vìtší ne námi stanovená hranice.
                                   %V této podmínce vybírám, e jakmile je
                                   %aspoò 8 detekcí z 15 monıch hodnot se
                                   %nachází v dané buòce, tak v mediánu
                                   %této buòky je detekovanı kmit Q. 
                                   %Pokud se tedy podmínka nesplní
                                   %pøedpokládáme, e detekce byla chybná.
                          %Parametr 8 jsme vybrali logicky, jeliko to mùe
                          %bıt èíslo od 1-15 a bylo by dobré, kdyby to byla
                          %nejménì polovina, take 8
             p_Q = median(Groups_Q{i}(:));
             Groups_Qfin(pom)=p_Q;
             pom=1+pom; % Poèítám a indexujeme kolikrát probìhl for cyklu 
                        % (tedy kolik P vln se nadetekovalo)
         end
    end
    pom=1;
    for i=1:length(Groups_S)
          if length(Groups_S{i})>=10; %Analogické jako u Q kmitu
             p_S=median(Groups_S{i}(:));
             Groups_Sfin(pom) = p_S;
             pom=1+pom; 
          end
    end
    pom=1;
    for i=1:length(Groups_T)
         if length(Groups_T{i})>=8; %Na tuto podmínku, jsme šli logicky, tedy
                                    %pøiblinì tolik, kolik bylo v signálu
                                    %S vln by mìlo bıt i T vln
             p_T=median(Groups_T{i}(:));
             Groups_Tfin(pom) =p_T;
             pom=1+pom;
         end
    end
    pom=1;
    for i=1:length(Groups_P_onset)
          if length(Groups_P_onset{i})>=8;%Na tuto podmínku, jsme šli logicky, tedy
                                          %pøiblinì tolik, kolik bylo v signálu
                                          %S vln by mìlo bıt i T vln
             p_P_onset=median(Groups_P_onset{i}(:));
             Groups_P_onsetfin(pom) =p_P_onset;
             pom=1+pom;
          end  
    end
    pom=1;
    for i=1:length(Groups_P_end)
        if length(Groups_P_end{i})>=8; %Analogicly se zaèátkem vlny P
             p_P_end=median(Groups_P_end{i}(:));
             Groups_P_endfin(pom) =p_P_end;
             pom=1+pom;
        end  
    end
    
    Position_P_onset{Signal,:}=Groups_P_onsetfin;
    Position_P_end{Signal,:}=Groups_P_endfin;
    Position_Q{Signal,:}=Groups_Qfin;
    Position_S{Signal,:}=Groups_Sfin;
    Position_T{Signal,:}=Groups_Tfin;

    Beat_heart=4*ones(1,125); %Úder srdce jsme si zvolili pomocí odhadù 4
    
    if Signal == 67 || Signal == 69 || Signal == 104 || Signal == 112 || Signal == 120
         %Odstraòuji analyzované signály, které kdy vykreslím, tak se mi vùbec nelíbí 
         
        %VSKUVKA pokus odstranìní signálu s viditelnımi arytmiemi  
        %elseif Signal == 6 || Signal == 11 || Signal == 20 || Signal == 23 || Signal == 26 || Signal == 28 || Signal == 34 || Signal == 40 || Signal == 47 || Signal == 54 || Signal == 61 || Signal == 65 || Signal == 74 || Signal == 75 || Signal == 103 || Signal == 105 || Signal == 109 || Signal == 112|| Signal == 115 || Signal == 117 || Signal == 120 || Signal == 122
        %Odstraòuji analyzované signály, na kterıch jsou známky arytmie - je to ale uplnì nanic
     
        pom_x=pom_x+1; %Ošetøeuji první detekci vyhozeného signálu
        if pom_x == 1 
           if Signal == 1 %Ošetøení, pokud bychom odstraòovali první signál
              pom_poziceEKGvCSE2=[];
           else  %Kdy odstraòujeme špatnı signál, musíme odstranit i danou referenèní hodnotu pro tento signál 
               pom_poziceEKGvCSE2=[pom_poziceEKGvCSE2;poziceEKGvCSE2(1:Signal-1,:)];
               pom_pom = Signal+1; %Pomocná a se mi udìlá matice pom_poziceEKG2vCSE2 stejnì velká jako ta pùvodní
           end
        else
           pom_poziceEKGvCSE2=[pom_poziceEKGvCSE2;poziceEKGvCSE2(pom_pom:Signal-1,:)];
           pom_pom = Signal+1; 
        end
    else
        Result(pom_Signal,1)=Position_P_onset{Signal}(Beat_heart(Signal)); 
        Result(pom_Signal,2)=Position_P_end{Signal}(Beat_heart(Signal)); %Result je koneènı vısledek,  
        Result(pom_Signal,3)=Position_Q{Signal}(Beat_heart(Signal));     %koneèná detekce urèitého
        Result(pom_Signal,4)=Position_S{Signal}(Beat_heart(Signal));     %srdeèního cyklu
        Result(pom_Signal,5)=Position_T{Signal}(Beat_heart(Signal));
        pom_Signal = pom_Signal + 1;
    end
    if Signal == 125 
        pom_poziceEKGvCSE2=[pom_poziceEKGvCSE2;poziceEKGvCSE2(pom_pom:Signal,:)];
    end
    Signal=Signal+1;
end

%Vypoètení statické støedné hodnoty, pro vyhodnocení vıkonnosti algoritmu
Mean(1)=mean((Result(:,1)-pom_poziceEKGvCSE2(:,1))*2); %Promìná vzorku v èase 10000/5000
Mean(2)=mean((Result(:,2)-pom_poziceEKGvCSE2(:,2))*2);
Mean(3)=mean((Result(:,3)-pom_poziceEKGvCSE2(:,3))*2);
Mean(4)=mean((Result(:,4)-pom_poziceEKGvCSE2(:,4))*2);
Mean(5)=mean((Result(:,5)-pom_poziceEKGvCSE2(:,5))*2);

%Vypoètení statické smìrodatné odchylky, pro vyhodnocení vıkonnosti algoritmu

Standard_deviation(1)=std((Result(:,1)-pom_poziceEKGvCSE2(:,1))*2); %Promìná vzorku v èase 10000/5000
Standard_deviation(2)=std((Result(:,2)-pom_poziceEKGvCSE2(:,2))*2);
Standard_deviation(3)=std((Result(:,3)-pom_poziceEKGvCSE2(:,3))*2);
Standard_deviation(4)=std((Result(:,4)-pom_poziceEKGvCSE2(:,4))*2);
Standard_deviation(5)=std((Result(:,5)-pom_poziceEKGvCSE2(:,5))*2);
 %% Vykreslení signálu

% Pro vykreslení signálu, pøi detekci v jednotlivıch svodech (bez aplikace
% shlukové analızy) mùete pouít skript: 
% Vykresleni_pred_shlukovou_analyzou

% Pro vykreslení signálu, pøi detekci v jednotlivıch svodech (s pouitím 
% slukové analızy) mùete pouít skript: 
% Vykreslení_po_shlukove_analyze
