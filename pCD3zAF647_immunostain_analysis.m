%% 
clc
clear all
close all
%% load data (single image stack contains 3 channel images sequentially)
[Lck_wt TCR_CY2 pCD3]=load_all_channels('filename.tif');
frame_number=size(Lck_wt,3);
%% multithresholding to set threshold to later to select pixels that 
% contains TCR and Lck channel 
for m=1:frame_number
Lck_wt_ostu(m)=multithresh(Lck_wt(:,:,m));
TCR_CY2_ostu(m)=multithresh(TCR_CY2(:,:,m));
end

%% 2D scattering plot of everything to have quick check of colocalization
for m=1:frame_number
pCD3_vec(:,m)=reshape(pCD3(:,:,m),512*512,1);
TCR_CY2_vec(:,m)=reshape(TCR_CY2(:,:,m),512*512,1);
Lck_wt_vec(:,m)=reshape(Lck_wt(:,:,m),512*512,1);
%scatter(pCD3_vec(:,m),TCR_CY2_vec(:,m),'r*');
%pause(0.2);
end

%% plot of pCD3zAF647 pixel intensiy in cells contain both TCR and Lck or
% only TCR with no Lck as a reference for background staining of
% pCD3zAF647.

pCD3_intensity_TCR_lck_posi=cell(1,frame_number);
pCD3_intensity_TCR_posi_lck_nega=cell(1,frame_number);
background=cell(1,frame_number);
TCR_Lck_posi_intensity=cell(1,frame_number);
TCR_posi_Lck_nega_intensity=cell(1,frame_number);

for m=1:frame_number
   %define the mask for pixel selection
TCR_posi=TCR_CY2_vec(:,m)>TCR_CY2_ostu(m);
TCR_Lck_mask_posi=Lck_wt_vec(:,m)>Lck_wt_ostu(m)& TCR_CY2_vec(:,m)>TCR_CY2_ostu(m);
TCR_posi_lck_nega=Lck_wt_vec(:,m)<=0.05*Lck_wt_ostu(m) & TCR_CY2_vec(:,m)>TCR_CY2_ostu(m);
background=Lck_wt_vec(:,m)<Lck_wt_ostu(m) & TCR_CY2_vec(:,m)<TCR_CY2_ostu(m);

 % extract the pCD3zAF647 pixel intensity from the masked region
pCD3_intensity_TCR_lck_posi{m}=pCD3_vec((TCR_Lck_mask_posi),m);
pCD3_intensity_TCR_posi_lck_nega{m}=pCD3_vec((TCR_posi_lck_nega),m);
pCD3_inteinsity_backgrond{m}=pCD3_vec((background),m);
TCR_intensity{m}=TCR_CY2_vec((TCR_posi),m);
TCR_Lck_posi_intensity{m}=TCR_CY2_vec((TCR_Lck_mask_posi),m);
TCR_posi_Lck_nega_intensity{m}=TCR_CY2_vec((TCR_posi_lck_nega),m);
end



%% get the mean of pixel intensity of the masked region of each image
for m=1:frame_number
    pCD3__mean_intensity_TCR_lck_posi(m)= mean(pCD3_intensity_TCR_lck_posi{m});
    pCD3__mean_intensity_TCR_posi_lck_nega(m)=mean(pCD3_intensity_TCR_posi_lck_nega{m});
    pCD3_mean_background(m)=mean(pCD3_inteinsity_backgrond{m});
    TCR_posi_mean(m)=mean(TCR_intensity{m});
    TCR_mean_intensity_TCR_Lck_posi(m)=mean(TCR_Lck_posi_intensity{m});
    TCR_mean_intensity_TCR_posi_Lck_nega(m)=mean(TCR_posi_Lck_nega_intensity{m});
end
% the the ratio of pCD3z to TCR CY2 for the selected mask region. this is 
% not the ratio of each cell, but an average value of all the selected
% cells within the mask for each frame. 
    pCD3_to_TCR_posi_Lck_posi_ratio=  pCD3__mean_intensity_TCR_lck_posi./ TCR_mean_intensity_TCR_Lck_posi;
    pCD3_to_TCR_posi_Lck_nega_ratio=pCD3__mean_intensity_TCR_posi_lck_nega./ TCR_mean_intensity_TCR_posi_Lck_nega;

%% box plot the absolute pixel inteinsty and ratio of the selected region
combined=[pCD3__mean_intensity_TCR_lck_posi; pCD3__mean_intensity_TCR_posi_lck_nega;...
    pCD3_mean_background; pCD3_to_TCR_posi_Lck_posi_ratio; pCD3_to_TCR_posi_Lck_nega_ratio; TCR_posi_mean;]';

figure
boxplot(combined);
ylabel('pCD3AF647 to LIC_CD3z intensity ratio');
xticklabels({'TCR+ Lck+',' TCR+ Lck-',' background','TCR_mean','TCR_posi_Lck_posi','TCR_posi_Lck_nega'});
%title('logical selection of pixels based on presence of TCR and Lck')
save('result_analyzed.mat','combined');
%imwrite('h','box_plot_matlab.tif');
saveas(gcf,'box_plot_matlab.png');

