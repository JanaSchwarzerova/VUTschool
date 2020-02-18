clc
clear all
close all

%% Memorizace

%Vytvoøení nulového vektoru 
n = 6;
V = zeros(1,n);

% volám pro dvì pro n a V 
V  = Mem_Fibo(n,V)
    

%% Nejèokoladovìjší cesta

M = [4,0,0,0;1,5,0,0;7,3,8,0;4,7,2,1];

choco = Cokolada(M,1,1)

%% Hanojská vìž

% 3 vstupy (pro kolik diskù se to øeší a na jaký kolik z kterého to chci dostat)
n = 3;
zKolik = 1;
naKolik = 3;

Hanoi(n,zKolik,naKolik)
