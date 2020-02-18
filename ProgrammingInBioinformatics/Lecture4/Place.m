function Place(L,X)
%Týden 6 

if isempty(L)
   disp(X)
else
   y = max(L);
   D = X - y;
                                     %jsou vsechny fragmenty D soucasti L?
   [Lia,Locb] = ismember(D,L,'legacy');
   if isempty(find(Lia==0));
        J = 1;
   else
        for i=1:length(Locb)
            if Locb(i)~= 1 
            pom = length(find(L==D(i))); %Kolikrát se tam dané èíslo nachází 
                if pom == Locb(i)
                J = 1;
                end
            else
           J = 1;
            end
        end
    end
    if J == 1  %jsou vsechny fragmenty D soucasti L?
       X = [X,y]; %k X pridej y
       L = Remove(L,D);
       Place(L,X,width)%rekurzivne volej stejnou funkci
       position = find(X==y);
       X(position)=[]; %odtran z X pridanou hodnotu
       L = [L,X]; %pridej do L odstanene fragmenty
    end
    p = width-y;
    D = X - p;
    
   [Lia,Locb] = ismember(D,L,'legacy');
   if  isempty(find(Lia==0));
        J = 1;
   else
        for i=1:length(Locb)
            if Locb(i)~= 1 
            pom = length(find(L==D(i))); %Kolikrát se tam dané èíslo nachází 
                if pom == Locb(i)
                J = 1;
                end
            else
           J = 1;
            end
        end
    end
    if J == 1%jsou vsechny fragmenty D soucasti L?
      X = [X,p]; %k X pridej p
      L = Remove(L,D);
      Place(L,X,width)%rekurzivne volej stejnou funkci
      position = find(X==y);
      X(position)=[]; %odtran z X pridanou hodnotu
      L = [L,X];%pridej do L odstanene fragmenty
   end
end