
%steps from previous parts that are needed to solve this part are put
%together in a function "match_keypoints(I,I_t,thresh)" whose variables are
%two image matrices to be matched and the distance ratio threshold
%discussed in "lowe2004"
%% i)
I=double(imread('cameraman.pgm'))/255;
I_t=imrotate(I,10,'crop');
match_keypoints(I,I_t,0.6)

I=double(imread('hestain.pgm'))/255;
I_t=imrotate(I,10,'crop');
match_keypoints(I,I_t,0.6)

I=double(imread('circlesBrightDark.pgm'))/255;
I_t=imrotate(I,10,'crop');
match_keypoints(I,I_t,0.6)

%% ii)
I=double(imread('cameraman.pgm'))/255;
%adding gaussian noise
I1=I+0.1*randn(size(I));
%clipping intensities less than 0 and greater than 1
I1(I1<0)=0;
I1(I1>1)=1;
I_t=imrotate(I1,10,'crop');
match_keypoints(I,I_t,0.6)

I=double(imread('hestain.pgm'))/255;
I1=I+0.1*randn(size(I));
I1(I1<0)=0;
I1(I1>1)=1;
I_t=imrotate(I1,10,'crop');
match_keypoints(I,I_t,0.6)

I=double(imread('circlesBrightDark.pgm'))/255;
I1=I+0.1*randn(size(I));
I1(I1<0)=0;
I1(I1>1)=1;
I_t=imrotate(I1,10,'crop');
match_keypoints(I,I_t,0.6)

%% iii)
I=double(imread('cameraman.pgm'))/255;
I1=imresize(I,size(I)/2);
I_t=imrotate(I1,10,'crop');
match_keypoints(I,I_t,0.6)

I=double(imread('hestain.pgm'))/255;
I1=imresize(I,size(I)/2);
I_t=imrotate(I1,10,'crop');
match_keypoints(I,I_t,0.6)

I=double(imread('circlesBrightDark.pgm'))/255;
I1=imresize(I,size(I)/2);
I_t=imrotate(I1,10,'crop');
match_keypoints(I,I_t,0.6)

%% iv)
I=double(imread('cameraman.pgm'))/255;
I_t=double(imread('hestain.pgm'))/255;
match_keypoints(I,I_t,0.6)

%% v)
I=double(imread('cameraman.pgm'))/255;
I_t=imrotate(I,10);
match_keypoints(I,I_t,1)
