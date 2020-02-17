function [R,Q,S,Sum_QRS] = Detection_QRS( ECGDER,signal,leads,Deteciton_rule_ECGDER)
%Funkce Detection_QRS m� za �kol detekovat kmity Q, R a S.
%Vstupy funkc� jsou: ECGDER - derivovan� sign�l 
%                    signal - p�efiltrovn� p�vodn� sign�l
%                    leads � po�et svod�
%                    QRS_r
%V�stup funkce bude: R - struktura, ve kter� budou ulo�en� pozice R kmit�
%                    Q - struktura, ve kter� budou ulo�en� pozice Q kmit�
%                    S - struktura, ve kter� budou ulo�en� pozice S kmit�
physiological_interval=round((0.7/10)*5000); %Maximalna tepova frekvencia.
                                                %Je to je minim�ln� fyziologick� hranice, 
                                                %pro d�lu RR intervalu
                                    %% !!! Pokud si physiological_interval uprav�te na hodnotu
                                     %     physiological_interval=round((0.38/10)*5000)
                                     %     v�jdou V�m hodnoty, kter� jsou uveden� 
                                     %     v Tabulce 3. v dokumentaci (�l�nku) k projektu
                                   
    for j=1:leads 
       Position_R=[];   %Ur�ov�n� pr�zdn�ch matic pro pozici R kmitu
       Position_S=[];   %Ur�ov�n� pr�zdn�ch matic pro pozici S kmitu
       Position_Q=[];   %Ur�ov�n� pr�zdn�ch matic pro pozici Q kmitu

        %% Detekce kmitu R
        [~,Position_R]=findpeaks(signal(j,:),'MinPeakDistance',physiological_interval);
        for I=1:length(Position_R) %pocet pozicii QRS
            %% Detekce kmitu S a Q
            %Detekujeme S kmit
            if I==length(Position_R) %O�et�en�, kdy� se nadetekuje hned prvn� S vlna �patn�
                                     %aby se nenadetekovaly v�echny S vlny
                                     %�patn�   
                window_S=ECGDER(j,(Position_R(I):end)); %Stanovujeme si okno pro hled�n� S kmit�
                A=2;
                while A<length(window_S) %Dokud pomocn� "A" bude men�� ne� d�lka okna
                      if sign(window_S(A))==sign(window_S(A-1))%Hled�n� crossing zeros v oknu
                         A=A+1;
                      else
                        [~,H1]=find(window_S(A:end)>0.03*Deteciton_rule_ECGDER(1,j));%Nalezen� vrcholu v okn� podle rozhodovac�ho pravidla
                        if isempty(H1) %O�et�en� pro pr�zdnou matici (tedy pokud nebude nadetekov�n, ��dn� S kmit)
                           Position_S=[Position_S];
                           A=length(window_S);
                        else
                           if Position_R(I)+A+H1(1) > 4999 %O�et�en�, abychom nep�es�hly vzorky sign�lu
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
                window_S=ECGDER(j,(Position_R(I)+10:Position_R(I+1))); %Stanovujeme si okno pro hled�n� S kmit�
                A=2;
                while A<length(window_S) %Dokud pomocn� "A" bude men�� ne� d�lka okna
                     if sign(window_S(A))==sign(window_S(A-1)) %Hled�n� crossing zeros v oknu
                        A=A+1;
                     else
                        [~,H1]=find(window_S(A:end)>0.03*Deteciton_rule_ECGDER(1,j)); %Nalezen� vrcholu v okn� podle rozhodovac�ho pravidla
                        if isempty(H1) %O�et�en� pro pr�zdnou matici (tedy pokud nebude nadetekov�n, ��dn� S kmit)
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
            if Position_R(I)-25<= 0 %O�et�en� konce sign�lu 
               window_Q=ECGDER(j,(1:Position_R(I)-1)); %Stanovujeme si okno pro hled�n� Q kmit�
               WINDOW_Q=fliplr(window_Q); %p�ehozen� druh�ho okna (tak aby detekoval od konce)
            else
               window_Q=ECGDER(j,(Position_R(I)-25:Position_R(I)-1));
               WINDOW_Q=fliplr(window_Q); %p�ehozen� druh�ho okna (tak aby detekoval od konce)
            end
            J=2;
            while J<length(WINDOW_Q) %Dokud pomocn� "J" bude men�� ne� d�lka okna
                 if sign(WINDOW_Q(J))==sign(WINDOW_Q(J-1)) %Hled�n� crossing zeros v oknu
                    J=J+1;
                 else
                    [~,H2]=find(WINDOW_Q(J:end)>0.018*Deteciton_rule_ECGDER(1,j)); %Nalezen� vrcholu v okn� podle rozhodovac�ho pravidla
                    if isempty(H2) %O�et�en� pro pr�zdnou matici (tedy pokud nebude nadetekov�n, ��dn� Q kmit)
                        Position_Q=[Position_Q];
                        J=length(window_Q);
                    else
                        Position_Q=[Position_Q,Position_R(I)-H2(1)-J];
                        J=length(window_Q);
                    end
                 end
            end
        end 
        %O�et�en� pr�zdn�ch svod�
        if isempty(Position_Q)
            if j==1
               Q{j,:}=Position_R; % Pokud nadetekuje absenci Q v prvn�m svod�, co� fyziologicky nen� mo�n�,
                                  % ale abychom o�et�ili v�skyt r�zn�ch patologick�ho sign�lu spu�t�n�ho t�mto programem,
                                  % tak bereme m�sto toho hodnoty pozic R
            else
               Q{j,:}=Q{j-1,:};   % Pokud nadetekuje absenci Q v jin�ch svodech ne� prvn�m, co� je 
                                  % fyziologicky mo�n�, tak bereme m�sto nich hodnoty ze svodu p�ed n�m
            end
        else
            Q{j,:}=Position_Q; %Kdy� nebude pr�zdn� tak do struktury v Q ulo��m pozici Q 
        end
        R{j,:}=Position_R; %Do struktury, R ukl�d�m pozice R, kter� se v�dy nadetekuji, a� u� spr�vn� �i �patn�
        if isempty(Position_S); 
            if j==1 %O�et�en� pr�zdn�ho prvn�ho svodu (analogicky jako u Q kmitu)
                S{j,:}=Position_R(:);   
            else
                S{j,:}=S{j-1,:};
            end
        else
            S{j,:}=Position_S;
        end
    %Na z�v�r zjist�me kolik bylo QRS komplex� v ka�d�m svod�    
    Sum_QRS(j,1)=length(Position_R);
    Sum_QRS(j,2)=length(Position_Q);
    Sum_QRS(j,3)=length(Position_S);
    end         
end