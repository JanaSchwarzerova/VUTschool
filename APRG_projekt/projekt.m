%Hra 'Do�ene t� p��era' spo��v� v n�sleduj�c�m principu
%Matlab 2015b
% M�te pan��ka, mu�e �i �enu, v dal�� p��pad� oba a h�z�te kostkou. Jakmile
% ud�l�te t�i tahy vyjede za V�mi hr�zostra�n� Roshan (pokud hrajete za dva,
% tak m�te dohromady tah� �est), kter� jakmile V�s chyt� tak v�s se�ere, 
% t�m p�dem ztr�c�te jeden �ivot a za��n�te odznova,
% Roshan u� ale chod� dokola a sna�� se V�s zase chytit (taky jezd� na
% principu hod kostkou) dohromady m�te t�i �ivoty na za��tku hry. Pokud se
% dostanete do dome�ku a Roshan V�s nechyt� vyhr�li jste. 
% Samoz�ejm� cesta dom� nen� jen tak, po cest� jsou na v�s na ur�it�ch
% pol��c�ch p�ipraveny r�zn� ot�zky, kter� mus�te spr�v� odpov�d�t, pokud
% odpov�te �patn�, tak se vr�t�te o 3 pol��ek zp�t.
% U posledn�ch t�ech pol�ch ve h�e, na nich� jsou tzv. "Bonusov�" ot�zky 
% dokonce o 10 pol� zp�t. 
% Tato hra jde hr�t i ve v�ce lidech, p�i�em� pravidla se v�bec neli��.
% Ten kdo je prvn� v dome�ku vyhr�v�. 
% Upozorn�n�, nesp�chejte s hodem kostkou!!! 


pocet_hracu = input('Napi� zda bude hr�t jeden (pi� 1) nebo dva (pi� 2) hr��i: ', 's'); %Zvolen� kolik hr��� bude hr�t
switch (pocet_hracu)
    case '1'        %Kdy� zvol� jednoho hr��e tak m� nav�b�r ze t�� mo�nost�
    typ_hry = input('Napi� M zda chce� hr�t za mu�e, � za �enu, anebo oboj� najednou M�: ', 's'); 
    switch (typ_hry)
            case 'M' %M��e� hr�t jen za chlapa
            prisera_te_dohoni
            case '�' %M��e� hr�t jen za �enu
            prisera_te_dohoni_zena
            case 'M�' %Mu�e� hr�t i za chlapa i za �enu, vpravo jsou tla��tka pro v�b�r hr��e
                      %v�dy zvol� hr��e, se kter�m chce� jet a pak klikne�
                      %na hod kostkou, pokud tak neu�in� pojede ten
                      %pan��ek, na kter�ho jsi klikl jako na posledn�ho
            prisera_te_dohoni_jeden_za_dva
            otherwise %O�et�en�, kdy� n�kdo zvol� upln� n�co jin�ho
            disp('Nezvolili jste nic z uveden� nab�dky a to znamen�, �e m�te sm�lu.')
    end
    case '2' %Ovlad�n� je velmi jednoduch�, prvn� hr�� klikne na kostku, druh� hr�� klikne na kostku atd. 
             %Samoz�ejme, jestli hr�� klikne a kostku vysko� mu
             %ot�zka m� na n� odpov�d hr��, kter� klikal jako posledn� na
             %kostku
    prisera_te_dohoni_kluk_vs_holka    
    otherwise
        disp('Nezvolili jste nic z uveden� nab�dky a to znamen�, �e m�te sm�lu.')   
end

