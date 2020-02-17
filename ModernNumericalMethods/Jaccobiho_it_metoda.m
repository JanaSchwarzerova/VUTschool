function [x] = Jaccobiho_it_metoda(A,b,krok)
%% Jaccobiho iteraèní metoda

c = zeros(size(A,1),size(A,2)); %matice c 
d = zeros(size(A,1),1);         %vektor d
vstup = zeros(size(A,1),1);     %vstupní vektor (ve skriptech oznaèován jako x0)

%Úprava na tvar x=Cx+d ****************************************************

%Ošetøení matice A, pro konvergenci 
%(A je diagonálnì dominantní? .. pokud ne pøeskládej øádky tak aby byla)
% Øeší funkce diag_dominant – princip rekurzivní funkce 
pom_A = diag_dominant(A,1);
pom_A
pom_b = zeros(length(b),1);
   for p = 1:length(b)
   [~,poz]=max(abs(A(p,:)));
   pom_b(poz) = b(p);
   end
   
%Oštøení matice A (zda je regulární, pomocí pøíkazu rank)
pom = rank(A); %Pøíkaz pro výpoèet hodnosti matice
A = pom_A; %Pøepis matice A na dominantnì diagonální matici 
b = pom_b;
if pom == size(A,1) %Ošetøení matice A - zda je regulární
    for i = 1:size(A,1)
        d(i)= b(i)/A(i,i);
        for j = 1:size(A,2) %Samotná úprava vektorù "a" na tvar vektoru "c"
            if i == j
                c(i,i)=0;
            else
                c(i,j)= -(A(i,j)/A(i,i));
            end
        end
      
    end 
    for k = 1:krok
        if k == 1
            x=sum(c*vstup)+d;
        else
            x(:,k) = c*x(:,k-1)+d;
        end
    end
x = x';
else
x = ['Matice A není regulární nebo není diagonálnì dominantní, èi není', ...
     'možnost jí popøeházet tak, aby diagonálnì dominantní byla'];
end


end

