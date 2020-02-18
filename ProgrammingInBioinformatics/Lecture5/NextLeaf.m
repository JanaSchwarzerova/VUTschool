function [ a ] = NextLeaf( a, L, k)
%   L = d�lka s (je to vlastn� po�et sekvenc� = t)
%   a = s
%   k je maxim�ln� hodnota, kter� se m��e vyskytovat
%   k = n-e+1 ... posledn� 4 nukleotidy.. k = 46 ... 50-4+1
%       n .. delka sekvenc�, 
%       e .. po�et motiv� 

for i = L:-1:1
     if a(i) < k
        a(i)= a(i)+1;
        return
     end
     a(i) = 1;
end

end

