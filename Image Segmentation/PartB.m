clear
close all



a=double(imread('100075.jpg'));
a_gray=(0.2125*a(:,:,1)+0.7154*a(:,:,2)+0.0721*a(:,:,3))/255;

b=a_gray;
b(b>127/255)=1;
b(b<=127/255)=0;
Seg=bwlabel(b')';

GT=double(imread('100075.png'));

% [GCE,LCE]=compute_GCE_LCE_loopy(Seg,GT);
tic
[GCE1,LCE1]=compute_GCE_LCE_sample(Seg,GT);
toc
tic
[GCE2,LCE2]=compute_GCE_LCE(Seg,GT);

toc