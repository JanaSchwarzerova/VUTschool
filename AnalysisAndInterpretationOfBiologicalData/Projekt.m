clear all; close all; clc;

%% Projekt �. 10: Po��t�n� krok� pomoc� p�izp�soben� filtrace    2.12. 2018
%__________________________________________________________________________
% Anal�za a interpretace biologick�ch dat [MABD] 

%Zad�n�:
% Pomoc� akcelerometru chytr�ho telefonu s aplikac� Sense-it nasn�mejte 
% 5 sign�l� ch�ze a zaznamenejte si referenci (ru�n� spo��tan� kroky). 
% Detekujte kroky s vyu�it�m p�izp�soben� filtrace a spo��tejte je (automaticky). 
% Porovnejte p�esnost va�eho stanoven� po�tu krok� s referenc�.

%AUTO�I: Veronika Po�ustov�, Jana Schwarzerov�
%__________________________________________________________________________
%Mobil v ruce *************************************************************

kroky_man_1 = 20; %Manu�ln� spo��tan� kroky pro 1. sign�l
kroky_man = 10;   %Manu�ln� spo��tan� kroky pro 2.-5. sign�l

for i = 1:4  %Celkov� jsme nam��ili v prvn� f�zi 4 sign�ly
             %Prvn� sign�l - 20 krok�
             %Druh� a� �tvrt� sign�l - 10 krok� 
load(['x',num2str(i),'.mat']);  
load(['y',num2str(i),'.mat']);
load(['z',num2str(i),'.mat']);  

%V�po�et celkov�ho pohybu pomoc� Eukliedovsk� vzd�lenosti
if i == 1 
r = sqrt(VarName3.^2+VarName4.^2+VarName5.^2);
else
r = sqrt(VarName3(3:end).^2+VarName4(3:end).^2+VarName5(3:end).^2);
end

%Ode�ten� t�hov�ho zrychlen�
r = (r-9.81)';

%Bez pou�it� p�izp�soben� filtrace (jen pro ilustraci)
[P,pozice] = findpeaks(r,'MinPeakDistance',5,'MinPeakHeight',2);
pocet_kroku(i) = length(P);

figure (i+1)
subplot(2,1,1)
plot(r)
hold on
findpeaks(r,'MinPeakDistance',5,'MinPeakHeight',2)
title(['Metoda findpeaks pro ',num2str(i),'. sign�l'])
hold off
xlabel('Po�et vzork� [-]')
ylabel('zrychlen� [m/s^(^-^2^)]')

okno = 10;    % D�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
              % sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
              % okno je doporu�en� defaultn� volit stejn� jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro v�po�et vlnky/kmit, kter� je 
                              % charakteristick� u konkr�n�ho nam��en�ho 
                              % sign�lu pro jeden krok.

                              
%Prahov�n� pro konkr�tn� sign�ly pro spr�vn� detekce krok�, nastavov�no
%empiricky
if i == 4
min_prah = 4;
max_prah = 10;
else
min_prah = 5;
max_prah = 10;
end
%Funkce pro aplikaci korelace a n�sledn� detekce jednotliv�ch krok�
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace(i) = length(P2); 

% Vykreslen� vzorov� referen�n� vlnky pro 3. sign�l
if i == 3
figure(1)
plot(ref_x)
title('P��klad referen�n� vlnky')
xlabel('Vzorky [-]')
ylabel('Zrychlen� [m/s^(^-^2^)]')
end

%Vykreslen�
figure(i+1)
subplot(2,1,2)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title(['Metoda p�izp�soben� filtrace pro ',num2str(i),'. sign�l'])
hold off
xlabel('Po�et vzork� [-]')
ylabel('Zrychlen� [m/s^(^-^2^)]')

end

% STATISTICK� VYHODNOCEN� .................................................

Vyhodnoceni = zeros(4,5);
Vyhodnoceni(1,1:end) = 1:5;

    % �sp�nost bez filtrace pouze pro 1. sign�l: (�ist� pro ilustraci)
    uspesnost_ref = (pocet_kroku(1)/kroky_man_1)*100;
    Vyhodnoceni(2,1) = kroky_man_1;
    Vyhodnoceni(3,1) = pocet_kroku(1);
    Vyhodnoceni(4,1) = uspesnost_ref;
   % �sp�nost s p�izp�sobenou filtrac�:
    uspesnost = (kroky_filtrace(1)/kroky_man_1)*100;  %1. sign�l
    Vyhodnoceni(2,2) = kroky_man_1;
    Vyhodnoceni(3,2) = kroky_filtrace(1);
    Vyhodnoceni(4,2) = uspesnost;
    uspesnost = (kroky_filtrace(2)/kroky_man)*100;    %2. sign�l
    Vyhodnoceni(2,3) = kroky_man;
    Vyhodnoceni(3,3) = kroky_filtrace(2);
    Vyhodnoceni(4,3) = uspesnost;
    uspesnost = (kroky_filtrace(3)/kroky_man)*100;    %3. sign�l
    Vyhodnoceni(2,4) = kroky_man;
    Vyhodnoceni(3,4) = kroky_filtrace(3);
    Vyhodnoceni(4,4) = uspesnost;
    uspesnost = (kroky_filtrace(4)/kroky_man)*100;    %4. sign�l
    Vyhodnoceni(2,5) = kroky_man;
    Vyhodnoceni(3,5) = kroky_filtrace(4);
    Vyhodnoceni(4,5) = uspesnost;
  
disp('Tabulka pro statistick� vyhodnocen� pro m��en� v ruce:');
disp(Vyhodnoceni);

% _________________________________________________________________________
% Mobil v kapse ***********************************************************

kroky_man_7 = 10; %Manu�ln� spo��tan� kroky

%Na�ten� konkr�tn�ho sign�lu

for i = 5:8  %Celkov� jsme nam��ili v druh� f�zi 4 sign�ly
             %V�echny sign�ly byly pro 10 krok�
             
load(['x',num2str(i),'.mat']);  
load(['y',num2str(i),'.mat']);
load(['z',num2str(i),'.mat']);  

%V�po�et celkov�ho pohybu pomoc� Eukliedovsk� vzd�lenosti aplikovan� 
%pro konkr�tn� sign�ly 
if i == 8
   r = sqrt(VarName9.^2+VarName10.^2+VarName11.^2);
elseif i == 7
    r = sqrt(VarName6.^2+VarName7.^2+VarName8.^2);
else
r = sqrt(VarName3.^2+VarName4.^2+VarName5.^2);
end

%Ode�ten� t�hov�ho zrychlen�
r = (r-9.81)';

okno = 10;    % D�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
              % sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
              % okno je doporu�en� defaultn� volit stejn� jako fvz
              
[ref_x] = jeden_krok(r,okno); % Funkce pro v�po�et vlnky/kmit, kter� je 
                              % charakteristick� u konkr�n�ho nam��en�ho 
                              % sign�lu pro jeden krok.

%Prahov�n� pro konkr�tn� sign�ly pro spr�vn� detekce krok�, nastavov�no
%empiricky
if i == 5
min_prah = 2; 
max_prah = 8;
else 
min_prah = 2;
max_prah = 15;
end
%Funkce pro aplikaci korelace a n�sledn� detekce jednotliv�ch krok�
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace(i) = length(P2); 

%Vykreslen�
figure(i+1)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title(['Metoda p�izp�soben� filtrace pro ',num2str(i),'. sign�l'])
hold off
xlabel('Po�et vzork� [-]')
ylabel('Zrychlen� [m/s^(^-^2^)]')

end

% STATISTICK� VYHODNOCEN� .................................................

Vyhodnoceni_kapsa = zeros(4,4);
Vyhodnoceni_kapsa(1,1:end) = 1:4;
Vyhodnoceni_kapsa(2,:) = kroky_man_7;

    % �sp�nost s p�izp�sobenou filtrac�:
    uspesnost = (kroky_filtrace(5)/kroky_man_7)*100;       %5. sign�l
    Vyhodnoceni_kapsa(2,1) = kroky_man_7;
    Vyhodnoceni_kapsa(3,1) = kroky_filtrace(5);
    Vyhodnoceni_kapsa(4,1) = uspesnost;
    uspesnost = (kroky_filtrace(6)/kroky_man_7)*100;    %6. sign�l
    Vyhodnoceni_kapsa(2,2) = kroky_man_7;
    Vyhodnoceni_kapsa(3,2) = kroky_filtrace(6);
    Vyhodnoceni_kapsa(4,2) = uspesnost;
    uspesnost = (kroky_filtrace(7)/kroky_man_7)*100;    %7. sign�l
    Vyhodnoceni_kapsa(2,3) = kroky_man_7;
    Vyhodnoceni_kapsa(3,3) = kroky_filtrace(7);
    Vyhodnoceni_kapsa(4,3) = uspesnost;
    uspesnost = (kroky_filtrace(8)/kroky_man_7)*100;    %8. sign�l
    Vyhodnoceni_kapsa(2,4) = kroky_man_7;
    Vyhodnoceni_kapsa(3,4) = kroky_filtrace(8);
    Vyhodnoceni_kapsa(4,4) = uspesnost;

  
disp('Tabulka pro statistick� vyhodnocen� pro m��en� v kapse:');
disp(Vyhodnoceni_kapsa);


%% ************************************************************************
%_________________Srovn�n� mobil v ruce/mobil v kapse______________________

% 4. sign�l - 10 krok�, mobil v ruce **************************************

%Na�ten�:
load('x4.mat'); 
load('y4.mat');
load('z4.mat');
%V�po�et celkov�ho pohybu pomoc� Eukliedovsk� vzd�lenosti
r = sqrt(VarName3(3:end).^2+VarName4(3:end).^2+VarName5(3:end).^2);
%Ode�ten� t�hov�ho zrychlen�
r = (r-9.81)';
okno = 10;    % D�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
              % sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
              % okno je doporu�en� defaultn� volit stejn� jako fvz              
[ref_x] = jeden_krok(r,okno); % Funkce pro v�po�et vlnky/kmit, kter� je 
                              % charakteristick� u konkr�n�ho nam��en�ho 
                              % sign�lu pro jeden krok.                             
%Prahov�n� pro konkr�tn� sign�ly pro spr�vn� detekce krok�, nastavov�no
%empiricky
min_prah = 4;
max_prah = 10;
%Funkce pro aplikaci korelace a n�sledn� detekce jednotliv�ch krok�
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2);

%Vykreslen�
figure
subplot(2,1,1)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title('M��en� s mobilem v ruce')
hold off
xlabel('Po�et vzork� [-]')
ylabel('Zrychlen� [m/s^(^-^2^)]')

% 8. sign�l - 10 krok�, mobil v kapse *************************************

%Na�ten�:
load('x8.mat'); 
load('y8.mat');
load('z8.mat');
%V�po�et celkov�ho pohybu pomoc� Eukliedovsk� vzd�lenosti
r = sqrt(VarName6.^2+VarName7.^2+VarName8.^2);
%Ode�ten� t�hov�ho zrychlen�
r = (r-9.81)';
okno = 10;    % D�lka okna, kter� klou�e po sign�lu, pomoc� kter�ho se 
              % sign�l po ur�it�ch charakteristick�ch vln�ch zpr�m�ruje
              % okno je doporu�en� defaultn� volit stejn� jako fvz              
[ref_x] = jeden_krok(r,okno); % Funkce pro v�po�et vlnky/kmit, kter� je 
                              % charakteristick� u konkr�n�ho nam��en�ho 
                              % sign�lu pro jeden krok.                             
%Prahov�n� pro konkr�tn� sign�ly pro spr�vn� detekce krok�, nastavov�no
%empiricky
min_prah = 2;
max_prah = 15;
%Funkce pro aplikaci korelace a n�sledn� detekce jednotliv�ch krok�
[K,P2] = korelace_detekce(ref_x,r,min_prah,max_prah);                           
kroky_filtrace = length(P2);

%Dokreslen�
subplot(2,1,2)
plot(K)
hold on
findpeaks(K,'MinPeakDistance',min_prah,'MinPeakHeight',max_prah)
title('M��en� s mobilem v kapse')
hold off
xlabel('Po�et vzork� [-]')
ylabel('zrychlen� m/s^(^-^2^)')
