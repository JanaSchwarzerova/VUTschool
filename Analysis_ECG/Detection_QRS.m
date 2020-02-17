function [R,Q,S,Sum_QRS] = Detection_QRS( ECGDER,signal,leads,Deteciton_rule_ECGDER)
%Funkce Detection_QRS má za úkol detekovat kmity Q, R a S.
%Vstupy funkcí jsou: ECGDER - derivovanı signál 
%                    signal - pøefiltrovnı pùvodní signál
%                    leads – poèet svodù
%                    QRS_r
%Vıstup funkce bude: R - struktura, ve které budou uloené pozice R kmitù
%                    Q - struktura, ve které budou uloené pozice Q kmitù
%                    S - struktura, ve které budou uloené pozice S kmitù
physiological_interval=round((0.7/10)*5000); %Maximalna tepova frekvencia.
                                                %Je to je minimální fyziologická hranice, 
                                                %pro délu RR intervalu
                                    %% !!! Pokud si physiological_interval upravíte na hodnotu
                                     %     physiological_interval=round((0.38/10)*5000)
                                     %     vıjdou Vám hodnoty, které jsou uvedené 
                                     %     v Tabulce 3. v dokumentaci (èlánku) k projektu
                                   
    for j=1:leads 
       Position_R=[];   %Urèování prázdnıch matic pro pozici R kmitu
       Position_S=[];   %Urèování prázdnıch matic pro pozici S kmitu
       Position_Q=[];   %Urèování prázdnıch matic pro pozici Q kmitu

        %% Detekce kmitu R
        [~,Position_R]=findpeaks(signal(j,:),'MinPeakDistance',physiological_interval);
        for I=1:length(Position_R) %pocet pozicii QRS
            %% Detekce kmitu S a Q
            %Detekujeme S kmit
            if I==length(Position_R) %Ošetøení, kdy se nadetekuje hned první S vlna špatnì
                                     %aby se nenadetekovaly všechny S vlny
                                     %špatnì   
                window_S=ECGDER(j,(Position_R(I):end)); %Stanovujeme si okno pro hledání S kmitù
                A=2;
                while A<length(window_S) %Dokud pomocná "A" bude menší ne délka okna
                      if sign(window_S(A))==sign(window_S(A-1))%Hledání crossing zeros v oknu
                         A=A+1;
                      else
                        [~,H1]=find(window_S(A:end)>0.03*Deteciton_rule_ECGDER(1,j));%Nalezení vrcholu v oknì podle rozhodovacího pravidla
                        if isempty(H1) %Ošetøení pro prázdnou matici (tedy pokud nebude nadetekován, ádnı S kmit)
                           Position_S=[Position_S];
                           A=length(window_S);
                        else
                           if Position_R(I)+A+H1(1) > 4999 %Ošetøení, abychom nepøesáhly vzorky signálu
                           Position_S=[Position_S,4999];
                           A=length(window_S);
                           else
                           Position_S=[Position_S,Position_R(I)+A+H1(1)];
                           A=length(window_S);
                           end
                        end
                      end
                end
    
            else
                window_S=ECGDER(j,(Position_R(I)+10:Position_R(I+1))); %Stanovujeme si okno pro hledání S kmitù
                A=2;
                while A<length(window_S) %Dokud pomocná "A" bude menší ne délka okna
                     if sign(window_S(A))==sign(window_S(A-1)) %Hledání crossing zeros v oknu
                        A=A+1;
                     else
                        [~,H1]=find(window_S(A:end)>0.03*Deteciton_rule_ECGDER(1,j)); %Nalezení vrcholu v oknì podle rozhodovacího pravidla
                        if isempty(H1) %Ošetøení pro prázdnou matici (tedy pokud nebude nadetekován, ádnı S kmit)
                           Position_S=[Position_S]; 
                           A=length(window_S);
                        else
                           Position_S=[Position_S,Position_R(I)+10+A+H1(1)];
                            A=length(window_S);
                        end
                     end
                end
            end
            %Detekujeme Q kmit
            if Position_R(I)-25<= 0 %Ošetøení konce signálu 
               window_Q=ECGDER(j,(1:Position_R(I)-1)); %Stanovujeme si okno pro hledání Q kmitù
               WINDOW_Q=fliplr(window_Q); %pøehození druhého okna (tak aby detekoval od konce)
            else
               window_Q=ECGDER(j,(Position_R(I)-25:Position_R(I)-1));
               WINDOW_Q=fliplr(window_Q); %pøehození druhého okna (tak aby detekoval od konce)
            end
            J=2;
            while J<length(WINDOW_Q) %Dokud pomocná "J" bude menší ne délka okna
                 if sign(WINDOW_Q(J))==sign(WINDOW_Q(J-1)) %Hledání crossing zeros v oknu
                    J=J+1;
                 else
                    [~,H2]=find(WINDOW_Q(J:end)>0.018*Deteciton_rule_ECGDER(1,j)); %Nalezení vrcholu v oknì podle rozhodovacího pravidla
                    if isempty(H2) %Ošetøení pro prázdnou matici (tedy pokud nebude nadetekován, ádnı Q kmit)
                        Position_Q=[Position_Q];
                        J=length(window_Q);
                    else
                        Position_Q=[Position_Q,Position_R(I)-H2(1)-J];
                        J=length(window_Q);
                    end
                 end
            end
        end 
        %Ošetøení prázdnıch svodù
        if isempty(Position_Q)
            if j==1
               Q{j,:}=Position_R; % Pokud nadetekuje absenci Q v prvním svodì, co fyziologicky není moné,
                                  % ale abychom ošetøili vıskyt rùznıch patologického signálu spuštìného tímto programem,
                                  % tak bereme místo toho hodnoty pozic R
            else
               Q{j,:}=Q{j-1,:};   % Pokud nadetekuje absenci Q v jinıch svodech ne prvním, co je 
                                  % fyziologicky moné, tak bereme místo nich hodnoty ze svodu pøed ním
            end
        else
            Q{j,:}=Position_Q; %Kdy nebude prázdnı tak do struktury v Q uloím pozici Q 
        end
        R{j,:}=Position_R; %Do struktury, R ukládám pozice R, které se vdy nadetekuji, a u správné èi špatné
        if isempty(Position_S); 
            if j==1 %Ošetøení prázdného prvního svodu (analogicky jako u Q kmitu)
                S{j,:}=Position_R(:);   
            else
                S{j,:}=S{j-1,:};
            end
        else
            S{j,:}=Position_S;
        end
    %Na závìr zjistíme kolik bylo QRS komplexù v kadém svodì    
    Sum_QRS(j,1)=length(Position_R);
    Sum_QRS(j,2)=length(Position_Q);
    Sum_QRS(j,3)=length(Position_S);
    end         
end