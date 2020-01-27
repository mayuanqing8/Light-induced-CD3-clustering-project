function [ ROI ]=cell_boundaries_matlab(image_frame)
% do the image gradient to find the edge (also makes crap inside  cell);
[Gmag,Gdir] = imgradient(image_frame,'sobel');
ST=multithresh(Gmag);
BW3=imbinarize(Gmag,ST*0.7);
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BW5 = imdilate(BW3, [se90 se0]);
BW6=imfill(BW5,'holes');
seD = strel('diamond',1);
BW7 = imerode(BW6,seD);
BW8 = imerode(BW7,seD);
BW9=bwareaopen(BW8,1000);
% step2: is to find the boundaries of BW3;
[ROI_idx, ROI]=bwboundaries(BW9,8,'holes');
% imshowpair(image_frame,ROI, 'montage');
% colormap jet;
end
