clear all
clc

%% Vykreslení konkrétního signálu jednotlivých svodù (pøed aplikací shlukovací analýzy)

% Mìjte prosím pøed spuštìním tohoto skriptu ve složce nahrané všechny signály 
% od MO1_001_03.mat po MO1_125_03.mat i od MO1_001_12.mat po MO1_125_12.mat

 jednotky = 1; %První si musím naèíst matici, ve které mám analyzované svody
 [x15] = leads_15(jednotky);
 [leads_x15,samples]=size(x15);
 
    puvodni_signal=x15(1:15,:); %Naètení signálu, který budeme chtít vykreslit 
                                %vždy postupujeme násobky 15 
                                %1. signál je tedy (1:15,:); 2. signál 16:30 atd.
                                %Nyní vykreslujeme 1. signál (tento signál
                                %je také vykreslen v dokumentaci (èlánku) k
                                %projektu 
                                
    fvz=500; %Vzorkovací frekvence uvedená v CSE databázi
    [leads,samples]=size(puvodni_signal); %Zjistìní rozmìrù signálu
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
    %% Detekce P vlny
    b1 = fir1(2,(12/250)*pi, 'low'); %Aplikace dolní propusti (-3 dB mezní frekvence 12 Hz)
    for i = 1:leads %necháme filtr projet všemi svody na signálu ECGDER a vznikne z nìj signál DERFI
        DERFI(i,:) = filter(b1,1,ECGDER(i,:)); 
    end
    %Výpoèet rozhodovacího pravidla pro P vlnu
    P_Deteciton_rule=max(DERFI,[],2); % Nalezení maxima v DERFI
    [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule);

    %% Detekce T vlny 
    T_Deteciton_rule=max(DERFI,[],2);
    [T]=Detection_Twave(DERFI,leads,Sum_QRS,S,T_Deteciton_rule);

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
                for m=1:length(P_onset{j, 1}) %Musíme projít všechny hodnoty co chci vykrelit ve struktuøe
                stem(P_onset{j, 1}(1,m),signal(j,P_onset{j, 1}(1,m)),'+')
                end
                for m=1:length(P_end{j, 1})
                stem(P_end{j, 1}(1,m),signal(j,P_end{j, 1}(1,m)),'+')
                end
                for m=1:length(Q{j, 1})
                stem(Q{j, 1}(1,m),signal(j,Q{j, 1}(1,m)),'*') 
                end
                for m=1:length(S{j, 1})
                stem(S{j, 1}(1,m),signal(j,S{j, 1}(1,m)),'*') 
                end
                for m=1:length(T{1, j})
                stem(T{1, j}(1,m),signal(j,T{1, j}(1,m)),'o')
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
                for m=1:length(P_onset{j, 1}) %Musíme projít všechny hodnoty co chci vykrelit ve struktuøe
                stem(P_onset{j, 1}(1,m),signal(j,P_onset{j, 1}(1,m)),'+')
                end
                for m=1:length(P_end{j, 1})
                stem(P_end{j, 1}(1,m),signal(j,P_end{j, 1}(1,m)),'+')
                end
                for m=1:length(Q{j, 1})
                stem(Q{j, 1}(1,m),signal(j,Q{j, 1}(1,m)),'*') 
                end
                for m=1:length(S{j, 1})
                stem(S{j, 1}(1,m),signal(j,S{j, 1}(1,m)),'*') 
                end
                for m=1:length(T{1, j})
                stem(T{1, j}(1,m),signal(j,T{1, j}(1,m)),'o')
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
                for m=1:length(P_onset{j, 1}) %Musíme projít všechny hodnoty co chci vykrelit ve struktuøe
                stem(P_onset{j, 1}(1,m),signal(j,P_onset{j, 1}(1,m)),'+')
                end
                for m=1:length(P_end{j, 1})
                stem(P_end{j, 1}(1,m),signal(j,P_end{j, 1}(1,m)),'+')
                end
                for m=1:length(Q{j, 1})
                stem(Q{j, 1}(1,m),signal(j,Q{j, 1}(1,m)),'*') 
                end
                for m=1:length(S{j, 1})
                stem(S{j, 1}(1,m),signal(j,S{j, 1}(1,m)),'*') 
                end
                for m=1:length(T{1, j})
                stem(T{1, j}(1,m),signal(j,T{1, j}(1,m)),'o')
                end
            end
        end
    end