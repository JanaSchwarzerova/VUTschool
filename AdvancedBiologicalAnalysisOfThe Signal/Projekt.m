clear all; close all; clc; 
%% FACS PROJEKT �. 12                                           9.12. 2018
%                          FILTRACE S VYU�IT�M SWT 
%                                                       verze: Matlab2018a
% Zad�n� *****************************************************************
% Popis: Wienerovsk� vlnkov� filtr s pilotn�m odhadem. 
%        Pro filtraci pou�ijte redundantn� dyadickou DTWT  
%        (pou�ijte funkci �swt�) a wienerovsk� vlnkov� filtr 
%        s pilotn�m odhadem u�ite�n�ho sign�lu. 
%
% Data: Sign�l EKG �. W059f a myopotenci�lov� ru�en� MYO.
% Autor: Jana Schwarzerov�

%Na�ten� sign�lu:
load('signal.mat') 
s = W059f; %Vybr�n� sign�lu EKG �. W059f
w = MYO;   %Myopotenci�lov� ru�en� MYO

s = s(1:4992);
w = w(1:4992);

%Nastaveni SNR:
SNR_dB_in = 15; 
SNR = 10^(SNR_dB_in/10);
w = w * sqrt(sum(s.^2)/(sum(w.^2)*SNR));
SNR_dB_in = 10*log10(sum(s.^2)/sum(w.^2));

vstup = s + w; %p�i�ten� �umu
%Vykreslen� za�um�l�ho sign�lu a sign�lu bez �umu pro vykreslen� po 
%aplikaci prahov�n�:
figure(1)
plot( vstup, 'g' ) % s p�i�ten�m �umu
hold on
plot( s, 'b' ) % bez sumu
xlabel('t [s]')
ylabel('u [\muV]')

%Vykreslen� za�um�l�ho sign�lu a sign�lu bez �umu pro vykreslen� po 
%aplikaci Wienerovsk� vlnkov� filtr s pilotn�m odhadem:
figure(2)
plot( vstup, 'g' ) % s prictenim sumu
hold on
plot( s, 'b' ) % bez sumu
xlabel('t [s]')
ylabel('u [\muV]')


%% BLOK WT1 - aplikace DTWT ***********************************************

% Mo�n� p��klady, pou�it�ch vlnek:
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

wname_1 = 'coif1';   %Typ pou�it� vlnky pro prvn� pou�itou DTWT 
N_1 = 4;             %Stupe� rozkladu pro prvn� pou�itou DTWT 

SWC =swt(vstup,N_1,wname_1); %Rozklad DTWT

%Vykreslen� rozkladu po bloku WT1
figure (3) 
for i = 1:N_1+1
    subplot (N_1+1,1,i);
    plot(SWC(i,:), 'b')
    title(['Rozkladov� p�smo ' num2str(i)])
    hold on
end
title('Zbytek')
hold off

%% BLOK H *****************************************************************
% Blok H p�edstavuje prahov�n� hodnot

% Doporu�en� podle souboru p�edn�ek od 
% doc. Kozumpl�ka -> M�kk� prahov�n� s vy���m prahem

%Mo�nost vybr�n� podle v�ce parametr�:
K = 3.8;              %Pomocn� konstanta pro v�po�et empirick�ho prahu
prah_1 = 'Median';    %Median pro v�po�et prahu pomoc� medi�nu,
                      %dal�� mo�nost 'Std' pro v�po�et prahu pomoc�
                      %sm�rodatn� odchylky
prah_2 = 'E';         % 'E' v�po�et empirick�ho prahu
                      % nebo 'U' v�po�et univerz�ln�ho prahu
pom = 'G'; %pom zna�� jak� typ prahov�n� chceme pou��t:
              % 'G' prahov�n� Garrote
              % 'M' m�kk� prahov�n�
              % 'T' tvrd� prahov�n�

[SWC] = Prahovani(SWC,N_1,K,prah_1,prah_2,pom);

%% BLOK IWT1 - Zp�tn� transformace

p_s = iswt(SWC, wname_1); %Odhad

%V�po�et SNR ------------------------------------(�ist� jen pro ilustraci) 

% vykresleni
figure(1)
plot( p_s, 'r' ) % pilotn� odhad u�ite�n�ho sign�lu
legend('Za�um�n�','Origin�ln�','Pilotn� odhad u�ite�n�ho sign�lu')
chyba = p_s - s;
SNR_dB_out = 10*log10(sum(s.^2)/sum(chyba.^2));
title(['SNR: in = ' num2str(SNR_dB_in) ' dB , out = ' num2str(SNR_dB_out) ' dB'])
%__________________________________________________________________________

%% BLOK WT2 - aplikace DTWT ***********************************************

% Mo�n� p��klady, pou�it�ch vlnek:
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

wname_2 ='bior1.5'; %Typ pou�it� vlnky pro druh� pou�� DTWT 
N_2 = 3;            %Stupe� rozkladu pro druh� pou�� DTWT 

% APLIKACE PRO PILOTN� ODHAD U�ITE�N�HO SIGN�LU
SWC_2_ps =swt(p_s,N_2,wname_2); %Rozklad 

%Vykreslen�
figure (4) 
for i = 1:N_2+1
    subplot (N_2+1,1,i);
    plot(SWC_2_ps(i,:), 'b')
    title(['Rozkladov� p�smo ' num2str(i)])
    hold on
end
title('Zbytek')
hold off

% APLIKACE PRO VSTUPN� SIGN�L
SWC_2_ym =swt(vstup,N_2,wname_2); %Rozklad 

%Vykreslen�
figure (5) 
for i = 1:N_2+1
    subplot (N_2+1,1,i);
    plot(SWC_2_ym(i,:), 'b')
    title(['Rozkladov� p�smo ' num2str(i)])
    hold on
end
title('Zbytek')
hold off

%% BLOK HW - N�soben� korela�n�mi �leny ***********************************

for m = 1:N_2 %Pro ka�d� rozlo�en� p�smo 
sigma = std(SWC_2_ym(m,:)); %V�po�et rozptylu
w_ym(m,:) = SWC_2_ym(m,:).*(((SWC_2_ps(m,:)).^(2))./((SWC_2_ps(m,:).^(2))+(sigma^(2))));
end

w_ym(m+1,:) = SWC_2_ym(m+1,:);

%% BLOK IWT2 - Zp�tn� transformace

vystup = iswt(w_ym, wname_2); %Odhad

%V�po�et SNR --------------------------------------------------------------
% vykresleni
figure (2)
plot( vystup, 'r' ) % pilotn� odhad u�ite�n�ho sign�lu
legend('Za�um�n�','Origin�ln�','V�stupn� filtrovan� sign�l')

chyba_vystup = vystup - s;
SNR_dB_out_2 = 10*log10(sum(s.^2)/sum(chyba_vystup.^2));
title(['SNR: in = ' num2str(SNR_dB_in) ' dB , out = ' num2str(SNR_dB_out_2) ' dB'])






