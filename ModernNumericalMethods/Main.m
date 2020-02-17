clear all; close all; clc;
%% Projekt MMNM
%                                                  autor: Jana Schwarzerová
%                                                  ID: 186686
% Kap.2 Soustavy lineárních rovnic
% 2.3 Iteraèní metody øešení
%                            – Jacobiho iteraèní metoda
%                            – Gaussova – Seidelova iteraèní metoda
% ( možné rozšíøení 2.4 Relaxaèní èasy, relativní chyba atd... )

%% Jacobiho iteraèní metoda

% A = randn(3);
% b = randn(3,1);

% A = [1,5,-8;10,4,-5;1,12,-10];
% b = [-6.5,1.5,-2.5];

A = [1,2,3;4,5,6;7,8,9];
b = [8,30,4];
krok = 3; 

[x_J] = Jaccobiho_it_metoda(A,b,krok);
[x_GS] = GS_it_metoda(A,b,krok);
