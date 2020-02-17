clear all; close all; clc;
%% Projekt MMNM
%                                                  autor: Jana Schwarzerov�
%                                                  ID: 186686
% Kap.2 Soustavy line�rn�ch rovnic
% 2.3 Itera�n� metody �e�en�
%                            � Jacobiho itera�n� metoda
%                            � Gaussova � Seidelova itera�n� metoda
% ( mo�n� roz���en� 2.4 Relaxa�n� �asy, relativn� chyba atd... )

%% Jacobiho itera�n� metoda

% A = randn(3);
% b = randn(3,1);

% A = [1,5,-8;10,4,-5;1,12,-10];
% b = [-6.5,1.5,-2.5];

A = [1,2,3;4,5,6;7,8,9];
b = [8,30,4];
krok = 3; 

[x_J] = Jaccobiho_it_metoda(A,b,krok);
[x_GS] = GS_it_metoda(A,b,krok);
