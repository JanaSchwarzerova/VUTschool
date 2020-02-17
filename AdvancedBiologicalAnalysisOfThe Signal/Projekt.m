clear all; close all; clc; 
%% FACS PROJEKT è. 12                                           9.12. 2018
%                          FILTRACE S VYUŽITÍM SWT 
%                                                       verze: Matlab2018a
% Zadání *****************************************************************
% Popis: Wienerovský vlnkový filtr s pilotním odhadem. 
%        Pro filtraci použijte redundantní dyadickou DTWT  
%        (použijte funkci „swt“) a wienerovský vlnkový filtr 
%        s pilotním odhadem užiteèného signálu. 
%
% Data: Signál EKG è. W059f a myopotenciálové rušení MYO.
% Autor: Jana Schwarzerová

%Naètení signálu:
load('signal.mat') 
s = W059f; %Vybrání signálu EKG è. W059f
w = MYO;   %Myopotenciálové rušení MYO

s = s(1:4992);
w = w(1:4992);

%Nastaveni SNR:
SNR_dB_in = 15; 
SNR = 10^(SNR_dB_in/10);
w = w * sqrt(sum(s.^2)/(sum(w.^2)*SNR));
SNR_dB_in = 10*log10(sum(s.^2)/sum(w.^2));

vstup = s + w; %pøiètení šumu
%Vykreslení zašumìlého signálu a signálu bez šumu pro vykreslení po 
%aplikaci prahování:
figure(1)
plot( vstup, 'g' ) % s pøiètením šumu
hold on
plot( s, 'b' ) % bez sumu
xlabel('t [s]')
ylabel('u [\muV]')

%Vykreslení zašumìlého signálu a signálu bez šumu pro vykreslení po 
%aplikaci Wienerovský vlnkový filtr s pilotním odhadem:
figure(2)
plot( vstup, 'g' ) % s prictenim sumu
hold on
plot( s, 'b' ) % bez sumu
xlabel('t [s]')
ylabel('u [\muV]')


%% BLOK WT1 - aplikace DTWT ***********************************************

% Možné pøíklady, použitých vlnek:
% 'db1' / 'haar', 'db2', 'db3' ... 'db45'
% 'coif1', ..., 'coif5'
% 'sym2', ..., 'sym8', ...,'sym45'
% 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'
% 'dmey'
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'

wname_1 = 'coif1';   %Typ použité vlnky pro první použitou DTWT 
N_1 = 4;             %Stupeò rozkladu pro první použitou DTWT 

SWC =swt(vstup,N_1,wname_1); %Rozklad DTWT

%Vykreslení rozkladu po bloku WT1
figure (3) 
for i = 1:N_1+1
    subplot (N_1+1,1,i);
    plot(SWC(i,:), 'b')
    title(['Rozkladové pásmo ' num2str(i)])
    hold on
end
title('Zbytek')
hold off

%% BLOK H *****************************************************************
% Blok H pøedstavuje prahování hodnot

% Doporuèené podle souboru pøednášek od 
% doc. Kozumplíka -> Mìkké prahování s vyšším prahem

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

%Výpoèet SNR ------------------------------------(èistì jen pro ilustraci) 

% vykresleni
figure(1)
plot( p_s, 'r' ) % pilotní odhad užiteèného signálu
legend('Zašumìný','Originální','Pilotní odhad užiteèného signálu')
chyba = p_s - s;
SNR_dB_out = 10*log10(sum(s.^2)/sum(chyba.^2));
title(['SNR: in = ' num2str(SNR_dB_in) ' dB , out = ' num2str(SNR_dB_out) ' dB'])
%__________________________________________________________________________

%% BLOK WT2 - aplikace DTWT ***********************************************

% Možné pøíklady, použitých vlnek:
% 'db1' / 'haar', 'db2', 'db3' ... 'db45'
% 'coif1', ..., 'coif5'
% 'sym2', ..., 'sym8', ...,'sym45'
% 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'
% 'dmey'
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'

wname_2 ='bior1.5'; %Typ použité vlnky pro druhé použí DTWT 
N_2 = 3;            %Stupeò rozkladu pro druhé použí DTWT 

% APLIKACE PRO PILOTNÍ ODHAD UŽITEÈNÉHO SIGNÁLU
SWC_2_ps =swt(p_s,N_2,wname_2); %Rozklad 

%Vykreslení
figure (4) 
for i = 1:N_2+1
    subplot (N_2+1,1,i);
    plot(SWC_2_ps(i,:), 'b')
    title(['Rozkladové pásmo ' num2str(i)])
    hold on
end
title('Zbytek')
hold off

% APLIKACE PRO VSTUPNÍ SIGNÁL
SWC_2_ym =swt(vstup,N_2,wname_2); %Rozklad 

%Vykreslení
figure (5) 
for i = 1:N_2+1
    subplot (N_2+1,1,i);
    plot(SWC_2_ym(i,:), 'b')
    title(['Rozkladové pásmo ' num2str(i)])
    hold on
end
title('Zbytek')
hold off

%% BLOK HW - Násobení korelaèními èleny ***********************************

for m = 1:N_2 %Pro každé rozložené pásmo 
sigma = std(SWC_2_ym(m,:)); %Výpoèet rozptylu
w_ym(m,:) = SWC_2_ym(m,:).*(((SWC_2_ps(m,:)).^(2))./((SWC_2_ps(m,:).^(2))+(sigma^(2))));
end

w_ym(m+1,:) = SWC_2_ym(m+1,:);

%% BLOK IWT2 - Zpìtná transformace

vystup = iswt(w_ym, wname_2); %Odhad

%Výpoèet SNR --------------------------------------------------------------
% vykresleni
figure (2)
plot( vystup, 'r' ) % pilotní odhad užiteèného signálu
legend('Zašumìný','Originální','Výstupní filtrovaný signál')

chyba_vystup = vystup - s;
SNR_dB_out_2 = 10*log10(sum(s.^2)/sum(chyba_vystup.^2));
title(['SNR: in = ' num2str(SNR_dB_in) ' dB , out = ' num2str(SNR_dB_out_2) ' dB'])






