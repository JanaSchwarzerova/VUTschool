function [ Segout] = ukol2_fce( I )
%% MBFY – 19.11. 2019

% Detect Cell Using Edge Detection and Morphology
% https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html

[~,threshold] = edge(I,'sobel');
fudgeFactor = 0.5;
BWs = edge(I,'sobel',threshold * fudgeFactor);
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs,[se90 se0]);
BWdfill = imfill(BWsdil,'holes');
BWnobord = imclearborder(BWdfill,4);
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWoutline = bwperim(BWfinal);
Segout = I; 
Segout(BWoutline) = 255; 