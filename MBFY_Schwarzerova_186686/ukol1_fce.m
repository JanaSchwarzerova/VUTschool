function [ Segout] = ukol1_fce( I )

% Detect Cell Using Edge Detection and Morphology
% https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html

%Step 2: Detect Entire Cell
[~,threshold] = edge(I,'sobel');
fudgeFactor = 0.5;
BWs = edge(I,'sobel',threshold * fudgeFactor);

%Step 3: Dilate the Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);
BWsdil = imdilate(BWs,[se90 se0]);

%Step 4: Fill Interior Gaps
BWdfill = imfill(BWsdil,'holes');


%Step 5: Remove Connected Objects on Border
BWnobord = imclearborder(BWdfill,4);

%Step 6: Smooth the Object
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);


%Step 7: Visualize the Segmentation
% imshow(labeloverlay(I,BWfinal))
% title('Mask Over Original Image')

BWoutline = bwperim(BWfinal);
Segout = I; 
Segout(BWoutline) = 255; 

end

