clc
clear all 
close all

%% Vyhledávání transkripèních motivù
DNA{1} = 'AACGTGCT';
DNA{2} = 'CATACGTA';
DNA{3} = 'ACCTTAGC';
DNA{4} = 'TCTCCGTA';

s =  [2,5,1,3];
m = 4;
[bs, block] = Score( s, DNA, m)

L = length(s);
n = length(DNA{1});
k = n-length(s)+1;
a = s;

a  = NextLeaf( a, L, k);

t = L;
l = length(s); 
[bM,bS,bB] = BruteForceMotifSearchAgain(DNA, L, n, l)


