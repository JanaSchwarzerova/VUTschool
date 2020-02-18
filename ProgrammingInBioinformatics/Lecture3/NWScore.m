function [S] = NWScore(sek1,sek2,match,mismatch,gap)

m = 1+length(sek1);
n = 1+length(sek2);
S = (0:(n-1))*gap;
for i = 2:m
    s = S(1);
    c = S(1)+gap;
    S(1) = c;
    for j = 2:n
      if sek1(i-1) == sek2(j-1)
          pom = match;
      else
          pom = mismatch;
      end
      c = max([S(j)+gap,c+gap,s+pom]);
      s = S(j);
      S(j) = c;
    end
end
end