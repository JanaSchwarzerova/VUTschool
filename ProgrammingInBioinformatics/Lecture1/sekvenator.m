function [ i ] = sekvenator(fMID,rMID, sek)
%Sekven�tor

regular_vyraz = ['^' fMID '.*' seqrcomplement(rMID) '$' '|' '^' rMID '.*' seqrcomplement(fMID) '$'];
i = regexp(sek, regular_vyraz);

end

