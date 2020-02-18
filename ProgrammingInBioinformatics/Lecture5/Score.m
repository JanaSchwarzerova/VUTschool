function [ bs, block ] = Score( s, DNA, n)
% s - odkud zaèíná konsenzus
% DNA - typ cell, ve které jsou zadané sekvence
% n - jak bude konsenzus dlouhý (jak daleko od zaèátku je konec konsenzusu)

% bs .. to skóre souèet maxim (frekvence)
% block .. výpis o jaké konsenzy se jednalo

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