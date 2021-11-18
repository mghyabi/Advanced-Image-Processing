
% close all
I=imread('100075.jpg');
I_gray=double(rgb2gray(I/255));
T=graythresh(I_gray);
I_init=zeros(size(I_gray));
I_init(I_gray>T)=1;
for NumIts=1:250:500
    I_acwe=activecontour(I_gray,I_init,NumIts,'Chan-Vese','SmoothFactor',0.1);
    figure, imshow(I_acwe)
end
%%
CD=cd;
image_directory=[cd '\BSDS300\images\train\'];

graymask_directory=[cd '\mask\gray\train\'];

colormask_directory=[cd '\mask\color\train\'];

cd(image_directory)
image_filenames=dir('*.jpg');
cd(CD)

cd(graymask_directory)
graymask_filenames=dir('*.png');
cd(CD)

cd(colormask_directory)
colormask_filenames=dir('*.png');
cd(CD)

L=length(image_filenames);
GCE_gray_train=nan(L,10);
LCE_gray_train=nan(L,10);
GCE_color_train=nan(L,10);
LCE_color_train=nan(L,10);

for i=1:2%L
   I=imread([image_directory image_filenames(i).name]);
   I_gray=double(rgb2gray(I/255));
   T=graythresh(I_gray);
   I_init=zeros(size(I_gray));
   I_init(I_gray>T)=1;
   
   GT_gray=double(imread([graymask_directory graymask_filenames(i).name]));
   GT_color=double(imread([colormask_directory colormask_filenames(i).name]));
   
   k=1;
   for smoothval=0:.1:1
       I_acwe=activecontour(I_gray,I_init,100,'Chan-Vese','SmoothFactor',smoothval);
       Seg=bwlabel(I_acwe);
       [GCE_gray_train(i,k),LCE_gray_train(i,k)]=compute_GCE_LCE(Seg,GT_gray);
       [GCE_color_train(i,k),LCE_color_train(i,k)]=compute_GCE_LCE(Seg,GT_color);
       k=k+1;
   end
end