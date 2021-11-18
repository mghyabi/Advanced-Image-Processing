close all
clear

%% i)
A=double(imread('Fig0911(a).png'));
figure,imshow(A)
B_test=strel('disk',11);
% figure,imshow(B_test)
figure,imshow(B_test.getnhood)

B=strel('square',3);
figure,imshow(B.getnhood)

%%% ii)
Ac=imerode(A,B);
figure,imshow(Ac)

%% iii)
Ad1=imdilate(Ac,B);
figure,imshow(Ad1)
Ad2=imopen(A,B);
figure,imshow(Ad2)
disp(['Maximum difference of Ad1 and Ad2 is equal to ' num2str(max(max(Ad1-Ad2)))])

%% iv)
Ae=imdilate(Ad1,B);
figure,imshow(Ae)

%% v)
Af1=imerode(Ae,B);
figure,imshow(Af1)
Af2=imclose(Ad1,B);
figure,imshow(Af2)
disp(['Maximum difference of Af1 and Af2 is equal to ' num2str(max(max(Af1-Af2)))])

% I_skel=bwmorph(Af2,'skel');
% I_skel=bwmorph(I_skel,'skel');
% I_skel=bwmorph(I_skel,'skel');
% figure, imshow(I_skel)

