clear all; close all; clc;

%% Projekt è. 10: Poèítání krokù pomocí pøizpùsobené filtrace    2.12. 2018
%__________________________________________________________________________
% Analýza a interpretace biologických dat [MABD] 

%Zadání:
% Pomocí akcelerometru chytrého telefonu s aplikací Sense-it nasnímejte 
% 5 signálù chùze a zaznamenejte si referenci (ruènì spoèítané kroky). 
% Detekujte kroky s využitím pøizpùsobené filtrace a spoèítejte je (automaticky). 
% Porovnejte pøesnost vašeho stanovení poètu krokù s referencí.

%AUTOØI: Veronika Pošustová, Jana Schwarzerová
%__________________________________________________________________________
%Mobil v ruce *************************************************************

kroky_man_1 = 20; %Manuálnì spoèítané kroky pro 1. signál
kroky_man = 10;   %Manuálnì spoèítané kroky pro 2.-5. signál

for i = 1:4  %Celkovì jsme namìøili v první fázi 4 signály
             %První signál - 20 krokù
             %Druhý až ètvrtý signál - 10 krokù 
load(['x',num2str(i),'.mat']);  
load(['y',num2str(i),'.mat']);
load(['z',num2str(i),'.mat']);  

%Výpoèet celkového pohybu pomocí Eukliedovské vzdálenosti
if i == 1 
r = sqrt(VarName3.^2+VarName4.^2+VarName5.^2);
else
r = sqrt(VarName3(3:end).^2+VarName4(3:end).^2+VarName5(3:end).^2);
end

%Odeètené tíhového zrychlení
r = (r-9.81)';

%Bez použití pøizpùsobené filtrace (jen pro ilustraci)
[P,pozice] = findpeaks(r,'MinPeakDistance',5,'MinPeakHeight',2);
pocet_kroku(i) = length(P);

figure (i+1)
subplot(2,1,1)
plot(r)
hold on
findpeaks(r,'MinPeakDistance',5,'MinPeakHeight',2)
title(['Metoda findpeaks pro ',num2str(i),'. signál'])
hold off
xlabel('Poèet vzorkù [-]')
ylabel('zrychlení [m/s^(^-^2^)]')

okno = 10;    % Délka okna, které klouže po signálu, pomocí kterého se 
              % signál po urèitých charakteristických vlnách zprùmìruje
              % okno je doporuèené defaultnì volit stejnì jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro výpoèet vlnky/kmit, který je 
                              % charakteristický u konkréního namìøeného 
                              % signálu pro jeden krok.

                              
%Prahování pro konkrétní signály pro správné detekce krokù, nastavováno
%empiricky
if i == 4
min_prah = 4;
max_prah = 10;
else
min_prah = 5;
max_prah = 10;
end
%Funkce pro aplikaci korelace a následné detekce jednotlivých krokù
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace(i) = length(P2); 

% Vykreslení vzorové referenèní vlnky pro 3. signál
if i == 3
figure(1)
plot(ref_x)
title('Pøíklad referenèní vlnky')
xlabel('Vzorky [-]')
ylabel('Zrychlení [m/s^(^-^2^)]')
end

%Vykreslení
figure(i+1)
subplot(2,1,2)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title(['Metoda pøizpùsobené filtrace pro ',num2str(i),'. signál'])
hold off
xlabel('Poèet vzorkù [-]')
ylabel('Zrychlení [m/s^(^-^2^)]')

end

% STATISTICKÉ VYHODNOCENÍ .................................................

Vyhodnoceni = zeros(4,5);
Vyhodnoceni(1,1:end) = 1:5;

    % Úspìšnost bez filtrace pouze pro 1. signál: (èistì pro ilustraci)
    uspesnost_ref = (pocet_kroku(1)/kroky_man_1)*100;
    Vyhodnoceni(2,1) = kroky_man_1;
    Vyhodnoceni(3,1) = pocet_kroku(1);
    Vyhodnoceni(4,1) = uspesnost_ref;
   % Úspìšnost s pøizpùsobenou filtrací:
    uspesnost = (kroky_filtrace(1)/kroky_man_1)*100;  %1. signál
    Vyhodnoceni(2,2) = kroky_man_1;
    Vyhodnoceni(3,2) = kroky_filtrace(1);
    Vyhodnoceni(4,2) = uspesnost;
    uspesnost = (kroky_filtrace(2)/kroky_man)*100;    %2. signál
    Vyhodnoceni(2,3) = kroky_man;
    Vyhodnoceni(3,3) = kroky_filtrace(2);
    Vyhodnoceni(4,3) = uspesnost;
    uspesnost = (kroky_filtrace(3)/kroky_man)*100;    %3. signál
    Vyhodnoceni(2,4) = kroky_man;
    Vyhodnoceni(3,4) = kroky_filtrace(3);
    Vyhodnoceni(4,4) = uspesnost;
    uspesnost = (kroky_filtrace(4)/kroky_man)*100;    %4. signál
    Vyhodnoceni(2,5) = kroky_man;
    Vyhodnoceni(3,5) = kroky_filtrace(4);
    Vyhodnoceni(4,5) = uspesnost;
  
disp('Tabulka pro statistické vyhodnocení pro mìøení v ruce:');
disp(Vyhodnoceni);

% _________________________________________________________________________
% Mobil v kapse ***********************************************************

kroky_man_7 = 10; %Manuálnì spoèítané kroky

%Naètení konkrétního signálu

for i = 5:8  %Celkovì jsme namìøili v druhé fázi 4 signály
             %Všechny signály byly pro 10 krokù
             
load(['x',num2str(i),'.mat']);  
load(['y',num2str(i),'.mat']);
load(['z',num2str(i),'.mat']);  

%Výpoèet celkového pohybu pomocí Eukliedovské vzdálenosti aplikovaný 
%pro konkrétní signály 
if i == 8
   r = sqrt(VarName9.^2+VarName10.^2+VarName11.^2);
elseif i == 7
    r = sqrt(VarName6.^2+VarName7.^2+VarName8.^2);
else
r = sqrt(VarName3.^2+VarName4.^2+VarName5.^2);
end

%Odeètené tíhového zrychlení
r = (r-9.81)';

okno = 10;    % Délka okna, které klouže po signálu, pomocí kterého se 
              % signál po urèitých charakteristických vlnách zprùmìruje
              % okno je doporuèené defaultnì volit stejnì jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro výpoèet vlnky/kmit, který je 
                              % charakteristický u konkréního namìøeného 
                              % signálu pro jeden krok.

%Prahování pro konkrétní signály pro správné detekce krokù, nastavováno
%empiricky
if i == 5
min_prah = 2; 
max_prah = 8;
else 
min_prah = 2;
max_prah = 15;
end
%Funkce pro aplikaci korelace a následné detekce jednotlivých krokù
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace(i) = length(P2); 

%Vykreslení
figure(i+1)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title(['Metoda pøizpùsobené filtrace pro ',num2str(i),'. signál'])
hold off
xlabel('Poèet vzorkù [-]')
ylabel('Zrychlení [m/s^(^-^2^)]')

end

% STATISTICKÉ VYHODNOCENÍ .................................................

Vyhodnoceni_kapsa = zeros(4,4);
Vyhodnoceni_kapsa(1,1:end) = 1:4;
Vyhodnoceni_kapsa(2,:) = kroky_man_7;

    % Úspìšnost s pøizpùsobenou filtrací:
    uspesnost = (kroky_filtrace(5)/kroky_man_7)*100;       %5. signál
    Vyhodnoceni_kapsa(2,1) = kroky_man_7;
    Vyhodnoceni_kapsa(3,1) = kroky_filtrace(5);
    Vyhodnoceni_kapsa(4,1) = uspesnost;
    uspesnost = (kroky_filtrace(6)/kroky_man_7)*100;    %6. signál
    Vyhodnoceni_kapsa(2,2) = kroky_man_7;
    Vyhodnoceni_kapsa(3,2) = kroky_filtrace(6);
    Vyhodnoceni_kapsa(4,2) = uspesnost;
    uspesnost = (kroky_filtrace(7)/kroky_man_7)*100;    %7. signál
    Vyhodnoceni_kapsa(2,3) = kroky_man_7;
    Vyhodnoceni_kapsa(3,3) = kroky_filtrace(7);
    Vyhodnoceni_kapsa(4,3) = uspesnost;
    uspesnost = (kroky_filtrace(8)/kroky_man_7)*100;    %8. signál
    Vyhodnoceni_kapsa(2,4) = kroky_man_7;
    Vyhodnoceni_kapsa(3,4) = kroky_filtrace(8);
    Vyhodnoceni_kapsa(4,4) = uspesnost;

  
disp('Tabulka pro statistické vyhodnocení pro mìøení v kapse:');
disp(Vyhodnoceni_kapsa);


%% ************************************************************************
%_________________Srovnání mobil v ruce/mobil v kapse______________________

% 4. signál - 10 krokù, mobil v ruce **************************************

%Naètení:
load('x4.mat'); 
load('y4.mat');
load('z4.mat');
%Výpoèet celkového pohybu pomocí Eukliedovské vzdálenosti
r = sqrt(VarName3(3:end).^2+VarName4(3:end).^2+VarName5(3:end).^2);
%Odeètené tíhového zrychlení
r = (r-9.81)';
okno = 10;    % Délka okna, které klouže po signálu, pomocí kterého se 
              % signál po urèitých charakteristických vlnách zprùmìruje
              % okno je doporuèené defaultnì volit stejnì jako fvz              
[ref_x] = jeden_krok(r,okno); % Funkce pro výpoèet vlnky/kmit, který je 
                              % charakteristický u konkréního namìøeného 
                              % signálu pro jeden krok.                             
%Prahování pro konkrétní signály pro správné detekce krokù, nastavováno
%empiricky
min_prah = 4;
max_prah = 10;
%Funkce pro aplikaci korelace a následné detekce jednotlivých krokù
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2);

%Vykreslení
figure
subplot(2,1,1)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title('Mìøení s mobilem v ruce')
hold off
xlabel('Poèet vzorkù [-]')
ylabel('Zrychlení [m/s^(^-^2^)]')

% 8. signál - 10 krokù, mobil v kapse *************************************

%Naètení:
load('x8.mat'); 
load('y8.mat');
load('z8.mat');
%Výpoèet celkového pohybu pomocí Eukliedovské vzdálenosti
r = sqrt(VarName6.^2+VarName7.^2+VarName8.^2);
%Odeètené tíhového zrychlení
r = (r-9.81)';
okno = 10;    % Délka okna, které klouže po signálu, pomocí kterého se 
              % signál po urèitých charakteristických vlnách zprùmìruje
              % okno je doporuèené defaultnì volit stejnì jako fvz              
[ref_x] = jeden_krok(r,okno); % Funkce pro výpoèet vlnky/kmit, který je 
                              % charakteristický u konkréního namìøeného 
                              % signálu pro jeden krok.                             
%Prahování pro konkrétní signály pro správné detekce krokù, nastavováno
%empiricky
min_prah = 2;
max_prah = 15;
%Funkce pro aplikaci korelace a následné detekce jednotlivých krokù
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2);

%Dokreslení
subplot(2,1,2)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title('Mìøení s mobilem v kapse')
hold off
xlabel('Poèet vzorkù [-]')
ylabel('zrychlení m/s^(^-^2^)')
