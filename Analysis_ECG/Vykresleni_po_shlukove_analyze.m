clear all
clc

%% Vykreslen� konkr�tn�ho sign�lu jednotliv�ch svod� (po aplikac� shlukovac� anal�zy)

% M�jte pros�m p�ed spu�t�n�m tohoto skriptu ve slo�ce nahran� v�echny sign�ly 
% od MO1_001_03.mat po MO1_125_03.mat i od MO1_001_12.mat po MO1_125_12.mat

 jednotky = 1; %Prvn� si mus�m na��st matici, ve kter� m�m analyzovan� svody
 [x15] = leads_15(jednotky);
 puvodni_signal=x15(1:15,:); %Na�ten� sign�lu, kter� budeme cht�t vykreslit 
                                %v�dy postupujeme n�sobky 15 
                                %1. sign�l je tedy (1:15,:); 2. sign�l 16:30 atd.
                                %Nyn� vykreslujeme 1. sign�l (tento sign�l
                                %je tak� vykreslen v dokumentaci (�l�nku) k
                                %projektu 
                              
    fvz=500; %Vzorkovac� frekvence uveden� v CSE datab�zi
    [leads_x15,samples]=size(x15);
 
    [leads,samples]=size(puvodni_signal);    
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
     %Shlukov� anal�za na komplex QRS
    for j=1:leads %Zde se o�et�ov�n� pr�zdn�ch svod�, ji� prov�d�t nemus�,
                  %jelio� jsou o�et�en� u� ve funcki Detection_QRS
        pom_Q(j) = {Q{j,1}(1,:)};
        pom_R(j) = {R{j,1}(1,:)};
        pom_S(j) = {S{j,1}(1,:)};
    end
    [Groups_Q, Z_Q] = seskup2(pom_Q,distance);
    [Groups_R, Z_R] = seskup2(pom_R,distance);
    [Groups_S, Z_S] = seskup2(pom_S,distance);

    %% Detekce P vlny
    b1 = fir1(2,(12/250)*pi, 'low'); %Aplikace doln� propusti (-3 dB mezn� frekvence 12 Hz)
    for i = 1:leads %nech�me filtr projet v�emi svody na sign�lu ECGDER a vznikne z n�j sign�l DERFI
        DERFI(i,:) = filter(b1,1,ECGDER(i,:)); 
    end
    %V�po�et rozhodovac�ho pravidla pro P vlnu
    P_Deteciton_rule=max(DERFI,[],2); % Nalezen� maxima v DERFI
    [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule);
    
    %Shlukov� anal�za na vlnu P
    for j=1:leads %O�et�en� nenadetekovan�ch P vln 
                  %Zde se o�et�ov�n� pr�zdn�ch svod�, ji� prov�d�t nemus�,
                  %jelio� jsou o�et�en� u� ve funcki Detection_Pwave
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

    %Shlukov� anal�za pro vlnu T
    for j=1:leads %O�et�en� svod�, kdy� nebude nadetekov�na T vlna
        pom_TT =0;
        if isempty(Q{j,:})
            pom_TT = 1;
        end
    end
    if pom_TT~=1
 	[Groups_T, Z_T] = seskup2(T,distance);
    end
    
    %% Vyhodnocov�n�
    pom=1; %Pomoc� pomocn� "pom" po��t�me kolikr�t prob�hnul for cyklus
    for i=1:length(Groups_Q)
         if length(Groups_Q{i})>=10%Jeliko� n�m shlukov� anal�za rozd�l� vzorky do skupin,
                                   %kde v jedn� skupin� nesm� b�t vzd�lenost mezi minimem 
                                   %a maximem v�t�� ne� n�mi stanoven� hranice.
                                   %V t�to podm�nce vyb�r�m, �e jakmile je
                                   %aspo� 8 detekc� z 15 mo�n�ch hodnot se
                                   %nach�z� v dan� bu�ce, tak v medi�nu
                                   %t�to bu�ky je detekovan� kmit Q. 
                                   %Pokud se tedy podm�nka nespln�
                                   %p�edpokl�d�me, �e detekce byla chybn�.
                          %Parametr 8 jsme vybrali logicky, jeliko� to m��e
                          %b�t ��slo od 1-15 a bylo by dobr�, kdyby to byla
                          %nejm�n� polovina, tak�e 8
             p_Q = median(Groups_Q{i}(:));
             Groups_Qfin(pom)=p_Q;
             pom=1+pom; % Po��t�m a indexujeme kolikr�t prob�hl for cyklu 
                        % (tedy kolik P vln se nadetekovalo)
         end
    end
    pom=1;
    for i=1:length(Groups_S)
          if length(Groups_S{i})>=10; %Analogick� jako u Q kmitu
             p_S=median(Groups_S{i}(:));
             Groups_Sfin(pom) = p_S;
             pom=1+pom; 
          end
    end
    pom=1;
    for i=1:length(Groups_T)
         if length(Groups_T{i})>=8; %Na tuto podm�nku, jsme �li logicky, tedy
                                    %p�ibli�n� tolik, kolik bylo v sign�lu
                                    %S vln by m�lo b�t i T vln
             p_T=median(Groups_T{i}(:));
             Groups_Tfin(pom) =p_T;
             pom=1+pom;
         end
    end
    pom=1;
    for i=1:length(Groups_P_onset)
          if length(Groups_P_onset{i})>=8;%Na tuto podm�nku, jsme �li logicky, tedy
                                          %p�ibli�n� tolik, kolik bylo v sign�lu
                                          %S vln by m�lo b�t i T vln
             p_P_onset=median(Groups_P_onset{i}(:));
             Groups_P_onsetfin(pom) =p_P_onset;
             pom=1+pom;
          end  
    end
    pom=1;
    for i=1:length(Groups_P_end)
        if length(Groups_P_end{i})>=8; %Analogicly se za��tkem vlny P
             p_P_end=median(Groups_P_end{i}(:));
             Groups_P_endfin(pom) =p_P_end;
             pom=1+pom;
        end  
    end

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
                for m=1:length(Groups_P_onsetfin) %Mus�me proj�t v�echny hodnoty co chci vykrelit ve struktu�e %v�dy si najdu st�edn� hodnotu z odhad� v�skytu a tu pak vykresluji
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
                for m=1:length(Groups_P_onsetfin) %Mus�me proj�t v�echny hodnoty co chci vykrelit ve struktu�e %v�dy si najdu st�edn� hodnotu z odhad� v�skytu a tu pak vykresluji
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
                for m=1:length(Groups_P_onsetfin) %Mus�me proj�t v�echny hodnoty co chci vykrelit ve struktu�e %v�dy si najdu st�edn� hodnotu z odhad� v�skytu a tu pak vykresluji
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
