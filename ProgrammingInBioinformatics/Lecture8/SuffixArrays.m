%% FPRG 11. týden

%Suffix arrays

%PABANAMABANANAS

Text = 'PANAMABANANAS';
[SA,suf_arr] = SuffixArray( Text );
Pattern = 'XF';

% minIndex = 1;
% maxIndex = length (Text);
% 
% while minIndex < maxIndex
%     midlIndex = floor((minIndex+maxIndex)/2);
%     for i  = 1:length(Pattern);
%          %Pattern <= suffix of Text starting at position SuffixArray(midlIndex)
%         if  find(Pattern(i),pocat_pismeno(midlIndex))
%             maxIndex = midlIndex;
%         else
%             minIndex = midlIndex+1;
%         end
%     end
% end


[ First, Last] = PatternMatchingWithSuffixArray( Pattern, Text, SA, suf_arr);