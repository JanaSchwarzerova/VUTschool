function [vystup] = Wiener_filtr_s_pilot(vstup)
% Funkce Wiener_filtr_s_pilot má stejné vlastnosti jako skript Projekt.m, 
% kromì poèítání SNR 
% vstupem je:  vstup  ... zašumìlý signál
% výstupem je: vystup ... vyfiltrovaný signál 

vstup = [vstup vstup(end)*ones(1,8)]; %Pøedzpracování potøebuné pro stupeò 
                                      %rozkladu 4 (který pro optimalizaci 
                                      %algoritmu vycházel nejlépe)

%% BLOK WT1 - aplikace DTWT ***********************************************
wname_1 = 'coif1';   %Typ použité vlnky pro první použitou DTWT 
N_1 = 4;             %Stupeò rozkladu pro první použitou DTWT 
SWC =swt(vstup,N_1,wname_1); %Rozklad DTWT

%% BLOK H *****************************************************************
%Možnost vybrání podle více parametrù:
K = 3.8;              %Pomocná konstanta pro výpoèet empirického prahu
prah_1 = 'Median';    %Median pro výpoèet prahu pomocí mediánu,
                      %další možnost 'Std' pro výpoèet prahu pomocí
                      %smìrodatné odchylky
prah_2 = 'E';         % 'E' výpoèet empirického prahu
                      % nebo 'U' výpoèet univerzálního prahu
pom = 'G'; %pom znaèí jaký typ prahování chceme použít:
              % 'G' prahování Garrote
              % 'M' mìkké prahování
              % 'T' tvrdé prahování
[SWC] = Prahovani(SWC,N_1,K,prah_1,prah_2,pom);

%% BLOK IWT1 - Zpìtná transformace
p_s = iswt(SWC, wname_1); %Odhad

%% BLOK WT2 - aplikace DTWT ***********************************************
wname_2 ='bior1.5'; %Typ použité vlnky pro druhé použí DTWT 
N_2 = 3;         %Stupeò rozkladu pro druhé použí DTWT 
% APLIKACE PRO PILOTNÍ ODHAD UŽITEÈNÉHO SIGNÁLU
SWC_2_ps =swt(p_s,N_2,wname_2); %Rozklad 
% APLIKACE PRO VSTUPNÍ SIGNÁL
SWC_2_ym =swt(vstup,N_2,wname_2); %Rozklad 

%% BLOK HW - Násobení korelaèními èleny ***********************************

for m = 1:N_2 %Pro každé rozložené pásmo 
sigma = std(SWC_2_ym(m,:)); %Výpoèet rozptylu
w_ym(m,:) = SWC_2_ym(m,:).*(((SWC_2_ps(m,:)).^(2))./((SWC_2_ps(m,:).^(2))+(sigma^(2))));
end
w_ym(m+1,:) = SWC_2_ym(m+1,:);

%% BLOK IWT2 - Zpìtná transformace
vystup = iswt(w_ym, wname_2); %Odhad
vystup = vystup(1:5000);

end
