function [skupinky, Z] = seskup2(QRSm, vzdalenost)
% function SESKUP2 je zalozena na shlukove analyze
% 
%     skupinky = seskup2(QRSm, vzdalenost)
%        QRSm - bunkove pole, co bunka to svod
%             - kazda bunka obsahuje pozice nadetekovanych bodu v danym svodu
%        vzdalenost - minimalni vzdalenost (ve vzorcich), 
%                     pro rozdeleni na samostatne shluky
%        skupinky - bunkove pole, co bunka to bod
%                 - kazda bunka obsahuje blizke detekce ze vsech (nekterych) svodu (i vicenasobne)
%
%

% 2010-04-27, Jan Hrubes

m = sort(cell2mat(QRSm));
% cas = 0.1; % s (odhad casu mezi vlnama) 
% fvz = 500; % Hz
% vzdalenost = cas * fvz; % pocet vzorku
if length(m)>=2
    Y = pdist(m'); % vypocet vzdalenosti
    Z = linkage(Y); % shlukovani
    T = cluster(Z,'cutoff', vzdalenost,'criterion','distance')'; % rozdeleni do shluku
    [uT,oT] = unique(T,'first'); % zjisteni poctu shluku
    [~,pos] = sort(oT); % zjisteni poradi shluku
    skupinky = cell(1,length(uT)); % a nasazeni do bunkoveho pole
    for i = uT
        skupinky{i} = sort(m(T==pos(i)));
    end
else
    skupinky = {m};
end




