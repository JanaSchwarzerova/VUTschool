function [vystup] = Wiener_filtr_s_pilot(vstup)
% Funkce Wiener_filtr_s_pilot m� stejn� vlastnosti jako skript Projekt.m, 
% krom� po��t�n� SNR 
% vstupem je:  vstup  ... za�um�l� sign�l
% v�stupem je: vystup ... vyfiltrovan� sign�l 

vstup = [vstup vstup(end)*ones(1,8)]; %P�edzpracov�n� pot�ebun� pro stupe� 
                                      %rozkladu 4 (kter� pro optimalizaci 
                                      %algoritmu vych�zel nejl�pe)

%% BLOK WT1 - aplikace DTWT ***********************************************
wname_1 = 'coif1';   %Typ pou�it� vlnky pro prvn� pou�itou DTWT 
N_1 = 4;             %Stupe� rozkladu pro prvn� pou�itou DTWT 
SWC =swt(vstup,N_1,wname_1); %Rozklad DTWT

%% BLOK H *****************************************************************
%Mo�nost vybr�n� podle v�ce parametr�:
K = 3.8;              %Pomocn� konstanta pro v�po�et empirick�ho prahu
prah_1 = 'Median';    %Median pro v�po�et prahu pomoc� medi�nu,
                      %dal�� mo�nost 'Std' pro v�po�et prahu pomoc�
                      %sm�rodatn� odchylky
prah_2 = 'E';         % 'E' v�po�et empirick�ho prahu
                      % nebo 'U' v�po�et univerz�ln�ho prahu
pom = 'G'; %pom zna�� jak� typ prahov�n� chceme pou��t:
              % 'G' prahov�n� Garrote
              % 'M' m�kk� prahov�n�
              % 'T' tvrd� prahov�n�
[SWC] = Prahovani(SWC,N_1,K,prah_1,prah_2,pom);

%% BLOK IWT1 - Zp�tn� transformace
p_s = iswt(SWC, wname_1); %Odhad

%% BLOK WT2 - aplikace DTWT ***********************************************
wname_2 ='bior1.5'; %Typ pou�it� vlnky pro druh� pou�� DTWT 
N_2 = 3;         %Stupe� rozkladu pro druh� pou�� DTWT 
% APLIKACE PRO PILOTN� ODHAD U�ITE�N�HO SIGN�LU
SWC_2_ps =swt(p_s,N_2,wname_2); %Rozklad 
% APLIKACE PRO VSTUPN� SIGN�L
SWC_2_ym =swt(vstup,N_2,wname_2); %Rozklad 

%% BLOK HW - N�soben� korela�n�mi �leny ***********************************

for m = 1:N_2 %Pro ka�d� rozlo�en� p�smo 
sigma = std(SWC_2_ym(m,:)); %V�po�et rozptylu
w_ym(m,:) = SWC_2_ym(m,:).*(((SWC_2_ps(m,:)).^(2))./((SWC_2_ps(m,:).^(2))+(sigma^(2))));
end
w_ym(m+1,:) = SWC_2_ym(m+1,:);

%% BLOK IWT2 - Zp�tn� transformace
vystup = iswt(w_ym, wname_2); %Odhad
vystup = vystup(1:5000);

end
