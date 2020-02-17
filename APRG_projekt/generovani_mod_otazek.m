function [ otazka_aj, odpoved1_aj, odpoved2_aj, odpoved3_aj, vysledek_aj ] = generovani_mod_otazek( vstup_aj )
%Funkce generovani_mod_otazek
%Funkce m� jeden vekter na vstupu, kter� ur�uje, �e funkce prob�hne 
%A p�t vektor� na v�stupu, ve kter�m bude ulo�ena ot�zka typu 'char' + t�i
%odpov�di tak� typu 'char' + kter� odpov�d byla spr�vn�
if vstup_aj == 1                          
    i = 0;
    hod_aj = 0;
    for i=1:3       
         x = 1;                           %Ot�zky se generujou na principu, �e se t�ikr�t se�te 
         [ hod ] = hod_kostkou( x );      % hod kostkou,(jeliko� ke ka�d�mu t�matu jsem zvolila, 
         i = i + 1;                       % datab�zi o 16 ot�zk�ch) a z toho se potom pomoc� 
         hod_aj = hod_aj + hod;           % cyklu switch vygeneruje p��slu�nou ot�zku + odpov�di
    end
    
    switch (hod_aj)
        case 3
            otazka_aj = 'Jak se �ekne anglicky zelen�?';
            odpoved1_aj = 'Red';
            odpoved2_aj = 'Blue';
            odpoved3_aj = 'Green';
            vysledek_aj = 'Green'; 
        case 4
            otazka_aj = 'Jak se �ekne anglicky �lut�?';
            odpoved1_aj = 'Red';
            odpoved2_aj = 'Yellow';
            odpoved3_aj = 'Green';
            vysledek_aj = 'Yellow';
        case 5
            otazka_aj = 'Jak se �ekne anglicky �erven�?';
            odpoved1_aj = 'Blue';
            odpoved2_aj = 'Red';
            odpoved3_aj = 'Green';
            vysledek_aj = 'Red';
        case 6 
            otazka_aj = 'Jak se �ekne anglicky my�?';
            odpoved1_aj = 'Mouse';
            odpoved2_aj = 'Smile';
            odpoved3_aj = 'Dog';
            vysledek_aj = 'Mouse';
        case 7 
            otazka_aj = 'Jak se �ekne anglicky pes?';
            odpoved1_aj = 'Mouse';
            odpoved2_aj = 'Dog';
            odpoved3_aj = 'Cat';
            vysledek_aj = 'Dog';
        case 8 
            otazka_aj = 'Jak se �ekne anglicky ko�ka?';
            odpoved1_aj = 'Elephant';
            odpoved2_aj = 'Dog';
            odpoved3_aj = 'Cat';
            vysledek_aj = 'Cat';
        case 9
            otazka_aj = 'Jak se �ekne anglicky jedna?';
            odpoved1_aj = 'Two';
            odpoved2_aj = 'One';
            odpoved3_aj = 'Four';
            vysledek_aj = 'One';
        case 10
            otazka_aj = 'Jak se �ekne anglicky dva?';
            odpoved1_aj = 'One';
            odpoved2_aj = 'Five';
            odpoved3_aj = 'Two';
            vysledek_aj = 'Two';
        case 11
            otazka_aj = 'Jak se �ekne anglicky t�i?';
            odpoved1_aj = 'Three';
            odpoved2_aj = 'Five';
            odpoved3_aj = 'Two';
            vysledek_aj = 'Three';
        case 12
            otazka_aj = 'Jak se �ekne anglicky triko?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'Skrit';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'T-shirt';
        case 13
            otazka_aj = 'Jak se �ekne anglicky kalhoty?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'Trousers';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'Trousers';
        case 14 
            otazka_aj = 'Jak se �ekne anglicky �aty?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'Trousers';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'Dress';
        case 15
            otazka_aj = 'Jak se �ekne anglicky m�sto?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'City';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'City';
        case 16
            otazka_aj = 'Jak se �ekne anglicky vesnice?';
            odpoved1_aj = 'Post';
            odpoved2_aj = 'City';
            odpoved3_aj = 'Village';
            vysledek_aj = 'Village';
        case 17
            otazka_aj = 'Jak se �ekne anglicky kino?';
            odpoved1_aj = 'Cinema';
            odpoved2_aj = 'City';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'Cinema';
        case 18 
            otazka_aj = 'Jak se �ekne anglicky kniha?';
            odpoved1_aj = 'Post';
            odpoved2_aj = 'Book';
            odpoved3_aj = 'Village';
            vysledek_aj = 'Book';
    end
  end
end

