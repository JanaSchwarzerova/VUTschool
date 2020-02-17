%Hra 'Dožene tì pøíšera' spoèívá v následujícím principu
%Matlab 2015b
% Máte panáèka, muže èi ženu, v další pøípadì oba a házíte kostkou. Jakmile
% udìláte tøi tahy vyjede za Vámi hrùzostrašný Roshan (pokud hrajete za dva,
% tak máte dohromady tahù šest), který jakmile Vás chytí tak vás sežere, 
% tím pádem ztrácíte jeden život a zaèínáte odznova,
% Roshan už ale chodí dokola a snaží se Vás zase chytit (taky jezdí na
% principu hod kostkou) dohromady máte tøi životy na zaèátku hry. Pokud se
% dostanete do domeèku a Roshan Vás nechytí vyhráli jste. 
% Samozøejmì cesta domù není jen tak, po cestì jsou na vás na urèitých
% políècích pøipraveny rùzné otázky, které musíte správì odpovìdìt, pokud
% odpovíte špatnì, tak se vrátíte o 3 políèek zpìt.
% U posledních tøech polích ve høe, na nichž jsou tzv. "Bonusové" otázky 
% dokonce o 10 polí zpìt. 
% Tato hra jde hrát i ve více lidech, pøièemž pravidla se vùbec neliší.
% Ten kdo je první v domeèku vyhrává. 
% Upozornìní, nespìchejte s hodem kostkou!!! 


pocet_hracu = input('Napiš zda bude hrát jeden (piš 1) nebo dva (piš 2) hráèi: ', 's'); %Zvolení kolik hráèù bude hrát
switch (pocet_hracu)
    case '1'        %Když zvolíš jednoho hráèe tak máš navýbìr ze tøí možností
    typ_hry = input('Napiš M zda chceš hrát za muže, Ž za ženu, anebo obojí najednou MŽ: ', 's'); 
    switch (typ_hry)
            case 'M' %Mùžeš hrát jen za chlapa
            prisera_te_dohoni
            case 'Ž' %Mùžeš hrát jen za ženu
            prisera_te_dohoni_zena
            case 'MŽ' %Mužeš hrát i za chlapa i za ženu, vpravo jsou tlaèítka pro výbìr hráèe
                      %vždy zvolíš hráèe, se kterým chceš jet a pak klikneš
                      %na hod kostkou, pokud tak neuèiníš pojede ten
                      %panáèek, na kterého jsi klikl jako na posledního
            prisera_te_dohoni_jeden_za_dva
            otherwise %Ošetøení, když nìkdo zvolí uplnì nìco jiného
            disp('Nezvolili jste nic z uvedené nabídky a to znamená, že máte smùlu.')
    end
    case '2' %Ovladání je velmi jednoduché, první hráè klikne na kostku, druhý hráè klikne na kostku atd. 
             %Samozøejme, jestli hráè klikne a kostku vyskoè mu
             %otázka má na ní odpovìd hráè, který klikal jako poslední na
             %kostku
    prisera_te_dohoni_kluk_vs_holka    
    otherwise
        disp('Nezvolili jste nic z uvedené nabídky a to znamená, že máte smùlu.')   
end

