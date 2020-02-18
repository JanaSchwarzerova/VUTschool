function [bS,bM,bB] = BruteForceMotifSearchAgain(DNA, t, n, l)
% DNA 
% t = L = poèet sekvencí


s = ones(1,t);
[bS,bB] = Score(s, DNA, l);
while 1==1
    k = n-length(s)+1;
    s =  NextLeaf(s, t, k);
    pom_bS = Score(s, DNA, l);
    if pom_bS > bS
        [bS,bB] = Score(s, DNA, l);
        bM = s;
    end
    
    if s == ones(1,t)
    bM
    return
    end
end