function [a,b, c]=load_all_channels(X)
% this function can load single TIFF stack that contains multi-specctral 
% channel images sequential as 1, 2, 3, 1, 2, 3, ....
% or single hyperstack.  the stack can be a time-lapse movies or just
% combined stack of single shot images. 
file=X;

Tif_Link=Tiff(file,'r');

imageinfor=imfinfo(file);
frame_number=length(imageinfor);
image_width=imageinfor.Width;
image_height=imageinfor.Height;
loaded=zeros(image_height,image_width,frame_number);


for i=1:frame_number
     Tif_Link.setDirectory(i);
     loaded(:,:,i)=Tif_Link.read();
end
Tif_Link.close();
loaded_red_med=zeros(image_height,image_width,frame_number/3);
loaded_green_med=zeros(image_height,image_width,frame_number/3);
loaded_blue_med=zeros(image_height,image_width,frame_number/3);
m=1;
s=1;
while m<=frame_number-2
loaded_red_med(:,:,s)=medfilt2(loaded(:,:,m));
loaded_green_med(:,:,s)=medfilt2(loaded(:,:,(m+1)));
loaded_blue_med(:,:,s)=medfilt2(loaded(:,:,(m+2)));
m=m+3;
s=s+1;
end
a=loaded_red_med;
b=loaded_green_med;
c=loaded_blue_med;
end
