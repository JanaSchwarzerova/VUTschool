clear all
close all
clc

%% Projekt �. 17 AUTOMATICK� DETEKCE HRANIC VLN VE V�CESVODOV�M SIGN�LU

% M�jte pros�m p�ed spu�t�n�m tohoto skriptu ve slo�ce nahran� v�echny sign�ly 
% od MO1_001_03.mat po MO1_125_03.mat i od MO1_001_12.mat po MO1_125_12.mat
% Nejprve si mus�m vytvo�it ze 3 a 12-ti svodov�ch sign�lu 15-ti svodov� sign�ly, 
% na kter�ch budu detekovat pozice:  - z���tky P vln (P_onset)
%                                    - konce P vlny (P_end)
%                                    - pozice Q (Q)
%                                    - pozice S (S)
%                                    - konce T vln (T)
% Prvn� nadetekuji ur�en� pozice u v�ech svod� zvl᚝ a n�sledn� pomoc�
% shlukovac� metody ur��m detekci ze v�ech svod�, kter� n�sledn� vyhodnot�m
% podle CSE datab�ze.
%UPOZORN�N� - nepou��vejte pro detekci v 3 a 12 svodov�ch sign�lech,
%parametry pro shlukovou anal�zu p�i vyhodnocov�n� jsou zde nastaveny pro
%15 svodov� EKG! Pou��t� pro detekci 3 a 12 svodov�ch sign�lu m��ete a� 
%p�enastav�te parametry (pak tento algoritmus funguje i na tyto sign�ly).
%Na za��tku si na�tu refer�n� hodnoty

Signal=1; %Jeliko� za��n�me detekovat od prvn�ho sign�lu
pom_Signal =1; %Pomocn� pro vyhodnocovan�n�
pom_poziceEKGvCSE2=[];
pom_x = 0;
%Beat_heart=3;
x = load('poziceEKGvCSE2'); %Na�ten� referen�n�ch hodnot
poziceEKGvCSE2= x.poziceEKGvCSE2; %Vyta�en� referen�n�ch hodnot ze struktury
Mean = []; %Pro zaznamen�n� st�edn� hodnoty pro v�echny sign�ly ve vyhodnocen�
Standard_deviation = [];%Pro zaznamen�n� rozptyl� pro v�echny sign�ly ve vyhodnocen�

%Nyn� si zavol�m funkci, kter� mi vytvo�� 15svodov� sign�ly
 %UPOZORN�N� - u t�to funkce p�edpokl�d�m, �e m�m k dispozici 3 svodov�
 %             a 12 svodov� sign�ly, na kter�ch jsme m�li pracovat
 %             tedy ty, kter� byly v elearningu pod n�zvem "MO1_yyy_xx.mat"
 %             yyy  je z intervalu od 001 po 125
 %             xx je bud "03" jako t�� svodov� nebo "12" jako dvan�ctisvodov� 
 jednotky = 1;
 [x15] = leads_15(jednotky);
 [leads_x15,samples]=size(x15);
 
for L=1:15:(leads_x15-14) %For cyklus mi k�d projede pro upln� v�echny 15 svodov� sign�ly
    %%  P�edzpracov�n� 
    puvodni_signal=x15(L:L+14,:); %Vytvo�en� jednoho sign�lu
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
    
    Position_P_onset{Signal,:}=Groups_P_onsetfin;
    Position_P_end{Signal,:}=Groups_P_endfin;
    Position_Q{Signal,:}=Groups_Qfin;
    Position_S{Signal,:}=Groups_Sfin;
    Position_T{Signal,:}=Groups_Tfin;

    Beat_heart=4*ones(1,125); %�der srdce jsme si zvolili pomoc� odhad� 4
    
    if Signal == 67 || Signal == 69 || Signal == 104 || Signal == 112 || Signal == 120
         %Odstra�uji analyzovan� sign�ly, kter� kdy� vykresl�m, tak se mi v�bec nel�b� 
         
        %VSKUVKA pokus odstran�n� sign�lu s viditeln�mi arytmiemi  
        %elseif Signal == 6 || Signal == 11 || Signal == 20 || Signal == 23 || Signal == 26 || Signal == 28 || Signal == 34 || Signal == 40 || Signal == 47 || Signal == 54 || Signal == 61 || Signal == 65 || Signal == 74 || Signal == 75 || Signal == 103 || Signal == 105 || Signal == 109 || Signal == 112|| Signal == 115 || Signal == 117 || Signal == 120 || Signal == 122
        %Odstra�uji analyzovan� sign�ly, na kter�ch jsou zn�mky arytmie - je to ale upln� nanic
     
        pom_x=pom_x+1; %O�et�euji prvn� detekci vyhozen�ho sign�lu
        if pom_x == 1 
           if Signal == 1 %O�et�en�, pokud bychom odstra�ovali prvn� sign�l
              pom_poziceEKGvCSE2=[];
           else  %Kdy� odstra�ujeme �patn� sign�l, mus�me odstranit i danou referen�n� hodnotu pro tento sign�l 
               pom_poziceEKGvCSE2=[pom_poziceEKGvCSE2;poziceEKGvCSE2(1:Signal-1,:)];
               pom_pom = Signal+1; %Pomocn� a� se mi ud�l� matice pom_poziceEKG2vCSE2 stejn� velk� jako ta p�vodn�
           end
        else
           pom_poziceEKGvCSE2=[pom_poziceEKGvCSE2;poziceEKGvCSE2(pom_pom:Signal-1,:)];
           pom_pom = Signal+1; 
        end
    else
        Result(pom_Signal,1)=Position_P_onset{Signal}(Beat_heart(Signal)); 
        Result(pom_Signal,2)=Position_P_end{Signal}(Beat_heart(Signal)); %Result je kone�n� v�sledek,  
        Result(pom_Signal,3)=Position_Q{Signal}(Beat_heart(Signal));     %kone�n� detekce ur�it�ho
        Result(pom_Signal,4)=Position_S{Signal}(Beat_heart(Signal));     %srde�n�ho cyklu
        Result(pom_Signal,5)=Position_T{Signal}(Beat_heart(Signal));
        pom_Signal = pom_Signal + 1;
    end
    if Signal == 125 
        pom_poziceEKGvCSE2=[pom_poziceEKGvCSE2;poziceEKGvCSE2(pom_pom:Signal,:)];
    end
    Signal=Signal+1;
end

%Vypo�ten� statick� st�edn� hodnoty, pro vyhodnocen� v�konnosti algoritmu
Mean(1)=mean((Result(:,1)-pom_poziceEKGvCSE2(:,1))*2); %Prom�n� vzorku v �ase 10000/5000
Mean(2)=mean((Result(:,2)-pom_poziceEKGvCSE2(:,2))*2);
Mean(3)=mean((Result(:,3)-pom_poziceEKGvCSE2(:,3))*2);
Mean(4)=mean((Result(:,4)-pom_poziceEKGvCSE2(:,4))*2);
Mean(5)=mean((Result(:,5)-pom_poziceEKGvCSE2(:,5))*2);

%Vypo�ten� statick� sm�rodatn� odchylky, pro vyhodnocen� v�konnosti algoritmu

Standard_deviation(1)=std((Result(:,1)-pom_poziceEKGvCSE2(:,1))*2); %Prom�n� vzorku v �ase 10000/5000
Standard_deviation(2)=std((Result(:,2)-pom_poziceEKGvCSE2(:,2))*2);
Standard_deviation(3)=std((Result(:,3)-pom_poziceEKGvCSE2(:,3))*2);
Standard_deviation(4)=std((Result(:,4)-pom_poziceEKGvCSE2(:,4))*2);
Standard_deviation(5)=std((Result(:,5)-pom_poziceEKGvCSE2(:,5))*2);
 %% Vykreslen� sign�lu

% Pro vykreslen� sign�lu, p�i detekci v jednotliv�ch svodech (bez aplikace
% shlukov� anal�zy) m��ete pou��t skript: 
% Vykresleni_pred_shlukovou_analyzou

% Pro vykreslen� sign�lu, p�i detekci v jednotliv�ch svodech (s pou�it�m 
% slukov� anal�zy) m��ete pou��t skript: 
% Vykreslen�_po_shlukove_analyze
