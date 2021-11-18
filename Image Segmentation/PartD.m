tic
clear
%storing test image names, and test mask images from here to next comment
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

%creating empty variables to store GCEs and LCEs in next five lines
L=length(image_filenames);
GCE_gray=nan(L,1);
LCE_gray=nan(L,1);
GCE_color=nan(L,1);
LCE_color=nan(L,1);

for i=1:L
   %read the image
   I=imread([image_directory image_filenames(i).name]);
   %turn to gray scale
   I_gray=double(rgb2gray(I/255));
   %canny edge detector
   I_canny=edge(I_gray,'canny');
   %labeling different segments of edge image
   Seg=bwlabel(I_canny);
   
   %in next 10 lines the png ground truth file is read and then intensities are set from 0 to number of segments for further use!
   GT=double(imread([graymask_directory graymask_filenames(i).name]));
   mL1=GT+1;
   n2=numel(unique(mL1));
   mL2=reshape(unique(mL1),1,1,[]);
   mL2=repmat(mL2,size(mL1));
   mL3=repmat(mL1,1,1,n2);
   mL4=double((mL3==mL2));
   mL2=reshape(1:n2,1,1,[]);
   mL2=repmat(mL2,size(mL1));
   GT=sum(mL4.*mL2,3);
   
   %isolating and labeling segment edges in ground truth image in the next six lines
   GT_b = zeros(size(GT));
   for s = 0:max(max(GT))
       current_b = (GT==s)-imerode((GT==s),strel('disk',1));
       GT_b = GT_b | current_b;
   end
   GT_b_gray= bwlabel(GT_b);
   
   %from here to next comment, the same process is repeated for color images
   GT=double(imread([colormask_directory colormask_filenames(i).name]));
   mL1=GT+1;
   n2=numel(unique(mL1));
   mL2=reshape(unique(mL1),1,1,[]);
   mL2=repmat(mL2,size(mL1));
   mL3=repmat(mL1,1,1,n2);
   mL4=double((mL3==mL2));
   mL2=reshape(1:n2,1,1,[]);
   mL2=repmat(mL2,size(mL1));
   GT=sum(mL4.*mL2,3);
   
   GT_b = zeros(size(GT));
   for s = 0:max(max(GT))
       current_b = (GT==s)-imerode((GT==s),strel('disk',1));
       GT_b = GT_b | current_b;
   end
   GT_b_color= bwlabel(GT_b);
   %calculating GCE and LCE for color and gray images and their respective ground truth images
   [GCE_gray(i),LCE_gray(i)]=compute_GCE_LCE(Seg,GT_b_gray);
   [GCE_color(i),LCE_color(i)]=compute_GCE_LCE(Seg,GT_b_color);
end

%displaying parameters
disp(['GCE_color mean= ',num2str(mean(GCE_color))])
disp(['GCE_color stdv= ',num2str(std(GCE_color))])
disp(['GCE_gray mean= ',num2str(mean(GCE_gray))])
disp(['GCE_gray stdv= ',num2str(std(GCE_gray))])
disp(['LCE_color mean= ',num2str(mean(LCE_color))])
disp(['LCE_color stdv= ',num2str(std(LCE_color))])
disp(['LCE_gray mean= ',num2str(mean(LCE_gray))])
disp(['LCE_gray stdv= ',num2str(std(LCE_gray))])
toc