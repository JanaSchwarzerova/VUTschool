% __________________________________________________________FNPR 8. týden
clear all; close all; clc 

% 1. Pøídání okrajových hodnot
% 2. indikace vzestupných/sestupných hodnot
% 3. ukazatel setøídìné oblasti
% 4. nalezaní minima v sestupných 
% 5. reverze mezi ukazatelem 1 a minimem 
% opakujeme od 2. kroku znovu

%Pø. 
% 6 5 4 1 2 7 3 9 8
% Pøidání okrajových hodnot: max+1, min-1
%                            0 6 5 4 1 2 7 3 9 8 10
% dále si vytvoøíme pomocný vektor, kde nadefinujeme  sestupné ... 0
%                                                    vzestupné ... 1
%                   pomocný vektor: 
%                            1 0 0 0 1 1 0 0 0 0 1
% Následnì si musíme samostatnì zjistit zda je to setøídìné, 
% nelze použít pomocný vektor k tomu
%
% Ukazatel: DOPLNÌK ... udìlat druhého ukazatele, ukazatel1 a ukazatel2, a
% pak tøídit prvky pouze mezi tìmi dvìma ukazateli
%
% nalezení minima v sestupných..v našem pøípadì se jedná o 3, a od této ten
% vektor pøevrátíme: 
%                             0 | 6 5 4 1 2 7 |3| 9 8 10
%                             0 |3| 7 2 1 4 5 6 | 9 8 10
% po rezurzi si udìlám znovu pomocný vektor
%                             1  0  0 0 0 1 1 1   0 0 1
%                             0  1  2 | 7 3 4 5 6 9 8 10        isequal(v1,v2)
%                             1  1  1   0 1 1 1 1 0 0 1
% KOLIZE 1 - máme všechny vsestupný
% KOLIZE 2 - máme jednu osamostatnìnou sestupnou v již setøídìných èástech 

% flipr() ... použít pøíkaz pro pøevrácení vektoru
% isequal(v1,v2) ... porovnávání setøídìného vektoru s tím pomocným 

vektor = [6 5 4 1 2 7 3 9 8];
index = [];

%% 1. Pøídání okrajových hodnot

pom_max = max(vektor);
pom_min = min(vektor);
vektor = [pom_min-1 vektor pom_max+1];
pom = [];
ukazatel =[];
a = 0;
konec = ones(length(vektor));
while   a == 0%isequal(ukazatel,konec(1,:)) == 0  
%% 2. indikace vzestupných/sestupných hodnot 

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

%% 3. ukazatel setøídìné oblasti

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


%% 4. nalezaní minima v sestupných 
 
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
