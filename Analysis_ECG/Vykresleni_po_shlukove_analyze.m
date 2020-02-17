clear all
clc

%% Vykreslení konkrétního signálu jednotlivých svodù (po aplikací shlukovací analýzy)

% Mìjte prosím pøed spuštìním tohoto skriptu ve složce nahrané všechny signály 
% od MO1_001_03.mat po MO1_125_03.mat i od MO1_001_12.mat po MO1_125_12.mat

 jednotky = 1; %První si musím naèíst matici, ve které mám analyzované svody
 [x15] = leads_15(jednotky);
 puvodni_signal=x15(1:15,:); %Naètení signálu, který budeme chtít vykreslit 
                                %vždy postupujeme násobky 15 
                                %1. signál je tedy (1:15,:); 2. signál 16:30 atd.
                                %Nyní vykreslujeme 1. signál (tento signál
                                %je také vykreslen v dokumentaci (èlánku) k
                                %projektu 
                              
    fvz=500; %Vzorkovací frekvence uvedená v CSE databázi
    [leads_x15,samples]=size(x15);
 
    [leads,samples]=size(puvodni_signal);    
    for i=1:leads %For cyklus, díky kterému projdu všechny svody
        signal(i,:)=puvodni_signal(i,:)-mean(puvodni_signal(i,:));%Odstranìní jednosmìrnné složky
        QRS_Decision_rule(i)=max(abs(signal(i,:))); %Nalezení maxima v signálu, 
    end
    %% Lynnov filter pasmova propust 0.18 az 18 hz 
    pp=[(0.18*2*pi),(18*2*pi)]./fvz;
    b = fir1(2,pp,'bandpass');
    for i=1:leads
        signal(i,:)=filter(b,1,signal(i,:)); %Filtrace pásmovou propustí Lynnova typu
        ECGDER(i,:)=diff(signal(i,:)); %Signál je odsud už ECGDER (tedy derivovaný signál)
        Deteciton_rule_ECGDER(i)=max(ECGDER(i,:)); %Nalezení maxima v ECGDER, 
                                           %které dále použijme pøi rozhodovacím pravidle, 
                                           %pro urèení prvního QRS komplexu
    end
    %% Detekce QRS 
    [R,Q,S,Sum_QRS] = Detection_QRS( ECGDER,signal,leads,Deteciton_rule_ECGDER);
    distance=round((0.13/10)*5000); %V èlánku se psala sice hodnota 90 ms
                                    %ale po nìkolika pokusech jsme dospìli
                                    %k názoru, že 140 ms bude mnohem lepší
     %Shluková analýza na komplex QRS
    for j=1:leads %Zde se ošetøování prázdných svodù, již provádìt nemusí,
                  %jeliož jsou ošetøené už ve funcki Detection_QRS
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
    %Výpoèet rozhodovacího pravidla pro P vlnu
    P_Deteciton_rule=max(DERFI,[],2); % Nalezení maxima v DERFI
    [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule);
    
    %Shluková analýza na vlnu P
    for j=1:leads %Ošetøení nenadetekovaných P vln 
                  %Zde se ošetøování prázdných svodù, již provádìt nemusí,
                  %jeliož jsou ošetøené už ve funcki Detection_Pwave
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

    %Shluková analýza pro vlnu T
    for j=1:leads %Ošetøení svodù, když nebude nadetekována T vlna
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
         if length(Groups_Q{i})>=10%Jelikož nám shluková analýza rozdìlí vzorky do skupin,
                                   %kde v jedné skupinì nesmí být vzdálenost mezi minimem 
                                   %a maximem vìtší než námi stanovená hranice.
                                   %V této podmínce vybírám, že jakmile je
                                   %aspoò 8 detekcí z 15 možných hodnot se
                                   %nachází v dané buòce, tak v mediánu
                                   %této buòky je detekovaný kmit Q. 
                                   %Pokud se tedy podmínka nesplní
                                   %pøedpokládáme, že detekce byla chybná.
                          %Parametr 8 jsme vybrali logicky, jelikož to mùže
                          %být èíslo od 1-15 a bylo by dobré, kdyby to byla
                          %nejménì polovina, takže 8
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
                                    %pøibližnì tolik, kolik bylo v signálu
                                    %S vln by mìlo být i T vln
             p_T=median(Groups_T{i}(:));
             Groups_Tfin(pom) =p_T;
             pom=1+pom;
         end
    end
    pom=1;
    for i=1:length(Groups_P_onset)
          if length(Groups_P_onset{i})>=8;%Na tuto podmínku, jsme šli logicky, tedy
                                          %pøibližnì tolik, kolik bylo v signálu
                                          %S vln by mìlo být i T vln
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

    %% Samotné vykreslování
    for i=1:leads
        if i == 5 %Chceme vykreslit prvnì jen pro svody X,Y,Z,I,II
            figure (1)
            for j=1:i 
            subplot(5,1,j)
            plot((signal(j,:)))
            if j == 1
                title('Svod X')
            elseif j == 2
                title('Svod Y')
            elseif j == 3
                title('Svod Z')
            elseif j == 4
                title('Svod I')
            elseif j == 5 
                title('Svod II')
            end
            hold on 
                for m=1:length(Groups_P_onsetfin) %Musíme projít všechny hodnoty co chci vykrelit ve struktuøe %vždy si najdu støední hodnotu z odhadù výskytu a tu pak vykresluji
                stem(Groups_P_onsetfin(1,m),signal(j,round(Groups_P_onsetfin(1,m))),'+')
                end
                for m=1:length(Groups_P_endfin) 
                stem(Groups_P_endfin(1,m),signal(j,round(Groups_P_endfin(1,m))),'+')
                end
                for m=1:length(Groups_Qfin)
                stem(Groups_Qfin(1,m),signal(j,round(Groups_Qfin(1,m))),'*')
                end
                for m=1:length(Groups_Sfin)
                stem(Groups_Sfin(1,m),signal(j,round(Groups_Sfin(1,m))),'*')
                end
                for m=1:length(Groups_Tfin) 
                stem(Groups_Tfin(1,m),signal(j,round(Groups_Tfin(1,m))),'o')
                end
            end
        end
        if i == 10  %Chceme vykreslit prvnì jen pro svody III, aVR, aVL, aVF, V1 
            figure (2)
            pocet = 0;
            for j=6:i
            pocet = pocet + 1;
            subplot(5,1,pocet)
            plot((signal(j,:)))
            if j == 6
                title('Svod III')
            elseif j == 7
                title('Svod aVR')
            elseif j == 8
                title('Svod aVL')
            elseif j == 9
                title('Svod aVF')
            elseif j == 10
                title('Svod V1')
            end
            hold on               
                for m=1:length(Groups_P_onsetfin) %Musíme projít všechny hodnoty co chci vykrelit ve struktuøe %vždy si najdu støední hodnotu z odhadù výskytu a tu pak vykresluji
                stem(Groups_P_onsetfin(1,m),signal(j,round(Groups_P_onsetfin(1,m))),'+')
                end
                for m=1:length(Groups_P_endfin) 
                stem(Groups_P_endfin(1,m),signal(j,round(Groups_P_endfin(1,m))),'+')
                end
                for m=1:length(Groups_Qfin)
                stem(Groups_Qfin(1,m),signal(j,round(Groups_Qfin(1,m))),'*')
                end
                for m=1:length(Groups_Sfin)
                stem(Groups_Sfin(1,m),signal(j,round(Groups_Sfin(1,m))),'*')
                end
                for m=1:length(Groups_Tfin) 
                stem(Groups_Tfin(1,m),signal(j,round(Groups_Tfin(1,m))),'o')
                end
            end
        end
        if i == 15  %Chceme vykreslit prvnì jen pro svody V2,V3,V4,V5,V6
            figure (3)
            pocet = 0;
            for j=11:i
            pocet = pocet + 1;
            subplot(5,1,pocet)
            plot((signal(j,:)))
            if j == 11
                title('Svod V2')
            elseif j == 12
                title('Svod V3')
            elseif j == 13
                title('Svod V4')
            elseif j == 14
                title('Svod V5')
            elseif j == 15 
                title('Svod V6')
            end
            hold on 
                for m=1:length(Groups_P_onsetfin) %Musíme projít všechny hodnoty co chci vykrelit ve struktuøe %vždy si najdu støední hodnotu z odhadù výskytu a tu pak vykresluji
                stem(Groups_P_onsetfin(1,m),signal(j,round(Groups_P_onsetfin(1,m))),'+')
                end
                for m=1:length(Groups_P_endfin) 
                stem(Groups_P_endfin(1,m),signal(j,round(Groups_P_endfin(1,m))),'+')
                end
                for m=1:length(Groups_Qfin)
                stem(Groups_Qfin(1,m),signal(j,round(Groups_Qfin(1,m))),'*')
                end
                for m=1:length(Groups_Sfin)
                stem(Groups_Sfin(1,m),signal(j,round(Groups_Sfin(1,m))),'*')
                end
                for m=1:length(Groups_Tfin) 
                stem(Groups_Tfin(1,m),signal(j,round(Groups_Tfin(1,m))),'o')
                end
            end
        end
    end
