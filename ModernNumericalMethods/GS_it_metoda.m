function [x] = GS_it_metoda(A,b,krok)
%% Gauss Seidlova itera�n� metoda

%Ov��en� konvergence: 
overeni = 0;

% 1. Matice je symetrick� a z�rove� pozitivn� definitn� 
   for i = 1:length(A) %Pozitivn� definitn�
        if det(A(1:i,1:i))> 0
            pom_overeni = 1; 
        else
            pom_overeni = 0; 
        end
   end
   if same(A,A') && pom_overeni == length(A) %Ov��en� symetri�nosti matice poz. def
       overeni = 1;
   end

% 2. Matice je diagon�ln� dominantn�, nebo ji lze p�eskladat, 
%    aby diagon�ln� dominantn� byla 
   pom_A = diag_dominant(A,1);
   pom_b = zeros(length(b),1);
   for p = 1:length(b)
   [~,poz]=max(abs(A(p,:)));
   pom_b(poz) = b(p);
   end
   if length(pom_A) > 0
      A = pom_A;
      b = pom_b;
      overeni = 1; 
   end 

%3. ��dkov� (alfa1), sloupcov� (alfa2), nebo Euklidovsk� (alfa3) norma je men�� ne� 1. 

    for i = 1:size(A,1) %P�epo�et na matici "c"
        d(i)= b(i)/A(i,i);
        for j = 1:size(A,2)
            if i == j
                c(i,i)=0;
            else
                c(i,j)= -(A(i,j)/A(i,i));
            end
        end    
    end 

    alfa1 = max(sum(c'));                 %��dkov� norma
    alfa2 = max(sum(c));                  %Sloupcov� norma
    alfa3 = (sum(sum((c')^2)))^(1/2);     %Eukliedovsk� norma
    
   if alfa1 < 0 ||  alfa2 < 0 || alfa3 < 0 
       overeni = 1;
   end
   
    %Algoritmus pro G-S
    if overeni == 1
        n = length(A);
        x = zeros(size(A,1),1);
        vystup_GS = [];
        for k = 1:krok
            pom = [];
            for i = 1:n
                x(i) = (1/A(i, i))*(b(i) - A(i, 1:n)*x + A(i, i)*x(i));
                pom = [pom, x(i)];    
            end
            vystup_GS = [vystup_GS; pom];
        end
        x = vystup_GS;
    else 
        x = ['Matice A nespl�uje podm�nky pro konvergenci'];
    end
    
end

