clear
close all
%% i)
I_bin=imread([cd '\Binary\101_1.png']);
I=double(imread([cd '\DB1_B_png\101_1.png']))/255;
I_bin(I_bin~=0)=1;
I_skel=double(bwmorph(I_bin,'skel',inf));
figure,imshow(I), title('Original Image 101-1.png')
figure,imshow(I_bin*255), title('Binary Image 101-1.png')
figure,imshow(I_skel), title('Skeleton Image of 101-1.png')

%% ii)
function I_code=code_branches(I_skel)
[m,n]=size(I_skel);
% shifting all neighbors to each coordinate and summing them in the next nine lines(Padded image)
I1=[zeros(2,n+2); zeros(m,1) I_skel zeros(m,1)];
I2=[zeros(2,n+2); I_skel zeros(m,2)];
I3=[zeros(1,n+2); I_skel zeros(m,2); zeros(1,n+2)];
I4=[I_skel zeros(m,2); zeros(2,n+2)];
I5=[zeros(m,1) I_skel zeros(m,1); zeros(2,n+2)];
I6=[zeros(m,2) I_skel; zeros(2,n+2)];
I7=[zeros(1,n+2); zeros(m,2) I_skel; zeros(1,n+2)];
I8=[zeros(2,n+2); zeros(m,2) I_skel];
I_code=(I1+I2+I3+I4+I5+I6+I7+I8);
%reverting to original size and removing pixels which had zero intensity in
%th e original image by pixelwise multipication to I_skel
I_code=I_code(2:end-1,2:end-1).*I_skel;
end

%% iii) 
I_code=code_branches(I_skel);
disp(['Number of pixels in skeleton is equal to ' num2str(sum(sum(I_skel)))])
disp(['Number of ridge ends is equal to ' num2str(sum(sum(I_code==1)))])
disp(['Number of pixels along a ridge is equal to ' num2str(sum(sum(I_code==2)))])
disp(['Number of pixels corresponding to bifurcations is equal to ' num2str(sum(sum(I_code==3)))])
disp(['Number of pixels corresponding to other configurations is equal to ' num2str(sum(sum(I_code>3)))])

%% iv)
[r1,c1]=find(I_code==3);
[r2,c2]=find(I_code==1);
[r3,c3]=find(I_code>3);
figure
subplot(1,2,1)
imshow(abs(I-1))
hold on
scatter(c1,r1,'x','g')
scatter(c2,r2,'+','r')
scatter(c3,r3,'.','b')

subplot(1,2,2)
imshow(I_skel)
hold on
scatter(c1,r1,'x','g')
scatter(c2,r2,'+','r')
scatter(c3,r3,'.','b')

[r4,c4]=find(I_code==2);
figure
imshow(abs(I-1))
hold on
scatter(c4,r4,'.','b')
title('Sanity Check')
