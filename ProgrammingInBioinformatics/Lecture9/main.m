clear all; close all; clc;
%% FPRG 12.TÝDEN                                                 3.12.2018
%                           Markovovy modely

%2 stavy
s = 2;

%HMM (A,B,N,M,pi)

%N = ; %Množina skrytých znakù 
M = ['A','C','G','T']; %Emitované stavy A,C,G,T
A = [0.5,0.5;0.4,0.6]; %Pravdìpodobnosti pøechodu mezi stavy
B = [0.2,0.5;0.1,0.2;0.4,0.1;0.3,0.2]; %Emisní pravdìpodobnosti
pi = [0.7,0.3]; % Poèáteèní pravdìpodobnosti
vstup = 'CTAG';

 [ vystup ] = Viterbi_algorithm( vstup,s,M,A,B,pi )