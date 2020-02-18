function [ matice ] = Porovnavani( S )
%Výsledkem funkce bude matice porovnání 

matice = zeros(length(S));


for i = 1:length(S)
    for j = i:length(S)
        if length(S{1, i}) < length(S{1, j}) ||  length(S{1, i}) == length(S{1, j})
         if strcmp(S{1, i}(2:end),S{1, j}(1:(length(S{1, i})-1)))
            matice(i,j) =  length(S{1, i}(2:end));
         end
        end
    end
end


end

