clear all; close all; clc
%% Vykreslení Korelace pro shodu a neshodu: 

%Naèítání obrazù
 I1 = imread(['001_1.bmp']);
 %I2 = imread(['001_5.bmp']);
 I2 = imread(['008_5.bmp']);

        
 %Provedeme korelace
 Kor = round(corr2(I1,I2),2);

 if Kor>=0.40
    % Jestliže korelaèní koeficient bude vìtší nebo roven 0.45 prohlásíme 
    % oèi shodnými
    figure; 
    subplot(2,1,1)
    imshow(I1)
    title(['Shoda nalezena     S korelaèním koeficientem: ', num2str(Kor)])
    subplot(2,1,2)
    imshow(I2)
 else
    figure; 
    subplot(2,1,1)
    imshow(I1)
    title(['Shoda nebyla nalezena     S korelaèním koeficientem: ', num2str(Kor)])
    subplot(2,1,2)
    imshow(I2)
 end 