function [ vystup ] = Viterbi_algorithm( vstup,s,M,A,B,pi )
%Funkce Viterbi_algorithm
%   vstup
%   s ... po�et stav� 
%   M ... emitovan� stavy
%   A ... pravd�podobnosti p�echod� mezi stavy
%   B ... emisn� pravd�podobnost 
%   pi ... po��te�n� pravd�podobnosti 

% V�stup 
vystup = zeros(s,length(vstup));

% Zlogaritmov�n� v�ech hodnot 
A = log(A);
B = log(B);
pi = log(pi);



% Pro prvn� sloupec
for i=1:length(vstup)                         
   for m = 1:length(M)
        for j = 1:s %Po�et stav�   
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

