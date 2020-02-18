function [ vektor ] = Breakpoint( vektor )
%Funkce pro setøídìní vektoru


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

for i = 1:length(vektor)-1
   if i == 1
   ukazatel(i) = 1;   
   elseif i == length(vektor);
   ukazatel(i) = 1;    
   elseif vektor(i) == vektor(i+1)-1
   ukazatel(i)=1;
   else
   ukazatel(i)=0;
   end
end


%% 4. nalezaní minima v sestupných 
 
pom_pom = [];
for i = 1:length(vektor)
    if pom(i) == 0 
       pom_pom = [pom_pom vektor(i)];
    end
end

index = [];
for i = 1:length(vektor)-1
    if ukazatel(i) == 1 && ukazatel(i+1) == 0
       index = [index i];
    end
end
index = min(index)+1;

%% 5. reverze mezi ukazatelem 1 a minimem 

pom_vektor = vektor(index:find(vektor == min(pom_pom)));
pom_vektor = fliplr(pom_vektor);

vektor1 = vektor(1:index-1);
vektor2 = pom_vektor;
vektor3 = vektor(find(vektor == min(pom_pom))+1:end);

vektor = [vektor1 vektor2 vektor3];


while isequal(pom,ukazatel) == 0

    disp(vektor)
    break
end

end

