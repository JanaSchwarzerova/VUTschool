% __________________________________________________________FNPR 8. t�den
clear all; close all; clc 

% 1. P��d�n� okrajov�ch hodnot
% 2. indikace vzestupn�ch/sestupn�ch hodnot
% 3. ukazatel set��d�n� oblasti
% 4. nalezan� minima v sestupn�ch 
% 5. reverze mezi ukazatelem 1 a minimem 
% opakujeme od 2. kroku znovu

%P�. 
% 6 5 4 1 2 7 3 9 8
% P�id�n� okrajov�ch hodnot: max+1, min-1
%                            0 6 5 4 1 2 7 3 9 8 10
% d�le si vytvo��me pomocn� vektor, kde nadefinujeme  sestupn� ... 0
%                                                    vzestupn� ... 1
%                   pomocn� vektor: 
%                            1 0 0 0 1 1 0 0 0 0 1
% N�sledn� si mus�me samostatn� zjistit zda je to set��d�n�, 
% nelze pou��t pomocn� vektor k tomu
%
% Ukazatel: DOPLN�K ... ud�lat druh�ho ukazatele, ukazatel1 a ukazatel2, a
% pak t��dit prvky pouze mezi t�mi dv�ma ukazateli
%
% nalezen� minima v sestupn�ch..v na�em p��pad� se jedn� o 3, a od t�to ten
% vektor p�evr�t�me: 
%                             0 | 6 5 4 1 2 7 |3| 9 8 10
%                             0 |3| 7 2 1 4 5 6 | 9 8 10
% po rezurzi si ud�l�m znovu pomocn� vektor
%                             1  0  0 0 0 1 1 1   0 0 1
%                             0  1  2 | 7 3 4 5 6 9 8 10        isequal(v1,v2)
%                             1  1  1   0 1 1 1 1 0 0 1
% KOLIZE 1 - m�me v�echny vsestupn�
% KOLIZE 2 - m�me jednu osamostatn�nou sestupnou v ji� set��d�n�ch ��stech 

% flipr() ... pou��t p��kaz pro p�evr�cen� vektoru
% isequal(v1,v2) ... porovn�v�n� set��d�n�ho vektoru s t�m pomocn�m 

vektor = [6 5 4 1 2 7 3 9 8];
index = [];

%% 1. P��d�n� okrajov�ch hodnot

pom_max = max(vektor);
pom_min = min(vektor);
vektor = [pom_min-1 vektor pom_max+1];
pom = [];
ukazatel =[];
a = 0;
konec = ones(length(vektor));
while   a == 0%isequal(ukazatel,konec(1,:)) == 0  
%% 2. indikace vzestupn�ch/sestupn�ch hodnot 

for i = 1: length(vektor)
    if i == 1
    pom(i) =  1;
    elseif i == length(vektor)
    pom(i) =  1;    
    else
        if vektor(i+1) == vektor(i)+1
        pom(i)=1;
        elseif vektor(i-1)== vektor(i)-1 && pom(i-1)== 1 
        pom(i)=1;
        else
        pom(i)=0;
        end
    end
end

%% 3. ukazatel set��d�n� oblasti

for i = 1:length(vektor)
    if i == 1
    ukazatel(i) =  1;
    elseif i == length(vektor)
    ukazatel(i) =  1;    
    else    
        if  i == length(vektor);
        ukazatel(i) = 1;    
        elseif vektor(i) == vektor(i+1)-1
        ukazatel(i)=1;
        else
        ukazatel(i)=0;
        end
   end
end


%% 4. nalezan� minima v sestupn�ch 
 
pom_pom = [];
for i = 1:length(vektor)
    if pom(i) == 0 
       pom_pom = [pom_pom vektor(i)];
    end
end

for i = 1:length(vektor)-1
    if pom(i) == 1 && pom(i+1) == 0
       index = [index i];
    end
end
index = min(index)+1;

%% 5. reverze mezi ukazatelem 1 a minimem 

%KOLIZE_2
if isempty(pom_pom)
    a = 1;
else
    if (pom(index) == 0) && (pom(index-1) == 1) && (pom(index+1) == 1)
      pom_vektor = min(pom_pom);
  
      vektor1 = vektor(1:index-1);
      vektor2 = vektor(index+1:length(vektor)-1);
      vektor3 = [pom_vektor vektor(length(vektor))];
  
      vektor = [vektor1 vektor2 vektor3];
    else
    pom_vektor = vektor(index:find(vektor == min(pom_pom)));
    pom_vektor = fliplr(pom_vektor);

    vektor1 = vektor(1:index-1);
    vektor2 = pom_vektor;
    vektor3 = vektor(find(vektor == min(pom_pom))+1:end);

    vektor = [vektor1 vektor2 vektor3];
    end
	disp(pom)
    disp(ukazatel)
    disp(vektor)
    end
end
