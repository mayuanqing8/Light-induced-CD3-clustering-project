function y=load_separate_chanel(X)
file=X

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
y=loaded;
end
