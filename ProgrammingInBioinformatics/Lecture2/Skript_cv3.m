clc
clear all
close all

%% Memorizace

%Vytvo�en� nulov�ho vektoru 
n = 6;
V = zeros(1,n);

% vol�m pro dv� pro n a V 
V  = Mem_Fibo(n,V)
    

%% Nej�okoladov�j�� cesta

M = [4,0,0,0;1,5,0,0;7,3,8,0;4,7,2,1];

choco = Cokolada(M,1,1)

%% Hanojsk� v�

% 3 vstupy (pro kolik disk� se to �e�� a na jak� kolik z kter�ho to chci dostat)
n = 3;
zKolik = 1;
naKolik = 3;

Hanoi(n,zKolik,naKolik)
