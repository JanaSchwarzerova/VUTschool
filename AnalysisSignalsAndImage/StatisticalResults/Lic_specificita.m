clear all; close all; clc
%% Projekt è. 10 Detekce na normalizovaných datech pomocí lícování
Shoda = 0;
Neshoda = 0;

for i = 2:224
   for n =1:4
        %Naèítání obrazù
        if i < 10
           I1 = imread(['00',num2str(i),'_',num2str(n),'.bmp']);
        elseif i < 100
           I1 = imread(['0',num2str(i),'_',num2str(n),'.bmp']); 
        else
           I1 = imread([num2str(i),'_',num2str(n),'.bmp']);  
        end
        
        %Vždy poslední obraz v pøedchozí sérii, bereme jako referneèní
        if i < 11
           I2 = imread(['00',num2str(i-1),'_5.bmp']);
        elseif i < 101
           I2 = imread(['0',num2str(i-1),'_5.bmp']); 
        else
           I2 = imread([num2str(i-1),'_5.bmp']);  
        end
        
%% Lícování
    [matchedPoints1,matchedPoints2] = funkce_licovani(I1,I2);        

%% ROZHODOVACÍ PRAVIDLO PRO DETEKCI ***************************************
        if matchedPoints1.Count>=5
        % Jestliže bude poèet nalezených shodných bodù vìtší nebo roven 5, nalezli
        % jsme shodu - oko stejného èlovìka; 
        % pokud ne, shoda nebyla nalezena a oèi jsou od dvou rùzných lidí  
         Shoda = Shoda +1;
        else
         Neshoda = Neshoda +1;    
        end
    end 
end

disp(['Poèet falešnì pozitivních ',num2str(Shoda), ' poèet správnì negativních ',num2str(Neshoda)])

%% Výpoèet senzitivity testu

specificita = Neshoda/(Shoda + Neshoda);

disp(['Specificita detektoru vyšla: ', num2str(specificita)])