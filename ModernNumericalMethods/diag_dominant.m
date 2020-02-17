function [ out ] = diag_dominant(A,u)
%Funkce pro ošetøení, zda je diagonálnì dominantní matice A
%Jedná se o rekurzivní funkci
%Vstupem funkce je matice A
%Výstupem funkce je out tedy diagonalne dominaní matice A

if u == size(A,1) %Ukonèovací podmínka
   out = A;
else
    if max(abs(A(u,:))) < sum(abs(A(u,:)))-max(abs(A(u,:))) || ...
       max(abs(A(u,:))) == sum(abs(A(u,:)))-max(abs(A(u,:)))
        %Když souèet dvou prvkù není ostøe menší než maximum 
        out = []; %Ukonèení
    else
        if u > 2 || u ==2
            [~,pom_poz1]=max(abs(A(u-1,:)));
            [~,pom_poz2]=max(abs(A(u,:)));   %Pokud dva øádky mají ve stejném sloupci maximum
                                             %Nelze vytvoøit diag. dom. matice
            if pom_poz1 == pom_poz2
            out = []; %Ukonèení
            end
        end
        
        if abs(A(u,:)) == max(abs(A(u,:)))
           out = A;
        else
            [maximum, pozice] = max(abs(A(u,:)));
            %Najdu pozici maxima, a podle toho dám vektor na urèitý øádek,
            %aby sedìla diagonalita matice
            pom=A(u,:); %Pomocná pro uložení
            A(u,:)= A(pozice,:); %Pøepis
            A(pozice,:)= pom;    %Pøepis øádkù, který pøepisujeme
            u = u+1;
            out = diag_dominant(A,u);
        end
    end
end
end


