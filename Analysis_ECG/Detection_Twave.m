function [T] = Detection_Twave(DERFI,leads,Sum_QRS,S,T_Deteciton_rule)
%Funkce Detection_Twave má za úkol detekovat zaèátek a konce vlny P
%Vstupy funkcí jsou: DERFI - pøefiltrovaný derivovaný signál 
%                    signal - pøefiltrovný pùvodní signál
%                    leads – poèet svodù
%                    Sum_QRS - poèet QRS komplexù
%                    S - struktura, ve které jsou uložené detekované S kmity
%                    T_Detection_rule - Rozhodovací pravidlo pro T vlnu
%Výstup funkce bude: T - struktura, ve které budou uloženy konce vlny T

    Interval = round((0.34/10)*5000); % Interval, je èasový úsek, podle kterého budeme detekovat
                                      % hodnota 340 ms je hodnota nacházející se ve wikiskriptech
    for j=1:leads 
        Peak_T=[];
        for i=1:Sum_QRS(j,3) %Pocet QRS komplexov v kazdom svode
            if S{j}(i)+Interval>4999 %Ošetøení konce signálu
               window=DERFI(j,S{j}(i):end); %Vytvoøení okna
            else
               window=DERFI(j,S{j}(i):S{j}(i)+Interval); %Vytvoøení okna
            end
            WINDOW=fliplr(window); %pøehození okna (tak aby detekoval od konce)
            [~,H2]=find(abs(WINDOW)>0.03*T_Deteciton_rule(j)); %Nalezení vrcholu v oknì podle rozhodovacího pravidla
            if isempty(H2) %Ošetøení pro prázdnou matici (tedy pokud nebude nadetekován, žádná T vlna)
                Peak_T=[Peak_T];  
            else
                Peak_T=[Peak_T,S{j}(i)+length(window)-H2(1)];
            end
        end
        if isempty(Peak_T) %Ošetøení pro prázdný Peak_T
            if j==1; %Ošetøení pro první svod
               T{j}=[]; %Tento krok máme ošetøený ještì i pøed shlukovou analýzou
            else
               T{j}=T{j-1,:}; %Jinak bereme hodnoty T vln u ostatních svodù
            end
        else
            T{j}=Peak_T;
        end
    end
end