
function [cyto,PM,zap_ave,ratio]=single_cell_PM_cyto_ratio_auto(input_Tiff_movie)
% load the image;
%TCR=load_separate_chanel('TCR.tif');
file = input_Tiff_movie;
[zap70,TCR,Lck]=load_all_channels(file);
image_dim=size(zap70);
frame_number=image_dim(3);
% combine the 3 z stack in each channel to 1 frame;

for m=1:frame_number
 TCR_m(:,:,m)=medfilt2(TCR(:,:,m));
% Lck_m(:,:,m)=medfilt2(Lck(:,:,m));
zap_m(:,:,m)=medfilt2(zap70(:,:,m));
% TCR_LCK(:,:,m)=medfilt2(TCR(:,:,m)+Lck(:,:,m));
% TCR_LCK_zap70(:,:,m)=medfilt2(TCR(:,:,m)+ Lck(:,:,m)+zap70(:,:,m));
end
zap_ave=mean(zap_m(:,:,frame_number-6:end),3);

% find the cell boundaries of each channel; self write function;

 [zap_ROI]=cell_boundaries_matlab(zap_ave);
%  imshowpair(zap_ave,zap_ROI,'montage')
%  colormap jet

% measure the distance of cell centre to boundaries. using bwdist function.
Center_to_edge_distance= bwdist(~zap_ROI); 
D_scale=rescale(Center_to_edge_distance);
cyto=D_scale.* (D_scale>0.25);
PM=D_scale.*(D_scale>0 & D_scale<0.25);
% subplot 311
% imshowpair(cyto,zap_ave);
% colormap gray
% subplot 312
% imshowpair(PM,zap_ave);
% colormap gray

% get the pixel vluaes of Cyto and PM ROI.

for i=1:frame_number
    temp=TCR_m(:,:,i);
    cyto_pixels=temp(D_scale>0.25);
    cyto_mean(i)=mean(cyto_pixels);
    PM_pixels=temp(D_scale>0 & D_scale<0.25);
    PM_mean(i)= mean(PM_pixels);
    PM_cyto_ratio(i)=PM_mean(i)/cyto_mean(i);
end
% 
% subplot 313 
% plot(PM_cyto_ratio,'*');
ratio=PM_cyto_ratio;
end


