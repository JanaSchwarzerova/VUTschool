function [ vystup ] = Viterbi_algorithm( vstup,s,M,A,B,pi )
%Funkce Viterbi_algorithm
%   vstup
%   s ... poèet stavù 
%   M ... emitované stavy
%   A ... pravdìpodobnosti pøechodù mezi stavy
%   B ... emisní pravdìpodobnost 
%   pi ... poèáteèní pravdìpodobnosti 

% Výstup 
vystup = zeros(s,length(vstup));

% Zlogaritmování všech hodnot 
A = log(A);
B = log(B);
pi = log(pi);



% Pro první sloupec
for i=1:length(vstup)                         
   for m = 1:length(M)
        for j = 1:s %Poèet stavù   
            if strcmp(vstup(i),M(m))
                if i == 1 
                    vystup(j,i)=pi(j)+B(m,j);
                    vystup(j,i) = round(vystup(j,i),3);
                else
                    vystup(j,i)= B(m,j)+(max((vystup(j,i-1)+A(1,j)),(vystup(j,i-1)+A(2,j))));   
                    vystup(j,i) = round(vystup(j,i),3);
                end
            end    
        end   
    end
end



end

