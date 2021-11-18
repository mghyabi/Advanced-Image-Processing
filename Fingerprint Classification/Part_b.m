%% i)
A=double(imread('Fig0931(a).png'));
figure, imshow(A), title('Visualization of "Fig0931(a).png"')
B=strel('rectangle',[51 1]);
A_eroded=imerode(A,B);
figure, imshow(A_eroded), title('A_eroded: Erosion of A by B')

%% ii)
A_open=imdilate(A_eroded,B);
figure, imshow(A_open), title('A_open: Dilation of A_eroded by B')

%% iii)
A_reconstruct=imreconstruct(A_eroded,A);
figure, imshow(A_reconstruct)

%% iv)
A_filled=imfill(A,'holes');
figure, imshow(A_filled)

%% v)
A_border=imclearborder(A);
figure, imshow(A-A_border)

%% vi)
A_removed=bwareaopen(A,100);
figure, imshow(A_removed)