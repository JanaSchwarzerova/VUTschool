function [x] = Jaccobiho_it_metoda(A,b,krok)
%% Jaccobiho itera�n� metoda

c = zeros(size(A,1),size(A,2)); %matice c 
d = zeros(size(A,1),1);         %vektor d
vstup = zeros(size(A,1),1);     %vstupn� vektor (ve skriptech ozna�ov�n jako x0)

%�prava na tvar x=Cx+d ****************************************************

%O�et�en� matice A, pro konvergenci 
%(A je diagon�ln� dominantn�? .. pokud ne p�eskl�dej ��dky tak aby byla)
% �e�� funkce diag_dominant � princip rekurzivn� funkce 
pom_A = diag_dominant(A,1);
pom_A
pom_b = zeros(length(b),1);
   for p = 1:length(b)
   [~,poz]=max(abs(A(p,:)));
   pom_b(poz) = b(p);
   end
   
%O�t�en� matice A (zda je regul�rn�, pomoc� p��kazu rank)
pom = rank(A); %P��kaz pro v�po�et hodnosti matice
A = pom_A; %P�epis matice A na dominantn� diagon�ln� matici 
b = pom_b;
if pom == size(A,1) %O�et�en� matice A - zda je regul�rn�
    for i = 1:size(A,1)
        d(i)= b(i)/A(i,i);
        for j = 1:size(A,2) %Samotn� �prava vektor� "a" na tvar vektoru "c"
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
x = ['Matice A nen� regul�rn� nebo nen� diagon�ln� dominantn�, �i nen�', ...
     'mo�nost j� pop�eh�zet tak, aby diagon�ln� dominantn� byla'];
end


end

