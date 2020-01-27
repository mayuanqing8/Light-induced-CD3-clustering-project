
%% this is to load the images in green and red channel;
file_red='aligned Lck.tif'
file_green='aligned TCR.tif'
Tif_Link_red=Tiff(file_red,'r');
Tif_Link_green=Tiff(file_green,'r');
imageinfor=imfinfo(file_red);
frame_number=length(imageinfor);
loaded_red=zeros(256,256,frame_number);
loaded_green=zeros(256,256,frame_number);

for i=1:frame_number
     Tif_Link_red.setDirectory(i);
     loaded_red(:,:,i)=Tif_Link_red.read();
end
Tif_Link_red.close();

for i=1:frame_number
     Tif_Link_green.setDirectory(i);
     loaded_green(:,:,i)=Tif_Link_green.read();
end
Tif_Link_green.close();
%%
frameref=loaded_red(:,:,1);
fft_ref=fft2(frameref); 
[vidHeight vidWidth blank] = size(frameref); % The blank variable here gets rid of extra padding !!!!!!!!!!!!!!!!!!!!!!!!!!!!
 centery=(vidHeight/2)+1;
 centerx=(vidWidth/2)+1;
%frame_alighned(:,:,:)=zeros(256,256,frame_number);
%%
j=1;
for j=1:frame_number
%drift=loaded_red(:,:,i+1);
fft_drift=fft2(loaded_red(:,:,j));
% this is to loade the ref and to be dirft corrected image and calculate
% their fft2;
prod=fft_ref.*conj(fft_drift);
cc=ifft2(prod);
[maxy,maxx]=find(fftshift(cc)==max(max(cc)));
% this is the actual coordinates of the coorelation maxima(such as 133,130)
shifty=maxy-centery;
shiftx=maxx-centerx;
% this is to translate the shift as shift from the cenre of the image,

frame_aligned(:,:,j)=circshift(loaded_green(:,:,j),[shifty,shiftx]);
end



%%
frame_aligned_uint8=uint8(frame_aligned);
%%
for z=1:13;
imwrite(frame_aligned_uint8(:,:,z),'aligned.tif','WriteMode','append')
end
