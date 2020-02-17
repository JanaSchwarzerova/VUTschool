clear all; close all; clc;
%% MBFY – 19.11. 2019

% Detect Cell Using Edge Detection and Morphology
% https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html

I = imread('MSC-CMFDA-migrace-6h-23-1-2018.lif_Series011_t03_z2_ch00.tif');
imshow(I)
title('Original Image');

I = im2double(I);
level = graythresh(I);
BW = im2bw(I,level);
BWnobord = imclearborder(BW,4);

imshow(BWnobord)
