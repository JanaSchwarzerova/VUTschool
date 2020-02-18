function [ bs, block ] = Score( s, DNA, n)
% s - odkud za��n� konsenzus
% DNA - typ cell, ve kter� jsou zadan� sekvence
% n - jak bude konsenzus dlouh� (jak daleko od za��tku je konec konsenzusu)

% bs .. to sk�re sou�et maxim (frekvence)
% block .. v�pis o jak� konsenzy se jednalo

for i = 1: length(DNA)
    block(i,:) = DNA{1, i}(s(i):s(i)+n-1);
end
for j = 1:length(block)    
     sum_A(j) = length(find(block(:,j)=='A'));
     sum_C(j) = length(find(block(:,j)=='C'));
     sum_T(j) = length(find(block(:,j)=='T'));     
     sum_G(j) = length(find(block(:,j)=='G'));     
end
 ACTG =[sum_A;sum_C;sum_T;sum_G];
 for q=1:length(ACTG)
  pom(q) = max(ACTG(:,q));       
 end
 bs = sum(pom);
end