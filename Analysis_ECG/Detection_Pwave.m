function [P_onset,P_end] = Detection_Pwave(DERFI,signal,leads,Sum_QRS,Q,P_Deteciton_rule)
%Funkce Detection_Pwave m� za �kol detekovat za��tek a konce vlny P
%Vstupy funkc� jsou: DERFI - p�efiltrovan� derivovan� sign�l 
%                    signal - p�efiltrovn� p�vodn� sign�l
%                    leads � po�et svod�
%                    Sum_QRS - po�et QRS komplex�
%                    Q - struktura, ve kter� jsou ulo�en� detekovan� Q kmity
%                    P_Detection_rule - Rozhodovac� pravidlo pro P vlnu
%V�stup funkce bude: P_onset - struktura, ve kter� budou za��tky P vln
%                    P_end - struktura, ve kter� budou konce P vln

    Interval=round((0.255/10)*5000); %Interval, je �asov� �sek, podle kter�ho budeme detekovat
                                     %hodnota 255 ms je z �l�nku k Projektu 17
    window=round(((0.155/10)*5000)/2);%Pomoc� okna budeme proch�zet interval
                                      %d�lka okna 155 ms je z �l�nku k Projektu 17
    i=2;        
    for j=1:leads %Proch�z�me v�echny svody
       Position_P=[];      %Ur�en� pr�zn� matice pro P vlnu
       Position_Ponset=[]; %Ur�en� pr�zn� matice pro za��tek P vlny
       Position_Pend=[];   %Ur�en� pr�zdn� matice pro konec P vlny

       %% Prvn� najdeme p�k vlny P
       for i=1:Sum_QRS(j,2) %Cyklus projde v�echny QRS komplexy v ka�d�m svod� vzl᚝
           if Q{j}(i)<=Interval
              window_0=signal(j,1:Q{j}(i)); %Vytvo�en� okna pro detekci P vln pomoc� kmitu Q
           else
              window_0=signal(j,(Q{j}(i)-Interval):Q{j}(i));
           end
           [~,P]=max(window_0); %Nalezen� maxima -> tedy p�ku vlny P
           Position_P=[Position_P,Q{j}(i)-length(window_0)+P]; %Pozice vlny P
       end
       i=2; %Upravujeme "i" pro dal�� svod (aby za�al op�t od za��tku)
       %% Hled�me konce P vlny
       for I=1:length(Position_P) %Proch�z�me v�echny nadetekovan� p�ky vln P
           if Position_P(I)+window>=4999 %O�et�en� konce sign�lu (kdy� bude okno del�� ne� zbytek sign�lu, kter� m� proj�t)
              window_0=DERFI(j,(Position_P(I):end));%Vytvo�en� prvn�ho okna pro detekci konce P vlny
                                                  %Okno bude proch�zet od pozice P do konce
           else
              window_0=DERFI(j,(Position_P(I):Position_P(I)+window));%Okno bude proch�zet jen svou d�lku okna
           end
           A=2;
           while A<length(window_0) %Proch�z�me okno
                 if window_0(A)>0.015*P_Deteciton_rule
                    A=A+1;
                 else
                    Position_Pend=[Position_Pend,Position_P(I)+A];
                    A=length(window_0);
                 end
           end
            %% Hled�me za��tek P vlny
           if Position_P(I)<=window
              window_1=DERFI(j,(1:Position_P(I)-1)); %Vytvo�en� druh�ho okna pro detekci za��tku P vlny
           else
              window_1=DERFI(j,(Position_P(I)-window:Position_P(I)-1));
           end
           J=2;
           while J<length(window_1) %Proch�z�me okno
                if window_1(J)>0.0135*P_Deteciton_rule %Podm�nka pro rozhodovac� pravidlo pro za��tek P vlny
                                                       %hodnota 1,35% je z �l�nku  
                   J=J+1;
                else
                   Position_Ponset=[Position_Ponset,Position_P(I)-length(window_1)+J];
                   J=length(window_1);
                end
           end
           J=2;
       end 
       %O�et�en� pr�zdn�ch svod�
       if isempty(Position_Ponset)
          if j==1; %O�et�en� pro prvn� svod
             P_onset{j,:}=Position_P(:);
          else 
             P_onset{j,:}=P_onset{j-1,:};
          end
       else %Kdy� nebude pr�zdn� tak do struktury v P_onset ulo��m pozici za��tku vlny P
          P_onset{j,:}=Position_Ponset;
       end
       if isempty(Position_Pend)
          if j==1 %O�et�en� pro prvn� svod
          P_end{j,:}=Position_P(:);
          else
          P_end{j,:}=P_end{j-1,:};
          end
       else
          P_end{j,:}=Position_Pend; 
       end
	end 
        
end