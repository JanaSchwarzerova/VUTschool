function [ out ] = diag_dominant(A,u)
%Funkce pro o�et�en�, zda je diagon�ln� dominantn� matice A
%Jedn� se o rekurzivn� funkci
%Vstupem funkce je matice A
%V�stupem funkce je out tedy diagonalne dominan� matice A

if u == size(A,1) %Ukon�ovac� podm�nka
   out = A;
else
    if max(abs(A(u,:))) < sum(abs(A(u,:)))-max(abs(A(u,:))) || ...
       max(abs(A(u,:))) == sum(abs(A(u,:)))-max(abs(A(u,:)))
        %Kdy� sou�et dvou prvk� nen� ost�e men�� ne� maximum 
        out = []; %Ukon�en�
    else
        if u > 2 || u ==2
            [~,pom_poz1]=max(abs(A(u-1,:)));
            [~,pom_poz2]=max(abs(A(u,:)));   %Pokud dva ��dky maj� ve stejn�m sloupci maximum
                                             %Nelze vytvo�it diag. dom. matice
            if pom_poz1 == pom_poz2
            out = []; %Ukon�en�
            end
        end
        
        if abs(A(u,:)) == max(abs(A(u,:)))
           out = A;
        else
            [maximum, pozice] = max(abs(A(u,:)));
            %Najdu pozici maxima, a podle toho d�m vektor na ur�it� ��dek,
            %aby sed�la diagonalita matice
            pom=A(u,:); %Pomocn� pro ulo�en�
            A(u,:)= A(pozice,:); %P�epis
            A(pozice,:)= pom;    %P�epis ��dk�, kter� p�episujeme
            u = u+1;
            out = diag_dominant(A,u);
        end
    end
end
end


