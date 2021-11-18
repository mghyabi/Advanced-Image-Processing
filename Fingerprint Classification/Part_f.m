%% i)
[m,n]=size(I_code3b);
[x1,y1]=find(I_code3b==1);
[x3,y3]=find(I_code3b==3);
r=[x1;x3];
c=[y1;y3];
F=nan(4,numel(r));
F(1,:)=r;
F(2,:)=c;
F(4,:)=3;
F(4,1:numel(x1))=1;

rmin1=r-3; rmax1=r+3; cmin1=c-3; cmax1=c+3;
rmin1(rmin1<1)=1; cmin1(cmin1<1)=1;
rmax1(rmax1>m)=m; cmax1(cmax1>n)=n;

Unq=unique(I_branches3b);
Unq(1)=[];
I_Sep_branches3b=double(repmat(I_branches3b,1,1,numel(Unq))==repmat(reshape(Unq,1,1,[]),size(I_branches3b)));
I_branch_angles=zeros(size(I_Sep_branches3b));
for i=1:size(I_Sep_branches3b,3)
   [x,y]=find(I_Sep_branches3b(:,:,i));
   p=polyfit(x,y,1);
   Angle=atan(p(1));
   I_branch_angles(:,:,i)=I_Sep_branches3b(:,:,i)*Angle;
end
I_branch_angles=sum(I_branch_angles,3);

for i=1:numel(r)
    select_window=zeros(size(I_code3b));
    select_window(rmin1(i):rmax1(i),cmin1(i):cmax1(i))=1;
    Unq=unique(select_window.*I_branch_angles);
    Unq(Unq==0)=[];
    F(3,i)=mean(Unq);
end
index=find(isnan(F(3,:)));
% I_skel3b(r(index),c(index))=0;
% I_code3b(r(index),c(index))=2;
r(index)=[];
c(index)=[];
F(:,index)=[];

%% ii)
L=3;
F3=nan(13,size(F,2));
for i=1:size(F,2)
    X=repmat(F(1,i),1,size(F,2));
    Y=repmat(F(2,i),1,size(F,2));
    dX=F(1,:)-X;
    dY=F(2,:)-Y;
    theta=atan2(dY,dX);
    theta(isnan(theta))=pi/2;
    d=sqrt((dX).^2+(dY).^2);
    F1=[d;theta;F];
    F1=sortrows(F1')';
    F3(1:L,i)=F1(1,2:1+L);
    F3(4:3+L,i)=dPhi(F1(2,2:1+L),F1(5,1));
    F3(7:6+L,i)=dPhi(F1(5,1),F1(5,2:1+L));
    F3(10:end,i)=F1(6,1:1+L);
end

Feature=cell(10,8);
for i=1:10
    for j=1:8
        Bin=imread([cd '\Binary\' num2str(100+i) '_' num2str(j) '.png']);
        Bin(Bin~=0)=1;
        [~,Feature{i,j}]=feature_matrix(Bin);
    end
end
%% iii)one
Temp=cell(10,1);
Input=cell(10,7);
for i=1:10
    Bin=imread([cd '\Binary\' num2str(100+i) '_1.png']);
    Bin(Bin~=0)=1;
    [Temp{i},~]=feature_matrix(Bin);
   for j=2:8
       Bin=imread([cd '\Binary\' num2str(100+i) '_' num2str(j) '.png']);
       Bin(Bin~=0)=1;
       [Input{i,j-1},~]=feature_matrix(Bin);
   end
end

%% iii)two
Sim=cell(10,7,10);
for i=1:10
   for j=1:10
       for k=1:7
           Sim{j,k,i}=similarity_level(Input{j,k},Temp{i});
       end
   end
end

%% iv)

Fg_input=cell(10,7,10);
Fg_temp=cell(10,7,10);
for i=1:10
   for j=1:10
       for k=1:7
           [r,c]=find(Sim{j,k,i}==max(max(Sim{j,k,i})));
           r(2:end)=[]; c(2:end)=[];
           
           F=Feature{i,1};
           Fg=zeros(3,size(F,2));
           X=repmat(F(1,c),1,size(F,2));
           Y=repmat(F(2,c),1,size(F,2));
           dX=F(1,:)-X;
           dY=F(2,:)-Y;
           Fg(1,:)=sqrt((dX).^2+(dY).^2);
           theta=atan2(dY,dX);
           theta(isnan(theta))=pi/2;
           Fg(2,:)=dPhi(theta,F(3,c));
           Fg(3,:)=dPhi(F(3,:),F(3,c));
           Fg_temp{j,k,i}=Fg;
           
           F=Feature{j,k+1};
           Fg=zeros(3,size(F,2));
           X=repmat(F(1,r),1,size(F,2));
           Y=repmat(F(2,r),1,size(F,2));
           dX=F(1,:)-X;
           dY=F(2,:)-Y;
           Fg(1,:)=sqrt((dX).^2+(dY).^2);
           theta=atan2(dY,dX);
           theta(isnan(theta))=pi/2;
           Fg(2,:)=dPhi(theta,F(3,r));
           Fg(3,:)=dPhi(F(3,:),F(3,r));
           Fg_input{j,k,i}=Fg;           
       end
   end
end

%% v)
ml=cell(10,7,10);
for i=1:10
   for j=1:10
       for k=1:7
           ml{j,k,i}=matching_level(Fg_input{j,k,i},Fg_temp{j,k,i},Sim{j,k,i});
       end
   end
end

Ms=nan(10,7,10);
for i=1:10
   for j=1:10
       for k=1:7
           Ms(j,k,i)=100*sum(sum(ml{j,k,i}))/max(size(ml{j,k,i}));
       end
   end
end