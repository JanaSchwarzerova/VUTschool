function [x15] = leads_15( jednotky)
% Funkce leads_15 vytv��� ze 3 svodov�ch a 12 svodov�ch sign�l�
% 15 svodov� sign�ly, na kter�ch m�me v projektu detekovat ur�it� pozice
% Vstupem funkce jsou jednotky, kter� se stejn� jako des�tky a stovky budou
% ve for cyklu m�nit od 1 do 125 abychom na�etli v�ech 125 sign�l�, kter�
% m�me analyzovat.
% V�stupek funkce je x15 co� je matice 1875x5000, ve kter� jsou po sob� jdouc�ch
% patn�cti ��dc�ch, v�dy jeden 15 svodov� sign�l, p�i�em� jeden svod je jeden ��dek.
% 1875:15 = 125  
desitky = 0;
x15 = [];
pom = 0; %O�et�en� at mi nejde sign�l MOx_000_xx.mat jeliko� takov� sign�l v datab�zi nem�m
    for stovky =0:1
     for desitky =0:9
         for jednotky=0:9
            if (stovky <= 1 && desitky <= 2 && jednotky <= 5) || stovky == 0 || (stovky <= 1 && desitky <= 0) || (stovky <= 1 && desitky <= 1)
                if pom == 0
                   pom = 1; 
                else
                signal_svod_3 = load(['MO1_' num2str(stovky) num2str(desitky) num2str(jednotky) '_03.mat']); %Na�ten� 3svodov�ho sign�lu
                x3 = signal_svod_3.x; %Vyta�en� sign�lu ze struktury

                signal_svod_12 = load(['MO1_' num2str(stovky) num2str(desitky) num2str(jednotky) '_12.mat']); %Na�ten� 12 svodov�ho sign�lu
                x12 = signal_svod_12.x; %Vyta�en� 12 svodov�ho sign�lu ze struktury
                
                x15 = [x15;x3;x12]; %Vytvo�en� 15 svodov�ho sign�lu
                end
            end
         end
     end  
    end
end

