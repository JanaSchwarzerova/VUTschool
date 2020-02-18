function Hanoi(n,zKolik,naKolik)
% n = .. po�et disk�
% zKolik = 1 (po��te�n� kol�k)
% naKolik = 3 (koncov� kol�k)

if n == 1
   disp(['P�esu� disk z ' num2str(zKolik) ' na ' num2str(naKolik) ' kol�k'])
else
    volnyKolik = 6 - zKolik - naKolik;
    Hanoi(n-1,zKolik,volnyKolik);
    disp(['P�esu� disk z ' num2str(zKolik) ' na ' num2str(naKolik) ' kol�k'])
    Hanoi(n-1,volnyKolik,naKolik);
end

end
