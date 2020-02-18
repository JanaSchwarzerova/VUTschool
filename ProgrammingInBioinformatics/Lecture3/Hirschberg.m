function [ Z,W ] = Hirschberg( sek1,sek2, match, mismatch, gap, Z, W )
%% Hirschberg�v algoritmus
% sek1 ... sekvence jedna 
% sek2 ... druh� sekvence
% match ... sk�rovac� parametr shody 
% mismatch .. sk�rovac� parametr neshody 
% gap ... mezera 
% Z ...  prvn� zarovan� sekvence 
% W ... druh� zarovan� sekvence

% A) 3 mo�nosti ukon�en� 
  if length(sek1) == 1 && length(sek2) == 1        % ad A1) ob� sek 1 znak
   W = [W,sek2];;
   Z = [Z,sek1];
  elseif isempty(sek1) == 1                        % ad A2) pr�zdn�, znaky
   pom(1:length(sek2)) = '-';
   W = [W,sek2];
   Z = [Z,pom];
  elseif isempty(sek2) == 1                        % ad A3) znaky, pr�zdn� 
   pom(1:length(sek1)) = '-';
   Z = [Z,sek1];
   W = [W,pom];
  else
      
% B) vol�n� NWScore pro 1. p�l sek1 a sek 2 -> vektor1

    sek1_pul = floor(length(sek1)/2);
    if sek1_pul == 0
    vektor1 = NWScore('-',sek2,match,mismatch,gap);    
    else
    vektor1 = NWScore(sek1(1:sek1_pul),sek2,match,mismatch,gap);
    end
    
% C) vol�n� NWScore pro 2. p�l sek1(oto�en�) a sek2(oto�en�) -> vektor2

    if sek1_pul == 0
    vektor2 = NWScore('-',flip(sek2),match,mismatch,gap);   
    else
    vektor2 = NWScore(flip(sek1(sek1_pul+1:length(sek1))),flip(sek2),match,mismatch,gap);
    end
    
% D) se�ten� vektor1 a vektor2(oto�en�ho)
    suma_vek = vektor1 + flip(vektor2);
    
% E) nalezen� indexu maxima -1 -> index p�len� sek2
    [maximum,index] = max(suma_vek);
    index = index-1;
    sek2_pul = floor(index);
    
% F) vol�n� Hirschberg (1. p�l sek1, 1. ��st sek2)
    if sek2_pul == 0
     [Z,W]  = Hirschberg( sek1(1:sek1_pul),'-', match, mismatch, gap, Z, W );   
    elseif sek1_pul == 0
    [Z,W]  = Hirschberg( '-',sek2(1:sek2_pul), match, mismatch, gap, Z, W );
    else
    [Z,W]  = Hirschberg( sek1(1:sek1_pul),sek2(1:sek2_pul), match, mismatch, gap, Z, W );
    end
    
% G) vol�n� Hirschberg (2. p�l sek1. 2. ��st sek2)
    [Z,W]  = Hirschberg( sek1(sek1_pul+1:length(sek1)),sek2(sek2_pul+1:length(sek2)), match, mismatch, gap, Z, W );
  end
end

