clear all; close all; clc;

%% Interpretace algoritmu na rozsáhlejší data 
% V tomto skriptu aplikujeme vytvoøený algoritmus pro rozsáhlejší namìøná 
% data. Konkrétnì se jedná dvì mìøení 50 krokù v rámci prvního mìøení bez 
% zastavení a 50 krokù s pauzami, tedy se zastavením. 

%% 50 krokù bez zastavování ***********************************************

%Naètení dat:
load('x50_1.mat'); 
load('y50_1.mat');
load('z50_1.mat');

%Výpoèet celkového pohybu pomocí Eukliedovské vzdálenosti
r = sqrt(VarName8.^2+VarName9.^2+VarName10.^2);
%Odeètené tíhového zrychlení
r = (r-9.81)';  

okno = 10;    % Délka okna, které klouže po signálu, pomocí kterého se 
              % signál po urèitých charakteristických vlnách zprùmìruje
              % okno je doporuèené defaultnì volit stejnì jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro výpoèet vlnky/kmit, který je 
                              % charakteristický u konkréního namìøeného 
                              % signálu pro jeden krok.

%Funkce pro aplikaci korelace a následné detekce jednotlivých krokù
min_prah = 2;
max_prah = 20;
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2); 

%Vykreslení
figure
subplot(2,1,1)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',2,'MinPeakHeight',20)
title('Interpretace algoritmu na rozsáhlejší data - 50 krokù')
hold off
xlabel('Poèet vzorkù [-]')
ylabel('Zrychlení [m/s^(^-^2^)]')

%% 50 krokù se zastavování (s pauzami)*************************************

%Naètení dat:
load('x50_2.mat'); 
load('y50_2.mat');
load('z50_2.mat');

%Výpoèet celkového pohybu pomocí Eukliedovské vzdálenosti
r = sqrt(VarName1.^2+VarName6.^2+VarName7.^2);
%Odeètené tíhového zrychlení
r = (r-9.81)';  

okno = 10;    % Délka okna, které klouže po signálu, pomocí kterého se 
              % signál po urèitých charakteristických vlnách zprùmìruje
              % okno je doporuèené defaultnì volit stejnì jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro výpoèet vlnky/kmit, který je 
                              % charakteristický u konkréního namìøeného 
                              % signálu pro jeden krok.

%Funkce pro aplikaci korelace a následné detekce jednotlivých krokù
min_prah = 2;
max_prah = 20;
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2);  

subplot(2,1,2)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',2,'MinPeakHeight',20)
title('Interpretace algoritmu na rozsáhlejší data - 50 krokù se zastavováním')
hold off
xlabel('Poèet vzorkù [-]')
ylabel('Zrychlení [m/s^(^-^2^)]')
