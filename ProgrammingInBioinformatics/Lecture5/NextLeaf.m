function [ a ] = NextLeaf( a, L, k)
%   L = délka s (je to vlastnì poèet sekvencí = t)
%   a = s
%   k je maximální hodnota, která se mùže vyskytovat
%   k = n-e+1 ... poslední 4 nukleotidy.. k = 46 ... 50-4+1
%       n .. delka sekvencí, 
%       e .. poèet motivù 

for i = L:-1:1
     if a(i) < k
        a(i)= a(i)+1;
        return
     end
     a(i) = 1;
end

end

