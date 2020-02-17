clear all; close all; clc;

%% Interpretace algoritmu na rozs�hlej�� data 
% V tomto skriptu aplikujeme vytvo�en� algoritmus pro rozs�hlej�� nam��n� 
% data. Konkr�tn� se jedn� dv� m��en� 50 krok� v r�mci prvn�ho m��en� bez 
% zastaven� a 50 krok� s pauzami, tedy se zastaven�m. 

%% 50 krok� bez zastavov�n� ***********************************************

%Na�ten� dat:
load('x50_1.mat'); 
load('y50_1.mat');
load('z50_1.mat');

%V�po�et celkov�ho pohybu pomoc� Eukliedovsk� vzd�lenosti
r = sqrt(VarName8.^2+VarName9.^2+VarName10.^2);
%Ode�ten� t�hov�ho zrychlen�
r = (r-9.81)';  

okno = 10;    % D�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
              % sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
              % okno je doporu�en� defaultn� volit stejn� jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro v�po�et vlnky/kmit, kter� je 
                              % charakteristick� u konkr�n�ho nam��en�ho 
                              % sign�lu pro jeden krok.

%Funkce pro aplikaci korelace a n�sledn� detekce jednotliv�ch krok�
min_prah = 2;
max_prah = 20;
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2); 

%Vykreslen�
figure
subplot(2,1,1)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',2,'MinPeakHeight',20)
title('Interpretace algoritmu na rozs�hlej�� data - 50 krok�')
hold off
xlabel('Po�et vzork� [-]')
ylabel('Zrychlen� [m/s^(^-^2^)]')

%% 50 krok� se zastavov�n� (s pauzami)*************************************

%Na�ten� dat:
load('x50_2.mat'); 
load('y50_2.mat');
load('z50_2.mat');

%V�po�et celkov�ho pohybu pomoc� Eukliedovsk� vzd�lenosti
r = sqrt(VarName1.^2+VarName6.^2+VarName7.^2);
%Ode�ten� t�hov�ho zrychlen�
r = (r-9.81)';  

okno = 10;    % D�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
              % sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
              % okno je doporu�en� defaultn� volit stejn� jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro v�po�et vlnky/kmit, kter� je 
                              % charakteristick� u konkr�n�ho nam��en�ho 
                              % sign�lu pro jeden krok.

%Funkce pro aplikaci korelace a n�sledn� detekce jednotliv�ch krok�
min_prah = 2;
max_prah = 20;
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2);  

subplot(2,1,2)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',2,'MinPeakHeight',20)
title('Interpretace algoritmu na rozs�hlej�� data - 50 krok� se zastavov�n�m')
hold off
xlabel('Po�et vzork� [-]')
ylabel('Zrychlen� [m/s^(^-^2^)]')
