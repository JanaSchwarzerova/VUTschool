function [ otazka_bonus, odpoved1_bonus, odpoved2_bonus, odpoved3_bonus, vysledek_bonus ] = generovani_zlu_otazek( vstup_bonus )
%Funkce generovani_zlu_otazek
%Funkce m� jeden vekter na vstupu, kter� ur�uje, �e funkce prob�hne 
%A �y�i vektor na v�stupu, ve kter�m bude ulo�ena ot�zka typu 'char' + t�i
%odpov�di tak� typu 'char'
%odpov�di tak� typu 'char' + kter� odpov�d byla spr�vn�
if vstup_bonus == 1                          
    i = 0;
    hod_bonus = 0;
    for i=1:3       
         x = 1;                           %Ot�zky se generujou na principu, �e se t�ikr�t se�te 
         [ hod ] = hod_kostkou( x );      % hod kostkou,(jeliko� ke ka�d�mu t�matu jsem zvolila, 
         i = i + 1;                       % datab�zi o 16 ot�zk�ch) a z toho se potom pomoc� 
         hod_bonus = hod_bonus + hod;     % cyklu switch vygeneruje p��slu�nou ot�zku + odpov�di
    end
    
    switch (hod_bonus)
        case 3
            otazka_bonus = 'Jak� je p��kaz, kter� vykresl� obr�zek?';
            odpoved1_bonus = 'Break';
            odpoved2_bonus = 'Return';
            odpoved3_bonus = 'Plot';
            vysledek_bonus = 'Plot';
        case 4
            otazka_bonus = 'Jak� p��kaz pou�ijeme pro zaokrouhlov�n� nahoru?';
            odpoved1_bonus = 'Ceil';
            odpoved2_bonus = 'Floor';
            odpoved3_bonus = 'Strintf';
            vysledek_bonus = 'Ceil';
        case 5
            otazka_bonus = 'Jak� p��kaz pou�ijeme pro zaokrouhlov�n� dol�?';
             odpoved1_bonus = 'Ceil';
            odpoved2_bonus = 'Floor';
            odpoved3_bonus = 'Strintf';
            vysledek_bonus = 'Floor';
        case 6 
            otazka_bonus = 'Jak� p��kaz n�m vygeneruje nejvy��� hodnotu?';
            odpoved1_bonus = 'min';
            odpoved2_bonus = 'max';
            odpoved3_bonus = 'mean';
            vysledek_bonus = 'max';
        case 7 
            otazka_bonus = 'Pomoc� jak�ho p��kazu dok�eme vypisujeme hodnoty, �i v�ty atd.?';
            odpoved1_bonus = 'disp';
            odpoved2_bonus = 'floor';
            odpoved3_bonus = 'min';
            vysledek_bonus = 'disp';
        case 8 
            otazka_bonus = 'Kdy� v�me po�et iterac�, jak� cyklus obvykle pou�ijeme?';
            odpoved1_bonus = 'for';
            odpoved2_bonus = 'while';
            odpoved3_bonus = '��dn� odpov�� nen� spr�vn�';
            vysledek_bonus = 'for';
        case 9
            otazka_bonus = 'Kdy� v�me p�i jak� podm�nce se m� cyklus prov�d�t,jak� cyklus pou�ijeme ?';
            odpoved1_bonus = 'for';
            odpoved2_bonus = 'while';
            odpoved3_bonus = '��dn� odpov�� nen� spr�vn�';
            vysledek_bonus = 'while';
        case 10
            otazka_bonus = 'Co nepat�� mezi cykly?';
            odpoved1_bonus = 'if';
            odpoved2_bonus = 'for';
            odpoved3_bonus = 'while';
            vysledek_bonus = 'if';
        case 11
            otazka_bonus = 'Co pat�� mezi cykly?';
            odpoved1_bonus = 'for';
            odpoved2_bonus = 'if';
            odpoved3_bonus = 'switch';
            vysledek_bonus = 'for';
        case 12
            otazka_bonus = 'Do kdy se prov�d� cyklus while?';
            odpoved1_bonus = 'Dokud neplat� podm�nka';
            odpoved2_bonus = 'Dokud plat� podm�nka';
            odpoved3_bonus = 'Dokud neza�ne pr�et';
            vysledek_bonus = 'Dokud plat� podm�nka';
        case 13
            otazka_bonus = 'Kdy� pot�ebujeme vy�istit workspace, jak� p��kaz pou�ijeme?';
            odpoved1_bonus = 'clc';
            odpoved2_bonus = 'clear all';
            odpoved3_bonus = 'mean';
            vysledek_bonus = 'clear all';
        case 14 
            otazka_bonus = 'Kdy� pot�ebujeme vy�isti Command Window, jak� p��kaz pou�ijeme?';
            odpoved1_bonus = 'clc';
            odpoved2_bonus = 'max';
            odpoved3_bonus = 'min';
            vysledek_bonus = 'clc';
        case 15
            otazka_bonus = 'Kdy� pot�ebujeme vypsat pouze realnou ��st matice, jak� p��kaz pou�ijeme?';
            odpoved1_bonus = '��dn�';
            odpoved2_bonus = 'real';
            odpoved3_bonus = 'min';
            vysledek_bonus = 'real';
        case 16
            otazka_bonus = 'Kdy� chceme generovat n�hodn� ��slo od 0 do 1, jak� p��kaz pou�ijeme?';
            odpoved1_bonus = 'rand';
            odpoved2_bonus = 'clc';
            odpoved3_bonus = 'find';
            vysledek_bonus = 'rand';
        case 17
            otazka_bonus = 'Kdy� pot�ebujeme v�ude ve vektoru vypsat nuly, jak� p��kaz pou�ijeme?';
            odpoved1_bonus = 'zeros';
            odpoved2_bonus = 'ones';
            odpoved3_bonus = 'plot';
            vysledek_bonus = 'zeros';
        case 18  
            otazka_bonus = 'Kdy� pot�ebujeme v�ude ve vektoru vypsat jedni�ky, jak� p��kaz pou�ijeme?';
            odpoved1_bonus = 'plot';
            odpoved2_bonus = 'ones';
            odpoved3_bonus = 'zeros';
            vysledek_bonus = 'ones';
    end
    
    
end
 
end



