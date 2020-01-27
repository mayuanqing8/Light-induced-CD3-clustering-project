%%   
clc
close all
clear all;

%% load data (3 channel images are aligned sequentially in order in one image
% stack over the time series)
% here the cell images often need to be croped to ROI only include cell.
file='nice 2 crop.tif'
[zap70,TCR,Lck]=load_all_channels(file);
dim=size(zap70);
frame_number=dim(3);
imageinfor=imfinfo(file);
image_width=imageinfor.Width;
image_height=imageinfor.Height;
%%
%calculating the pearson coefficeint after otsu thresholding.
% this is to calculate the otsu threshold of the image prior to the
% claculation of pearson coefficeint;
ostu_threshold_zap70=zeros(image_height,image_width,frame_number);
ostu_threshold_TCR=zeros(image_height,image_width,frame_number);
for m=1:frame_number
ostu_threshold_zap70(:,:,m)=zap70(:,:,m)-multithresh(zap70(:,:,m));
ostu_threshold_TCR(:,:,m)=TCR(:,:,m)- multithresh(TCR(:,:,m));
ostu_threshold_Lck(:,:,m)=Lck(:,:,m)- multithresh(Lck(:,:,m));
end

%%
% convert 2 D image to 1 D vector, easy to calculate after.
ostu_threshold_zap70_vec=zeros(image_height*image_width,frame_number);
ostu_threshold_TCR_vec=zeros(image_height*image_width,frame_number);
for m=1:frame_number
    ostu_threshold_zap70_vec(:,m)=reshape(ostu_threshold_zap70(:,:,m),[image_height*image_width,1]);
end

for m=1:frame_number
    ostu_threshold_TCR_vec(:,m)=reshape(ostu_threshold_TCR(:,:,m),[image_height*image_width,1]);
end

for m=1:frame_number
    ostu_threshold_Lck_vec(:,m)=reshape(ostu_threshold_Lck(:,:,m),[image_height*image_width,1]);
end


%% this is to conver all the pixles below threshold to NaN.

for m=1:frame_number
    for j= 1:image_height*image_width
     if ostu_threshold_TCR_vec(j,m)<0
         ostu_threshold_TCR_vec(j,m)=NaN;
     end
    end
end

for m=1:frame_number
    for j= 1:image_height*image_width
     if ostu_threshold_zap70_vec(j,m)<0
         ostu_threshold_zap70_vec(j,m)=NaN;
     end
    end
end

for m=1:frame_number
    for j= 1:image_height*image_width
     if ostu_threshold_Lck_vec(j,m)<0
         ostu_threshold_Lck_vec(j,m)=NaN;
     end
    end
end



%% calculate the means of each isolated voxel.
mean_TCR=ones(frame_number,1);
mean_zap70=ones(frame_number,1);
mean_Lck=ones(frame_number,1);
for m=1:frame_number
    mean_TCR(m,1)=nanmean(ostu_threshold_TCR_vec(:,m));
    mean_zap70(m,1)=nanmean(ostu_threshold_zap70_vec(:,m));
    mean_Lck(m,1)=nanmean(ostu_threshold_Lck_vec(:,m));
end
    %% Calculate the Pearson coefficient across isolated voxel
    R_TCR_zap70=ones(frame_number,1);
    R_Lck_zap70=ones(frame_number,1);
    for m=1:frame_number
 R_TCR_zap70(m,1) = (nansum((ostu_threshold_TCR_vec(:,m) - mean_TCR(m,1)).*(ostu_threshold_zap70_vec(:,m) - mean_zap70(m,1))))...
     /(sqrt(nansum((ostu_threshold_TCR_vec(:,m) - mean_TCR(m,1)).^2)*nansum((ostu_threshold_zap70_vec(:,m) - mean_zap70(m,1)).^2)));
    end
  
      for m=1:frame_number
 R_Lck_zap70(m,1) = (nansum((ostu_threshold_Lck_vec(:,m) - mean_Lck(m,1)).*(ostu_threshold_zap70_vec(:,m) - mean_zap70(m,1))))...
     /(sqrt(nansum((ostu_threshold_Lck_vec(:,m) - mean_Lck(m,1)).^2)*nansum((ostu_threshold_zap70_vec(:,m) - mean_zap70(m,1)).^2)));
    end
    
    
    
     %%
    plot(R_TCR_zap70,'r*');
    hold on
    plot(R_Lck_zap70,'k+')
    axis square
    %%
    combined=[R_TCR_zap70,R_Lck_zap70];
    boxplot(combined);
%  mean_R=mean(R);
%  STD_R=std(R);
 % here the nansum and nanmean is used to calculate the sum and meam by
 % excluding all the NaN pixels.