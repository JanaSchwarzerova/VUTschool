clear all; close all; clc
%% Projekt è. 10 Detekce na normalizovaných datech pomocí korelace

Shoda = 0;
Neshoda = 0;

for i = 1:224
   for n =1:4
        %Naèítání obrazù
        if i < 10
           I1 = imread(['00',num2str(i),'_',num2str(n),'.bmp']);
        elseif i < 100
           I1 = imread(['0',num2str(i),'_',num2str(n),'.bmp']); 
        else
           I1 = imread([num2str(i),'_',num2str(n),'.bmp']);  
        end
        
        %Vždy poslední obraz v sérii, bereme jako referneèní
        if i < 10
           I2 = imread(['00',num2str(i),'_5.bmp']);
        elseif i < 100
           I2 = imread(['0',num2str(i),'_5.bmp']); 
        else
           I2 = imread([num2str(i),'_5.bmp']);  
        end
        
        %Provedeme korelace
        Kor = round(corr2(I1,I2),2);

        if Kor>=0.40
           % Jestliže korelaèní koeficient bude vìtší nebo roven 0.45 prohlásíme 
           % oèi shodnými
           Shoda = Shoda +1;
        else
            Neshoda = Neshoda +1;  
        end
    end 
end

disp(['Poèet správné detekce je roven ',num2str(Shoda), ' falešnì negativních ',num2str(Neshoda)])

%% Výpoèet senzitivity testu

senzitivita = (Shoda + Neshoda)/((Shoda + Neshoda)+Neshoda);
disp(['Sezitivita detektoru vyšla: ', num2str(senzitivita)])

