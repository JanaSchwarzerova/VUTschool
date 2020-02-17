function [x15] = leads_15( jednotky)
% Funkce leads_15 vytváøí ze 3 svodových a 12 svodových signálù
% 15 svodové signály, na kterých máme v projektu detekovat urèité pozice
% Vstupem funkce jsou jednotky, které se stejnì jako desítky a stovky budou
% ve for cyklu mìnit od 1 do 125 abychom naèetli všech 125 signálù, které
% máme analyzovat.
% Výstupek funkce je x15 což je matice 1875x5000, ve které jsou po sobì jdoucích
% patnácti øádcích, vždy jeden 15 svodový signál, pøièemž jeden svod je jeden øádek.
% 1875:15 = 125  
desitky = 0;
x15 = [];
pom = 0; %Ošetøení at mi nejde signál MOx_000_xx.mat jelikož takový signál v databázi nemám
    for stovky =0:1
     for desitky =0:9
         for jednotky=0:9
            if (stovky <= 1 && desitky <= 2 && jednotky <= 5) || stovky == 0 || (stovky <= 1 && desitky <= 0) || (stovky <= 1 && desitky <= 1)
                if pom == 0
                   pom = 1; 
                else
                signal_svod_3 = load(['MO1_' num2str(stovky) num2str(desitky) num2str(jednotky) '_03.mat']); %Naètení 3svodového signálu
                x3 = signal_svod_3.x; %Vytažení signálu ze struktury

                signal_svod_12 = load(['MO1_' num2str(stovky) num2str(desitky) num2str(jednotky) '_12.mat']); %Naètení 12 svodového signálu
                x12 = signal_svod_12.x; %Vytažení 12 svodového signálu ze struktury
                
                x15 = [x15;x3;x12]; %Vytvoøení 15 svodového signálu
                end
            end
         end
     end  
    end
end

