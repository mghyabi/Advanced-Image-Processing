%% i)
[xyso,F]=create_feature_matrices('result.key');
% fID=fopen('result.key');
% K=fscanf(fID,'%d',[1 1]);
% fscanf(fID,'%d',[1 1]);
% xyso=nan(K,4);
% F=nan(K,128);
% for i=1:K
%     xyso(i,:)=fscanf(fID,'%f',[1 4]);
%     F(i,:)=fscanf(fID,'%d',[1 128]);
% end
% fclose(fID);

%% ii)
D=pairwise_distance(F,F);
% [r1,~]=size(F1);
% [r2,~]=size(F2);
% D=nan(r1,r2);
% for i=1:r1
%     for j=1:r2
%         D(i,j)=sqrt(sum((F1(i,:)-F2(j,:)).^2));
%     end
% end

%% iii)
P=paired_keypoints(D,0.6);
% thresh=0.6;
% s=size(D);
% P=zeros(s(1),1);
% for i=1:s(1)
%     d=[D(i,:);1:s(2)]';
%     d=sortrows(d);
%     if (d(1,1)/d(2,1))<thresh
%         P(i)=d(1,2);
%     end
% end

%% iv)
I=double(imread('cameraman.pgm'))/255;
I_t=imrotate(I,10);
imwrite(I_t,'I_t.pgm');
system('siftDemoV4\siftWin32 <cameraman.pgm>I.key')
system('siftDemoV4\siftWin32 <I_t.pgm>I_t.key')
[xyso,F]=create_feature_matrices('I.key');
[xyso_t,F_t]=create_feature_matrices('I_t.key');


disp(xyso(1,:))

disp(F(1,:))

disp(xyso_t(1,:))

disp(F_t(1,:))

D=pairwise_distance(F,F_t);

disp(D(1,:))

P=paired_keypoints(D,0.6);

disp(P)

%% v)
sbs=zeros(max(size(I,1),size(I_t,1)),size(I,2)+size(I_t,2));
sbs(1:size(I,1),1:size(I,2))=I;
sbs(1:size(I_t,1),size(I,2)+1:end)=I_t;

figure,
imshow(sbs)
title('Side-by-Side Image')

D=pairwise_distance(F,F_t);
P=paired_keypoints(D,0.6);

figure,
imshow(sbs)
hold on
Angle=nan(numel(find(P~=0)),1);
j=1;
for i=1:numel(P)
   if P(i)~=0
      line([xyso(i,2),xyso_t(P(i),2)+size(I,2)],[xyso(i,1),xyso_t(P(i),1)])
      Angle(j)=atan((xyso(i,2)-xyso_t(P(i),2)+size(I,2))/(xyso(i,1)-xyso_t(P(i),1)));
      j=j+1;
   end
end
Outliers_N=sum((Angle>mean(Angle)+1*std(Angle))+(Angle<mean(Angle)-1*std(Angle)));