function [ otazka_mat, vysledek_mat ] = generovani_cer_otazek( vstup_mat )
%Funkce generovani_cer_otazek
%Funkce m� jeden vekter na vstupu, kter� ur�uje, �e funkce prob�hne 
%A jeden vektor na v�stupu, ve kter�m bude ulo�en� ot�zka typu 'char' a
%druh� vektor na v�stupu, ve kter�m je ulo�en� odpov��, tak� typu char
if vstup_mat == 1                          
    i = 0;
    hod_mat = 0;
    for i=1:3       
         x = 1;                           %Ot�zky se generujou na principu, �e se t�ikr�t se�te 
         [ hod ] = hod_kostkou( x );      % hod kostkou,(jeliko� ke ka�d�mu t�matu jsem zvolila, 
         i = i + 1;                       % datab�zi o 16 ot�zk�ch) a z toho se potom pomoc� 
         hod_mat = hod_mat + hod;         % cyklu switch vygeneruje p��slu�n� ot�zka (v tomoto
    end                                   % p��pad� sp�e p��slu�n� p��klad)
    
    switch (hod_mat)
        case 3
            otazka_mat = ' 1 + 2 = ';
            vysledek_mat = '3';
        case 4
            otazka_mat = ' 3 + 2 = ';
            vysledek_mat = '5';
        case 5
            otazka_mat = ' 4 + 3 = ';
            vysledek_mat = '7';
        case 6 
            otazka_mat = ' 5 + 2 = ';
            vysledek_mat = '7';
        case 7 
            otazka_mat = ' 6 + 2 = ';
            vysledek_mat = '8';
        case 8 
            otazka_mat = ' 8 + 3 = ';
            vysledek_mat = '11';
        case 9
            otazka_mat = ' 9 + 1 = ';
            vysledek_mat = '10';
        case 10
            otazka_mat = ' 5 + 8 = ';
            vysledek_mat = '13';
        case 11
            otazka_mat = ' 6 + 3 = ';
            vysledek_mat = '9';
        case 12
            otazka_mat = ' 7 + 3 = ';
            vysledek_mat = '10';
        case 13
            otazka_mat = ' 5 + 3 = ';
            vysledek_mat = '8';
        case 14 
            otazka_mat = ' 6 + 4 = ';
            vysledek_mat = '10';
        case 15
            otazka_mat = ' 4 + 4 = ';
            vysledek_mat = '8';
        case 16
            otazka_mat = ' 5 + 5 = ';
            vysledek_mat = '10';
        case 17
            otazka_mat = ' 6 + 6 = ';
            vysledek_mat = '12';
        case 18  
            otazka_mat = ' 8 + 8 = ';
            vysledek_mat = '16';
    end
    
end   
end
 

