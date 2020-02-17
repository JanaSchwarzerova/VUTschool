function [SWCp] = Prahovani(SWC,N_1,K,prah_1,prah_2,pom)
%Funkce Prahov�n�: naprahuje sign�l pomoc� algoritmu m�kk�ho prahov�n�,
%                  tvrd�ho prahov�n� nebo Garrote prahov�n�

%Vstup: 
%       SWC ... hodnoty z vlnkov� transformace 
%       N_1 ... stupe� rozkladu 
%       K   ... konstanta pro v�po�et empirick�ho prahu 
%               [defaultn� nastaven� na 3]
%       prah_1... je pomocn� prom�nn�, kter� ur�uje jak bude pr�h vypo��t�n
%               'Median' ... Pomoc� vzorce obsahuj�c� medi�n vyd�len�
%                            konstantou 0,6745
%               'Std' ... Pomoc� vzorce pro sm�rodatnou odchylku
%               [defaultn� je prah nastaven pro Std]
%       prah_2... je pomocn� prom�nn�, kter� ur�uje jak� pr�h bude pou�it�
%               'U' ... Univerz�ln� pr�h 
%               'E' ... Empirick� pr�h
%               [defaultn� je prah nastaven pro Univerz�ln� pr�h]
%       pom ... je pomocn� prom�nn�, kter� ur�uje, jak� typ prahov�n� bude pou�it
%               'M' ... M�kk� prahov�n� 
%               'T' ... Tvrd� prahov�n�
%               'G' ... Garrote prahov�n� 
%               [defaultn� je pom nastaven� pro M�kk� prahov�n�]

% pozn. - M�kk� prahov�n� s vy���m prahem je doporu�ov�no podle p�edn�ek 
%         od doc. Kozumpl�ka; p�edm�t FACS
       
%V�stup: 
%       SWCp ... p�eprahovan� vystupn� hodnoty

SWCp = SWC; %Vytvo�en� v�stupn� hodnoty

if isempty(K) %Defaultn� nastaven� konstanty K
   K = 3; 
end

if isempty(pom) %Defaultn� nastaven� pom pro M�kk� prahov�n�
   pom = 'M'; 
end

if isempty(prah_1) %Defaultn� nastaven� prah_2 pro v�po�et pomoc� std
   prah_1 = 'Std'; 
end

if isempty(prah_2) %Defaultn� nastaven� prah_1 pro Univerz�ln� pr�h
   prah_2 = 'U'; 
end

for i=1:1:N_1 %Prahov�n� prov�d�nn� pro ka�d� rozkladov� p�smo zvl᚝
    if strcmp(prah_1,'Std')
       delta(i) = std(SWCp(i,:)); %sm�rodatn� odchylka
    elseif strcmp(prah_1,'Median')
       delta(i) = median(abs(SWCp(i,:)))/0.6745;
    else 
       delta(i) = std(SWCp(i,:)); %sm�rodatn� odchylka
    end
    
    if strcmp(prah_2,'U')
       lambda(i) = delta(i)*sqrt(2*log(N_1)); %univerz�ln� pr�h
    elseif strcmp(prah_2,'E')
       lambda(i) = delta(i)*K; %empirick� pr�h
    else 
        lambda(i) = delta(i)*sqrt(2*log(N_1)); %univerz�ln� pr�h
    end   
end

for i=1:1:N_1
    for j=1:1:size(SWCp,2)
        if abs(SWCp(i,j))>lambda(i)
           if strcmp(pom,'M')
              SWCp(i,j)=sign(SWCp(i,j))*(abs(SWCp(i,j))-lambda(i));   %M�kk� prahov�n�
           elseif strcmp(pom,'T')
              SWCp(i,j)=SWCp(i,j);                                    %Tvrd� prahov�n�            
           elseif strcmp(pom,'G')
              SWCp(i,j)=SWCp(i,j)-((lambda(i)^2)/SWCp(i,j));          %Garrote prahov�n�               
           else
              SWCp(i,j)=sign(SWCp(i,j))*(abs(SWCp(i,j))-lambda(i));   %M�kk� prahov�n�
           end
        else
           SWCp(i,j)=0;                      
        end
    end
end


end

