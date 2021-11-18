clear
CD=cd;
image_directory=[cd '\BSDS300\images\test\'];

graymask_directory=[cd '\mask\gray\test\'];

colormask_directory=[cd '\mask\color\test\'];

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
GCE_gray=nan(L,1);
LCE_gray=nan(L,1);
GCE_color=nan(L,1);
LCE_color=nan(L,1);

for i=1:L
   I=imread([image_directory image_filenames(i).name]);
   I_gray=double(rgb2gray(I))/255;
   T=graythresh(I_gray);
   I_thresh=I_gray;
   I_thresh(I_thresh>T)=1;
   I_thresh(I_thresh<=T)=0;
   Seg=bwlabel(I_thresh);
   GT_gray=double(imread([graymask_directory graymask_filenames(i).name]));
   GT_color=double(imread([colormask_directory colormask_filenames(i).name]));
   [GCE_gray(i),LCE_gray(i)]=compute_GCE_LCE(Seg,GT_gray);
   [GCE_color(i),LCE_color(i)]=compute_GCE_LCE(Seg,GT_color);
end

