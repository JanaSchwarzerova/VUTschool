function [ otazka_bonus, odpoved1_bonus, odpoved2_bonus, odpoved3_bonus, vysledek_bonus ] = generovani_zlu_otazek( vstup_bonus )
%Funkce generovani_zlu_otazek
%Funkce má jeden vekter na vstupu, který urèuje, že funkce probìhne 
%A èyøi vektor na výstupu, ve kterém bude uložena otázka typu 'char' + tøi
%odpovìdi také typu 'char'
%odpovìdi také typu 'char' + která odpovìd byla správná
if vstup_bonus == 1                          
    i = 0;
    hod_bonus = 0;
    for i=1:3       
         x = 1;                           %Otázky se generujou na principu, že se tøikrát seète 
         [ hod ] = hod_kostkou( x );      % hod kostkou,(jelikož ke každému tématu jsem zvolila, 
         i = i + 1;                       % databázi o 16 otázkách) a z toho se potom pomocí 
         hod_bonus = hod_bonus + hod;     % cyklu switch vygeneruje pøíslušnou otázku + odpovìdi
    end
    
    switch (hod_bonus)
        case 3
            otazka_bonus = 'Jaký je pøíkaz, který vykreslí obrázek?';
            odpoved1_bonus = 'Break';
            odpoved2_bonus = 'Return';
            odpoved3_bonus = 'Plot';
            vysledek_bonus = 'Plot';
        case 4
            otazka_bonus = 'Jaký pøíkaz použijeme pro zaokrouhlování nahoru?';
            odpoved1_bonus = 'Ceil';
            odpoved2_bonus = 'Floor';
            odpoved3_bonus = 'Strintf';
            vysledek_bonus = 'Ceil';
        case 5
            otazka_bonus = 'Jaký pøíkaz použijeme pro zaokrouhlování dolù?';
             odpoved1_bonus = 'Ceil';
            odpoved2_bonus = 'Floor';
            odpoved3_bonus = 'Strintf';
            vysledek_bonus = 'Floor';
        case 6 
            otazka_bonus = 'Jaký pøíkaz nám vygeneruje nejvyšší hodnotu?';
            odpoved1_bonus = 'min';
            odpoved2_bonus = 'max';
            odpoved3_bonus = 'mean';
            vysledek_bonus = 'max';
        case 7 
            otazka_bonus = 'Pomocí jakého pøíkazu dokážeme vypisujeme hodnoty, èi vìty atd.?';
            odpoved1_bonus = 'disp';
            odpoved2_bonus = 'floor';
            odpoved3_bonus = 'min';
            vysledek_bonus = 'disp';
        case 8 
            otazka_bonus = 'Když víme poèet iterací, jaký cyklus obvykle použijeme?';
            odpoved1_bonus = 'for';
            odpoved2_bonus = 'while';
            odpoved3_bonus = 'žádná odpovìï není správná';
            vysledek_bonus = 'for';
        case 9
            otazka_bonus = 'Když víme pøi jaké podmínce se má cyklus provádìt,jaký cyklus použijeme ?';
            odpoved1_bonus = 'for';
            odpoved2_bonus = 'while';
            odpoved3_bonus = 'žádná odpovìï není správná';
            vysledek_bonus = 'while';
        case 10
            otazka_bonus = 'Co nepatøí mezi cykly?';
            odpoved1_bonus = 'if';
            odpoved2_bonus = 'for';
            odpoved3_bonus = 'while';
            vysledek_bonus = 'if';
        case 11
            otazka_bonus = 'Co patøí mezi cykly?';
            odpoved1_bonus = 'for';
            odpoved2_bonus = 'if';
            odpoved3_bonus = 'switch';
            vysledek_bonus = 'for';
        case 12
            otazka_bonus = 'Do kdy se provádí cyklus while?';
            odpoved1_bonus = 'Dokud neplatí podmínka';
            odpoved2_bonus = 'Dokud platí podmínka';
            odpoved3_bonus = 'Dokud nezaène pršet';
            vysledek_bonus = 'Dokud platí podmínka';
        case 13
            otazka_bonus = 'Když potøebujeme vyèistit workspace, jaký pøíkaz použijeme?';
            odpoved1_bonus = 'clc';
            odpoved2_bonus = 'clear all';
            odpoved3_bonus = 'mean';
            vysledek_bonus = 'clear all';
        case 14 
            otazka_bonus = 'Když potøebujeme vyèisti Command Window, jaký pøíkaz použijeme?';
            odpoved1_bonus = 'clc';
            odpoved2_bonus = 'max';
            odpoved3_bonus = 'min';
            vysledek_bonus = 'clc';
        case 15
            otazka_bonus = 'Když potøebujeme vypsat pouze realnou èást matice, jaký pøíkaz použijeme?';
            odpoved1_bonus = 'Žádný';
            odpoved2_bonus = 'real';
            odpoved3_bonus = 'min';
            vysledek_bonus = 'real';
        case 16
            otazka_bonus = 'Když chceme generovat náhodné èíslo od 0 do 1, jaký pøíkaz použijeme?';
            odpoved1_bonus = 'rand';
            odpoved2_bonus = 'clc';
            odpoved3_bonus = 'find';
            vysledek_bonus = 'rand';
        case 17
            otazka_bonus = 'Když potøebujeme všude ve vektoru vypsat nuly, jaký pøíkaz použijeme?';
            odpoved1_bonus = 'zeros';
            odpoved2_bonus = 'ones';
            odpoved3_bonus = 'plot';
            vysledek_bonus = 'zeros';
        case 18  
            otazka_bonus = 'Když potøebujeme všude ve vektoru vypsat jednièky, jaký pøíkaz použijeme?';
            odpoved1_bonus = 'plot';
            odpoved2_bonus = 'ones';
            odpoved3_bonus = 'zeros';
            vysledek_bonus = 'ones';
    end
    
    
end
 
end



