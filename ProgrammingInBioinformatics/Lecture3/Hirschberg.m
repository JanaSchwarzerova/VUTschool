function [ Z,W ] = Hirschberg( sek1,sek2, match, mismatch, gap, Z, W )
%% Hirschbergùv algoritmus
% sek1 ... sekvence jedna 
% sek2 ... druhá sekvence
% match ... skórovací parametr shody 
% mismatch .. skórovací parametr neshody 
% gap ... mezera 
% Z ...  první zarovaná sekvence 
% W ... druhá zarovaná sekvence

% A) 3 možnosti ukonèení 
  if length(sek1) == 1 && length(sek2) == 1        % ad A1) obì sek 1 znak
   W = [W,sek2];;
   Z = [Z,sek1];
  elseif isempty(sek1) == 1                        % ad A2) prázdná, znaky
   pom(1:length(sek2)) = '-';
   W = [W,sek2];
   Z = [Z,pom];
  elseif isempty(sek2) == 1                        % ad A3) znaky, prázdná 
   pom(1:length(sek1)) = '-';
   Z = [Z,sek1];
   W = [W,pom];
  else
      
% B) volání NWScore pro 1. pùl sek1 a sek 2 -> vektor1

    sek1_pul = floor(length(sek1)/2);
    if sek1_pul == 0
    vektor1 = NWScore('-',sek2,match,mismatch,gap);    
    else
    vektor1 = NWScore(sek1(1:sek1_pul),sek2,match,mismatch,gap);
    end
    
% C) volání NWScore pro 2. pùl sek1(otoèená) a sek2(otoèená) -> vektor2

    if sek1_pul == 0
    vektor2 = NWScore('-',flip(sek2),match,mismatch,gap);   
    else
    vektor2 = NWScore(flip(sek1(sek1_pul+1:length(sek1))),flip(sek2),match,mismatch,gap);
    end
    
% D) seètení vektor1 a vektor2(otoèeného)
    suma_vek = vektor1 + flip(vektor2);
    
% E) nalezení indexu maxima -1 -> index pùlení sek2
    [maximum,index] = max(suma_vek);
    index = index-1;
    sek2_pul = floor(index);
    
% F) volání Hirschberg (1. pùl sek1, 1. èást sek2)
    if sek2_pul == 0
     [Z,W]  = Hirschberg( sek1(1:sek1_pul),'-', match, mismatch, gap, Z, W );   
    elseif sek1_pul == 0
    [Z,W]  = Hirschberg( '-',sek2(1:sek2_pul), match, mismatch, gap, Z, W );
    else
    [Z,W]  = Hirschberg( sek1(1:sek1_pul),sek2(1:sek2_pul), match, mismatch, gap, Z, W );
    end
    
% G) volání Hirschberg (2. pùl sek1. 2. èást sek2)
    [Z,W]  = Hirschberg( sek1(sek1_pul+1:length(sek1)),sek2(sek2_pul+1:length(sek2)), match, mismatch, gap, Z, W );
  end
end

