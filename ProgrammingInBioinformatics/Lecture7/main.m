close all; clear all; clc;
%% FPRG 10.TÝDEN

S = {'CATGC','CTAAGT','GCTA','TTCA','ATGCATC'};

%Dodìlej doma: 

matice = zeros(length(S));

for i = 1:length(S)
    for m = 2: length(S{1,i})-1
        for j = i+1:length(S)
            %Musím porovnávat pøekryvy... 
            if length(S{1, i}(m:end)) < length(S{1, j}) ||  length(S{1, i}(m:end)) == length(S{1, j})
              if strcmp(S{1, i}(m:end),S{1, j}(1:(length(S{1, i})-1)))
                 matice(i,j) =  length(S{1, i}(m:end));
              end
            end
        end
    end
end

% for i = 1:length(S)-1 %Projíždím všechny sekvence
%     
%     for j = 2:length(S{1, i})
%      if strcmp(S{1, i}(j+1:end),S{1, i+1}(j-1:length(S{1, i})-j)) 
%         matice(i,i+1)= length(S{1, i}(1+1:end));
%      end
%     
%     end
%     
%     
% end


% for i = 1:length(S)-1
%     for j = 1:length(S{1, i})-1  
%           if length(S{1, i}) <= length(S{1, i+1})
%             if strcmp(S{1, i}(j+1:end),S{1, i+1}(j:length(S{1, i})-j))
%                matice(i,i+1) = ;
%             end    
%           end
%     end
% end