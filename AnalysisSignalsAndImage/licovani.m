clc; clear all, close all

%% Projekt �. 10  � ��st L�COV�N� 
% Skript vytvo�en �ist� pro ilustraci: 
% Mo�nost pou�it� cel�ch neo�ezan�ch o�� p�i v�t��m zvolen�m prahu 
% �i p�edzpracovan�ho obrazu (viz skript Projekt_10.m) s men��m
% nastaviteln�m prahem 

% Na�ten� obrazu:

I1 = rgb2gray(imread('01_L.bmp')); %Oko_1 1.sn�mek
I2 = rgb2gray(imread('02_L.bmp')); %Oko_1 2.sn�mek
%I2 = rgb2gray(imread('08_L.bmp')); %Oko_8 8.sn�mek

% vol�n� funkce l�cov�n�
[matchedPoints1,matchedPoints2] = funkce_licovani(I1,I2);

if matchedPoints1.Count>=10
    % Jestli�e bude po�et nalezen�ch shodn�ch bod� v�t�� nebo roven 10, nalezli
    % jsme shodu - oko stejn�ho �lov�ka; 
    % pokud ne, shoda nebyla nalezena a o�i jsou od dvou r�zn�ch lid�   
    figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    title('Shoda')
else
    figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
    legend('matched points 1','matched points 2');
    title('Shoda nebyla nalezena')
     
end








