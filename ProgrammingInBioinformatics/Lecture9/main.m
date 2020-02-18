clear all; close all; clc;
%% FPRG 12.T�DEN                                                 3.12.2018
%                           Markovovy modely

%2 stavy
s = 2;

%HMM (A,B,N,M,pi)

%N = ; %Mno�ina skryt�ch znak� 
M = ['A','C','G','T']; %Emitovan� stavy A,C,G,T
A = [0.5,0.5;0.4,0.6]; %Pravd�podobnosti p�echodu mezi stavy
B = [0.2,0.5;0.1,0.2;0.4,0.1;0.3,0.2]; %Emisn� pravd�podobnosti
pi = [0.7,0.3]; % Po��te�n� pravd�podobnosti
vstup = 'CTAG';

 [ vystup ] = Viterbi_algorithm( vstup,s,M,A,B,pi )