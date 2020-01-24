function [ ROI ]=find_cell_boundaries(image_frame)
% do the image gradient to find the edge (also makes crap inside  cell);
[Gmag,Gdir] = imgradient(image_frame,'sobel');
ST=multithresh(Gmag);
BW3=imbinarize(Gmag,ST*0.25);
BW7=imfill(BW3,'holes');
BW8=bwareaopen(BW7,1000);
% step2: is to find the boundaries of BW3;
[ROI_idx, ROI]=bwboundaries(BW8,8,'holes');
% imshowpair(image_frame,ROI, 'montage');
% colormap jet;
end
