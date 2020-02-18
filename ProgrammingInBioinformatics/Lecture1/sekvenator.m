function [ i ] = sekvenator(fMID,rMID, sek)
%Sekvenátor

regular_vyraz = ['^' fMID '.*' seqrcomplement(rMID) '$' '|' '^' rMID '.*' seqrcomplement(fMID) '$'];
i = regexp(sek, regular_vyraz);

end

