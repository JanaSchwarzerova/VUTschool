function [SWCp] = Prahovani(SWC,N_1,K,prah_1,prah_2,pom)
%Funkce Prahování: naprahuje signál pomocí algoritmu mìkkého prahování,
%                  tvrdého prahování nebo Garrote prahování

%Vstup: 
%       SWC ... hodnoty z vlnkové transformace 
%       N_1 ... stupeò rozkladu 
%       K   ... konstanta pro výpoèet empirického prahu 
%               [defaultnì nastavená na 3]
%       prah_1... je pomocná promìnná, která urèuje jak bude práh vypoèítán
%               'Median' ... Pomocí vzorce obsahující medián vydìlený
%                            konstantou 0,6745
%               'Std' ... Pomocí vzorce pro smìrodatnou odchylku
%               [defaultnì je prah nastaven pro Std]
%       prah_2... je pomocná promìnná, která urèuje jaký práh bude použitý
%               'U' ... Univerzální práh 
%               'E' ... Empirický práh
%               [defaultnì je prah nastaven pro Univerzální práh]
%       pom ... je pomocná promìnná, která urèuje, jaký typ prahování bude použit
%               'M' ... Mìkké prahování 
%               'T' ... Tvrdé prahování
%               'G' ... Garrote prahování 
%               [defaultnì je pom nastavená pro Mìkké prahování]

% pozn. - Mìkké prahování s vyšším prahem je doporuèováno podle pøednášek 
%         od doc. Kozumplíka; pøedmìt FACS
       
%Výstup: 
%       SWCp ... pøeprahované vystupní hodnoty

SWCp = SWC; %Vytvoøení výstupní hodnoty

if isempty(K) %Defaultní nastavení konstanty K
   K = 3; 
end

if isempty(pom) %Defaultní nastavení pom pro Mìkké prahování
   pom = 'M'; 
end

if isempty(prah_1) %Defaultní nastavení prah_2 pro výpoèet pomocí std
   prah_1 = 'Std'; 
end

if isempty(prah_2) %Defaultní nastavení prah_1 pro Univerzální práh
   prah_2 = 'U'; 
end

for i=1:1:N_1 %Prahování provádìnné pro každé rozkladové pásmo zvláš
    if strcmp(prah_1,'Std')
       delta(i) = std(SWCp(i,:)); %smìrodatná odchylka
    elseif strcmp(prah_1,'Median')
       delta(i) = median(abs(SWCp(i,:)))/0.6745;
    else 
       delta(i) = std(SWCp(i,:)); %smìrodatná odchylka
    end
    
    if strcmp(prah_2,'U')
       lambda(i) = delta(i)*sqrt(2*log(N_1)); %univerzální práh
    elseif strcmp(prah_2,'E')
       lambda(i) = delta(i)*K; %empirický práh
    else 
        lambda(i) = delta(i)*sqrt(2*log(N_1)); %univerzální práh
    end   
end

for i=1:1:N_1
    for j=1:1:size(SWCp,2)
        if abs(SWCp(i,j))>lambda(i)
           if strcmp(pom,'M')
              SWCp(i,j)=sign(SWCp(i,j))*(abs(SWCp(i,j))-lambda(i));   %Mìkké prahování
           elseif strcmp(pom,'T')
              SWCp(i,j)=SWCp(i,j);                                    %Tvrdé prahování            
           elseif strcmp(pom,'G')
              SWCp(i,j)=SWCp(i,j)-((lambda(i)^2)/SWCp(i,j));          %Garrote prahování               
           else
              SWCp(i,j)=sign(SWCp(i,j))*(abs(SWCp(i,j))-lambda(i));   %Mìkké prahování
           end
        else
           SWCp(i,j)=0;                      
        end
    end
end


end

