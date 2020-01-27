%% this is to load the images in green and red channel; 
% the images should be single snapshot images combined in a tiff stack.
% to start, make a tif stack where the odd number of the stack is Lck
% channel, while the even number is LIC_CD3z.

file='all stack combined.tif'

Tif_Link=Tiff(file,'r');

imageinfor=imfinfo(file);
frame_number=length(imageinfor);
loaded=zeros(512,512,frame_number);


for i=1:frame_number
     Tif_Link.setDirectory(i);
     loaded(:,:,i)=Tif_Link.read();
end
Tif_Link.close();

% for i=1:frame_number
%      Tif_Link_green.setDirectory(i);
%      loaded_green(:,:,i)=Tif_Link_green.read();
% end
% Tif_Link_green.close();

%% do some filtering of the images files
m=0;
for m=2:2:frame_number
loaded_red_med(:,:,m/2)=medfilt2(loaded(:,:,m));
end

m=0;
for m=1:2:frame_number
loaded_green_med(:,:,(m+1)/2)=medfilt2(loaded(:,:,m));
end

%%
%calculating the pearson coefficeint after otsu thresholding.

% this is to calculate the otsu threshold of the image prior to the
% claculation of pearson coefficeint;
ostu_threshold_red=zeros(512,512,frame_number/2);
ostu_threshold_green=zeros(512,512,frame_number/2);
for m=1:frame_number/2
ostu_threshold_red(:,:,m)=loaded_red_med(:,:,m)-multithresh(loaded_red_med(:,:,m));
ostu_threshold_green(:,:,m)=loaded_green_med(:,:,m)- multithresh(loaded_green_med(:,:,m));
end

%%
% convert 2 D image to 1 D vector, easy to calculate prearson coefficent later.
ostu_threshold_red_vec=zeros(512*512,frame_number/2);
ostu_threshold_green_vec=zeros(512*512,frame_number/2);;
for m=1:frame_number/2
    ostu_threshold_red_vec(:,m)=reshape(ostu_threshold_red(:,:,m),[512*512,1]);
end

for m=1:frame_number/2
    ostu_threshold_green_vec(:,m)=reshape(ostu_threshold_green(:,:,m),[512*512,1]);
end

%% convert background pixels to NaN. 

for m=1:frame_number/2
    for j= 1:512*512
     if ostu_threshold_green_vec(j,m)<0
         ostu_threshold_green_vec(j,m)=NaN;
     end
    end
end

for m=1:frame_number/2
    for j= 1:512*512
     if ostu_threshold_red_vec(j,m)<0
         ostu_threshold_red_vec(j,m)=NaN;
     end
    end
end
%this is to conver all the pixles below threshold to NaN.

%%

% Calculate the Pearson coefficient across isolated voxel
mean_green=ones(frame_number/2,1);
mean_red=ones(frame_number/2,1);
for m=1:frame_number/2
    mean_green(m,1)=nanmean(ostu_threshold_green_vec(:,m));
    mean_red(m,1)=nanmean(ostu_threshold_red_vec(:,m));
end
    %%
    R=ones(frame_number/2,1);
    for m=1:frame_number/2
 R(m,1) = (nansum((ostu_threshold_green_vec(:,m) - mean_green(m,1)).*(ostu_threshold_red_vec(:,m) - mean_red(m,1))))...
     /(sqrt(nansum((ostu_threshold_green_vec(:,m) - mean_green(m,1)).^2)*nansum((ostu_threshold_red_vec(:,m) - mean_red(m,1)).^2)));
    end
     %%
    plot(R,'r*');
    axis square
 mean_R=mean(R);
 STD_R=std(R);
 % here the nansum and nanmean is used to calculate the sum and meam by
 % excluding all the NaN pixels.