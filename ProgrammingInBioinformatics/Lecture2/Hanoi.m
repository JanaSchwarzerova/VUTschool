function Hanoi(n,zKolik,naKolik)
% n = .. poèet diskù
% zKolik = 1 (poèáteèní kolík)
% naKolik = 3 (koncový kolík)

if n == 1
   disp(['Pøesuò disk z ' num2str(zKolik) ' na ' num2str(naKolik) ' kolík'])
else
    volnyKolik = 6 - zKolik - naKolik;
    Hanoi(n-1,zKolik,volnyKolik);
    disp(['Pøesuò disk z ' num2str(zKolik) ' na ' num2str(naKolik) ' kolík'])
    Hanoi(n-1,volnyKolik,naKolik);
end

end
