clear all; close all; clc;
%% MBFY – 19.11. 2019

% Detect Cell Using Edge Detection and Morphology
% https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html

% Step 1: Read Image
I = imread('MSC-CMFDA-migrace-6h-23-1-2018.lif_Series011_t03_z2_ch00.tif');
imshow(I)
title('Original Image');
text(size(I,2),size(I,1)+15, ...
    'Image courtesy of Alan Partin', ...
    'FontSize',7,'HorizontalAlignment','right');
text(size(I,2),size(I,1)+25, ....
    'Johns Hopkins University', ...
    'FontSize',7,'HorizontalAlignment','right');

%Step 2: Detect Entire Cell
[~,threshold] = edge(I,'sobel');
fudgeFactor = 0.5;
BWs = edge(I,'sobel',threshold * fudgeFactor);

imshow(BWs)
title('Binary Gradient Mask')

%Step 3: Dilate the Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs,[se90 se0]);
imshow(BWsdil)
title('Dilated Gradient Mask')

%Step 4: Fill Interior Gaps
BWdfill = imfill(BWsdil,'holes');
imshow(BWdfill)
title('Binary Image with Filled Holes')

%Step 5: Remove Connected Objects on Border
BWnobord = imclearborder(BWdfill,4);
imshow(BWnobord)
title('Cleared Border Image')

%Step 6: Smooth the Object
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
imshow(BWfinal)
title('Segmented Image');

%Step 7: Visualize the Segmentation
% imshow(labeloverlay(I,BWfinal))
% title('Mask Over Original Image')

BWoutline = bwperim(BWfinal);
Segout = I; 
Segout(BWoutline) = 255; 
imshow(Segout)
title('Outlined Original Image')


