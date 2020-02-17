clear all; close all; clc
%% Vykreslen� Korelace pro shodu a neshodu: 

%Na��t�n� obraz�
 I1 = imread(['001_1.bmp']);
 %I2 = imread(['001_5.bmp']);
 I2 = imread(['008_5.bmp']);

        
 %Provedeme korelace
 Kor = round(corr2(I1,I2),2);

 if Kor>=0.40
    % Jestli�e korela�n� koeficient bude v�t�� nebo roven 0.45 prohl�s�me 
    % o�i shodn�mi
    figure; 
    subplot(2,1,1)
    imshow(I1)
    title(['Shoda nalezena     S korela�n�m koeficientem: ', num2str(Kor)])
    subplot(2,1,2)
    imshow(I2)
 else
    figure; 
    subplot(2,1,1)
    imshow(I1)
    title(['Shoda nebyla nalezena     S korela�n�m koeficientem: ', num2str(Kor)])
    subplot(2,1,2)
    imshow(I2)
 end 