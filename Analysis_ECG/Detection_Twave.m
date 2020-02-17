function [T] = Detection_Twave(DERFI,leads,Sum_QRS,S,T_Deteciton_rule)
%Funkce Detection_Twave m� za �kol detekovat za��tek a konce vlny P
%Vstupy funkc� jsou: DERFI - p�efiltrovan� derivovan� sign�l 
%                    signal - p�efiltrovn� p�vodn� sign�l
%                    leads � po�et svod�
%                    Sum_QRS - po�et QRS komplex�
%                    S - struktura, ve kter� jsou ulo�en� detekovan� S kmity
%                    T_Detection_rule - Rozhodovac� pravidlo pro T vlnu
%V�stup funkce bude: T - struktura, ve kter� budou ulo�eny konce vlny T

    Interval = round((0.34/10)*5000); % Interval, je �asov� �sek, podle kter�ho budeme detekovat
                                      % hodnota 340 ms je hodnota nach�zej�c� se ve wikiskriptech
    for j=1:leads 
        Peak_T=[];
        for i=1:Sum_QRS(j,3) %Pocet QRS komplexov v kazdom svode
            if S{j}(i)+Interval>4999 %O�et�en� konce sign�lu
               window=DERFI(j,S{j}(i):end); %Vytvo�en� okna
            else
               window=DERFI(j,S{j}(i):S{j}(i)+Interval); %Vytvo�en� okna
            end
            WINDOW=fliplr(window); %p�ehozen� okna (tak aby detekoval od konce)
            [~,H2]=find(abs(WINDOW)>0.03*T_Deteciton_rule(j)); %Nalezen� vrcholu v okn� podle rozhodovac�ho pravidla
            if isempty(H2) %O�et�en� pro pr�zdnou matici (tedy pokud nebude nadetekov�n, ��dn� T vlna)
                Peak_T=[Peak_T];  
            else
                Peak_T=[Peak_T,S{j}(i)+length(window)-H2(1)];
            end
        end
        if isempty(Peak_T) %O�et�en� pro pr�zdn� Peak_T
            if j==1; %O�et�en� pro prvn� svod
               T{j}=[]; %Tento krok m�me o�et�en� je�t� i p�ed shlukovou anal�zou
            else
               T{j}=T{j-1,:}; %Jinak bereme hodnoty T vln u ostatn�ch svod�
            end
        else
            T{j}=Peak_T;
        end
    end
end