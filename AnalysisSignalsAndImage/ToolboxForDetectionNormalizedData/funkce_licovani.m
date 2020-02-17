function [matchedPoints1,matchedPoints2] = funkce_licovani(I1,I2)
% volání funkce [matchedPoints1,matchedPoints2] = funkce_licovani(I1,I2)

points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

end

