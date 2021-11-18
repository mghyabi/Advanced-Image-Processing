%% i)
% A=nan(2*sum(P~=0),6);
% b=nan(2*sum(P~=0),1);
% j=1;
% for i=1:numel(P)
%    if P(i)~=0
%        A(j:j+1,:)=[xyso(i,1) xyso(i,2) 0 0 1 0;0 0 xyso(i,1) xyso(i,2) 0 1];
%        b(j:j+1)=[xyso_t(P(i),1);xyso_t(P(i),2)];
%       j=j+2;
%    end
% end
% 
% t=pinv(A)*b;

%% ii)
I=double(imread('cameraman.pgm'))/255;
I_t=imrotate(I,45);
imwrite(I,'I.pgm');
imwrite(I_t,'I_t.pgm');
system('siftDemoV4\siftWin32 <I.pgm>I.key');
system('siftDemoV4\siftWin32 <I_t.pgm>I_t.key');
[xyso,F]=create_feature_matrices('I.key');
[xyso_t,F_t]=create_feature_matrices('I_t.key');
D=pairwise_distance(F,F_t);
P=paired_keypoints(D,0.6);
t=estimate_affine_transformation(P,xyso,xyso_t);

disp('Vector t: ')
disp(t)

T=[t(1),t(2),t(5);t(3),t(4),t(6);0,0,1];

disp('Matrix T: ')
disp(T)

tform=invert(affine2d(T'));
I_tform=imwarp(I,tform);

figure, imshow(I_tform),title('I-tform')
figure, imshow(I_t),title('I-t')

% As it can be seen in the figures, I_t and I_tform are quite similar
% The general form of I_t and I_tform are similar. However, I_tform appears to have smoother edges. The other difference is the image sizes. I_t is 363x363 and I_tform is 361x367.

%% iii)
itform=invert(tform);
I_tform_itform=imwarp(I_tform,itform);
figure, imshow(I_tform_itform), title('I-tform-itform')
axis on

% I_tform_itform has a bigger size (506x521) than I (256x256). However, the
% inner 256x256 block of I_tform_itform looks like I. By visual
% inspection, It seems I_tform_itform is slightly smoother than I. it was
% expected because here only a transform and inverse transform is applied
% on the image.
%% iv)
I_t_itform=imwarp(I_t,itform);
figure, imshow(I_t_itform)
axis on

% again the inner part of I_t_itform looks like I. However there are more
% visible differences this time. Although they seem to be less different in 
% terms of smoothness of edges, I_t_itform seem to be skewed or it is as if 
% two shear transforms in both directions with a small factor have been 
% applied to I to result I_t_itform or vice versa . 
%% v)
I=double(imread('cameraman.pgm'))/255;
I_t=imrotate(I,45);

imwrite(I,'I.pgm');
imwrite(I_t,'I_t.pgm');
system('siftDemoV4\siftWin32 <I.pgm>I.key');
system('siftDemoV4\siftWin32 <I_t.pgm>I_t.key');
[xyso,F]=create_feature_matrices('I.key');
[xyso_t,F_t]=create_feature_matrices('I_t.key');
D=pairwise_distance(F,F_t);
P=paired_keypoints(D,1.00);
t=estimate_affine_transformation(P,xyso,xyso_t);
T=[t(1),t(2),t(5);t(3),t(4),t(6);0,0,1];
tform=invert(affine2d(T'));
itform=invert(tform);
I_t_itform=imwarp(I_t,itform);
figure, imshow(I_t_itform)
axis on
% Again, the inner part of I_t_itform loods like I and there seems to be a
% little edge smoothness difference between I_t_itform and I. another
% similarity vith last part is that both have the same kind of difference
% with I which is a shear (skewness) effect in both direction. Difference
% with the last part is that the shear (skewness) effect is much more
% visible in this case which makes sense, as many more outlier key-point 
% matches were used to calculate transform object.