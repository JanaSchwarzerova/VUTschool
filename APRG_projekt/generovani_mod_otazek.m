function [ otazka_aj, odpoved1_aj, odpoved2_aj, odpoved3_aj, vysledek_aj ] = generovani_mod_otazek( vstup_aj )
%Funkce generovani_mod_otazek
%Funkce má jeden vekter na vstupu, který urèuje, že funkce probìhne 
%A pìt vektorù na výstupu, ve kterém bude uložena otázka typu 'char' + tøi
%odpovìdi také typu 'char' + která odpovìd byla správná
if vstup_aj == 1                          
    i = 0;
    hod_aj = 0;
    for i=1:3       
         x = 1;                           %Otázky se generujou na principu, že se tøikrát seète 
         [ hod ] = hod_kostkou( x );      % hod kostkou,(jelikož ke každému tématu jsem zvolila, 
         i = i + 1;                       % databázi o 16 otázkách) a z toho se potom pomocí 
         hod_aj = hod_aj + hod;           % cyklu switch vygeneruje pøíslušnou otázku + odpovìdi
    end
    
    switch (hod_aj)
        case 3
            otazka_aj = 'Jak se øekne anglicky zelená?';
            odpoved1_aj = 'Red';
            odpoved2_aj = 'Blue';
            odpoved3_aj = 'Green';
            vysledek_aj = 'Green'; 
        case 4
            otazka_aj = 'Jak se øekne anglicky žlutá?';
            odpoved1_aj = 'Red';
            odpoved2_aj = 'Yellow';
            odpoved3_aj = 'Green';
            vysledek_aj = 'Yellow';
        case 5
            otazka_aj = 'Jak se øekne anglicky èervená?';
            odpoved1_aj = 'Blue';
            odpoved2_aj = 'Red';
            odpoved3_aj = 'Green';
            vysledek_aj = 'Red';
        case 6 
            otazka_aj = 'Jak se øekne anglicky myš?';
            odpoved1_aj = 'Mouse';
            odpoved2_aj = 'Smile';
            odpoved3_aj = 'Dog';
            vysledek_aj = 'Mouse';
        case 7 
            otazka_aj = 'Jak se øekne anglicky pes?';
            odpoved1_aj = 'Mouse';
            odpoved2_aj = 'Dog';
            odpoved3_aj = 'Cat';
            vysledek_aj = 'Dog';
        case 8 
            otazka_aj = 'Jak se øekne anglicky koèka?';
            odpoved1_aj = 'Elephant';
            odpoved2_aj = 'Dog';
            odpoved3_aj = 'Cat';
            vysledek_aj = 'Cat';
        case 9
            otazka_aj = 'Jak se øekne anglicky jedna?';
            odpoved1_aj = 'Two';
            odpoved2_aj = 'One';
            odpoved3_aj = 'Four';
            vysledek_aj = 'One';
        case 10
            otazka_aj = 'Jak se øekne anglicky dva?';
            odpoved1_aj = 'One';
            odpoved2_aj = 'Five';
            odpoved3_aj = 'Two';
            vysledek_aj = 'Two';
        case 11
            otazka_aj = 'Jak se øekne anglicky tøi?';
            odpoved1_aj = 'Three';
            odpoved2_aj = 'Five';
            odpoved3_aj = 'Two';
            vysledek_aj = 'Three';
        case 12
            otazka_aj = 'Jak se øekne anglicky triko?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'Skrit';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'T-shirt';
        case 13
            otazka_aj = 'Jak se øekne anglicky kalhoty?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'Trousers';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'Trousers';
        case 14 
            otazka_aj = 'Jak se øekne anglicky šaty?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'Trousers';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'Dress';
        case 15
            otazka_aj = 'Jak se øekne anglicky mìsto?';
            odpoved1_aj = 'T-shirt';
            odpoved2_aj = 'City';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'City';
        case 16
            otazka_aj = 'Jak se øekne anglicky vesnice?';
            odpoved1_aj = 'Post';
            odpoved2_aj = 'City';
            odpoved3_aj = 'Village';
            vysledek_aj = 'Village';
        case 17
            otazka_aj = 'Jak se øekne anglicky kino?';
            odpoved1_aj = 'Cinema';
            odpoved2_aj = 'City';
            odpoved3_aj = 'Dress';
            vysledek_aj = 'Cinema';
        case 18 
            otazka_aj = 'Jak se øekne anglicky kniha?';
            odpoved1_aj = 'Post';
            odpoved2_aj = 'Book';
            odpoved3_aj = 'Village';
            vysledek_aj = 'Book';
    end
  end
end

