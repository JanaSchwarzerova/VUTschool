clear all
clc

%% Vykreslen� konkr�tn�ho sign�lu jednotliv�ch svod� (p�ed aplikac� shlukovac� anal�zy)

% M�jte pros�m p�ed spu�t�n�m tohoto skriptu ve slo�ce nahran� v�echny sign�ly 
% od MO1_001_03.mat po MO1_125_03.mat i od MO1_001_12.mat po MO1_125_12.mat

 jednotky = 1; %Prvn� si mus�m na��st matici, ve kter� m�m analyzovan� svody
 [x15] = leads_15(jednotky);
 [leads_x15,samples]=size(x15);
 
    puvodni_signal=x15(1:15,:); %Na�ten� sign�lu, kter� budeme cht�t vykreslit 
                                %v�dy postupujeme n�sobky 15 
                                %1. sign�l je tedy (1:15,:); 2. sign�l 16:30 atd.
                                %Nyn� vykreslujeme 1. sign�l (tento sign�l
                                %je tak� vykreslen v dokumentaci (�l�nku) k
                                %projektu 
                                
    fvz=500; %Vzorkovac� frekvence uveden� v CSE datab�zi
    [leads,samples]=size(puvodni_signal); %Zjist�n� rozm�r� sign�lu
    for i=1:leads %For cyklus, d�ky kter�mu projdu v�echny svody
        signal(i,:)=puvodni_signal(i,:)-mean(puvodni_signal(i,:));%Odstran�n� jednosm�rnn� slo�ky
        QRS_Decision_rule(i)=max(abs(signal(i,:))); %Nalezen� maxima v sign�lu, 
    end
    %% Lynnov filter pasmova propust 0.18 az 18 hz 
    pp=[(0.18*2*pi),(18*2*pi)]./fvz;
    b = fir1(2,pp,'bandpass');
    for i=1:leads
        signal(i,:)=filter(b,1,signal(i,:)); %Filtrace p�smovou propust� Lynnova typu
        ECGDER(i,:)=diff(signal(i,:)); %Sign�l je odsud u� ECGDER (tedy derivovan� sign�l)
        Deteciton_rule_ECGDER(i)=max(ECGDER(i,:)); %Nalezen� maxima v ECGDER, 
                                           %kter� d�le pou�ijme p�i rozhodovac�m pravidle, 
                                           %pro ur�en� prvn�ho QRS komplexu
    end
    %% Detekce QRS 
    [R,Q,S,Sum_QRS] = Detection_QRS( ECGDER,signal,leads,Deteciton_rule_ECGDER);
    distance=round((0.13/10)*5000); %V �l�nku se psala sice hodnota 90 ms
                                    %ale po n�kolika pokusech jsme dosp�li
                                    %k n�zoru, �e 140 ms bude mnohem lep��
    %% Detekce P vlny
    b1 = fir1(2,(12/250)*pi, 'low'); %Aplikace doln� propusti (-3 dB mezn� frekvence 12 Hz)
    for i = 1:leads %nech�me filtr projet v�emi svody na sign�lu ECGDER a vznikne z n�j sign�l DERFI
        DERFI(i,:) = filter(b1,1,ECGDER(i,:)); 
    end
    %V�po�et rozhodovac�ho pravidla pro P vlnu
    P_Deteciton_rule=max(DERFI,[],2); % Nalezen� maxima v DERFI
    [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule);

    %% Detekce T vlny 
    T_Deteciton_rule=max(DERFI,[],2);
    [T]=Detection_Twave(DERFI,leads,Sum_QRS,S,T_Deteciton_rule);

    %% Samotn� vykreslov�n�
    for i=1:leads
        if i == 5 %Chceme vykreslit prvn� jen pro svody X,Y,Z,I,II
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
                for m=1:length(P_onset{j, 1}) %Mus�me proj�t v�echny hodnoty co chci vykrelit ve struktu�e
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
        if i == 10  %Chceme vykreslit prvn� jen pro svody III, aVR, aVL, aVF, V1 
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
                for m=1:length(P_onset{j, 1}) %Mus�me proj�t v�echny hodnoty co chci vykrelit ve struktu�e
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
        if i == 15  %Chceme vykreslit prvn� jen pro svody V2,V3,V4,V5,V6
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
                for m=1:length(P_onset{j, 1}) %Mus�me proj�t v�echny hodnoty co chci vykrelit ve struktu�e
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