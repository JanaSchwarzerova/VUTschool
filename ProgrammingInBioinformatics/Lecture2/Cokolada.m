%% Nejèokoládovìjší cesta

function [ choco ] = Cokolada(M,r,s)

[max_r,max_s] = size(M);

if r == max_r
   choco = M(r,s);
   
else 
   choco_count = M(r,s);
   choco_r = Cokolada(M,r+1,s);
   choco_s = Cokolada(M,r+1,s+1);
   
   choco = max(choco_r, choco_s)+choco_count;
end


end