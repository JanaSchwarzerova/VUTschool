clc; clear all, close all

%% Projekt è. 10  – èást LÍCOVÁNÍ 
% Skript vytvoøen èistì pro ilustraci: 
% Možnost použití celých neoøezaných oèí pøi vìtším zvoleném prahu 
% Èi pøedzpracovaného obrazu (viz skript Projekt_10.m) s menším
% nastavitelným prahem 

% Naètení obrazu:

I1 = rgb2gray(imread('01_L.bmp')); %Oko_1 1.snímek
I2 = rgb2gray(imread('02_L.bmp')); %Oko_1 2.snímek
%I2 = rgb2gray(imread('08_L.bmp')); %Oko_8 8.snímek

% volání funkce lícování
[matchedPoints1,matchedPoints2] = funkce_licovani(I1,I2);

if matchedPoints1.Count>=10
    % Jestliže bude poèet nalezených shodných bodù vìtší nebo roven 10, nalezli
    % jsme shodu - oko stejného èlovìka; 
    % pokud ne, shoda nebyla nalezena a oèi jsou od dvou rùzných lidí   
    figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    title('Shoda')
else
    figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    title('Shoda nebyla nalezena')
     
end








