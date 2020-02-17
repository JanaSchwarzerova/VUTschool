function [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule)
%Funkce Detection_Pwave má za úkol detekovat zaèátek a konce vlny P
%Vstupy funkcí jsou: DERFI - pøefiltrovanı derivovanı signál 
%                    signal - pøefiltrovnı pùvodní signál
%                    leads – poèet svodù
%                    Sum_QRS - poèet QRS komplexù
%                    Q - struktura, ve které jsou uloené detekované Q kmity
%                    P_Detection_rule - Rozhodovací pravidlo pro P vlnu
%Vıstup funkce bude: P_onset - struktura, ve které budou zaèátky P vln
%                    P_end - struktura, ve které budou konce P vln

    Interval=round((0.255/10)*5000); %Interval, je èasovı úsek, podle kterého budeme detekovat
                                     %hodnota 255 ms je z èlánku k Projektu 17
    window=round(((0.155/10)*5000)/2);%Pomocí okna budeme procházet interval
                                      %délka okna 155 ms je z èlánku k Projektu 17
    i=2;        
    for j=1:leads %Procházíme všechny svody
       Position_P=[];      %Urèení prázné matice pro P vlnu
       Position_Ponset=[]; %Urèení prázné matice pro zaèátek P vlny
       Position_Pend=[];   %Urèení prázdné matice pro konec P vlny

       %% První najdeme pík vlny P
       for i=1:Sum_QRS(j,2) %Cyklus projde všechny QRS komplexy v kadém svodì vzláš
           if Q{j}(i)<=Interval
              window_0=signal(j,1:Q{j}(i)); %Vytvoøení okna pro detekci P vln pomocí kmitu Q
           else
              window_0=signal(j,(Q{j}(i)-Interval):Q{j}(i));
           end
           [~,P]=max(window_0); %Nalezení maxima -> tedy píku vlny P
           Position_P=[Position_P,Q{j}(i)-length(window_0)+P]; %Pozice vlny P
       end
       i=2; %Upravujeme "i" pro další svod (aby zaèal opìt od zaèátku)
       %% Hledáme konce P vlny
       for I=1:length(Position_P) %Procházíme všechny nadetekované píky vln P
           if Position_P(I)+window>=4999 %Ošetøení konce signálu (kdy bude okno delší ne zbytek signálu, kterı má projít)
              window_0=DERFI(j,(Position_P(I):end));%Vytvoøení prvního okna pro detekci konce P vlny
                                                  %Okno bude procházet od pozice P do konce
           else
              window_0=DERFI(j,(Position_P(I):Position_P(I)+window));%Okno bude procházet jen svou délku okna
           end
           A=2;
           while A<length(window_0) %Procházíme okno
                 if window_0(A)>0.015*P_Deteciton_rule
                    A=A+1;
                 else
                    Position_Pend=[Position_Pend,Position_P(I)+A];
                    A=length(window_0);
                 end
           end
            %% Hledáme zaèátek P vlny
           if Position_P(I)<=window
              window_1=DERFI(j,(1:Position_P(I)-1)); %Vytvoøení druhého okna pro detekci zaèátku P vlny
           else
              window_1=DERFI(j,(Position_P(I)-window:Position_P(I)-1));
           end
           J=2;
           while J<length(window_1) %Procházíme okno
                if window_1(J)>0.0135*P_Deteciton_rule %Podmínka pro rozhodovací pravidlo pro zaèátek P vlny
                                                       %hodnota 1,35% je z èlánku  
                   J=J+1;
                else
                   Position_Ponset=[Position_Ponset,Position_P(I)-length(window_1)+J];
                   J=length(window_1);
                end
           end
           J=2;
       end 
       %Ošetøení prázdnıch svodù
       if isempty(Position_Ponset)
          if j==1; %Ošetøení pro první svod
             P_onset{j,:}=Position_P(:);
          else 
             P_onset{j,:}=P_onset{j-1,:};
          end
       else %Kdy nebude prázdnı tak do struktury v P_onset uloím pozici zaèátku vlny P
          P_onset{j,:}=Position_Ponset;
       end
       if isempty(Position_Pend)
          if j==1 %Ošetøení pro první svod
          P_end{j,:}=Position_P(:);
          else
          P_end{j,:}=P_end{j-1,:};
          end
       else
          P_end{j,:}=Position_Pend; 
       end
	end 
        
end