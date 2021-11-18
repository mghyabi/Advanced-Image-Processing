%% i)
I_branches=I_skel;
I_branches(I_code>2)=0;
I_branches=bwlabel(I_branches);
disp(['Number of branches is equal to ' num2str(max(max(I_branches)))])
figure
subplot(1,2,1)
imagesc(I_branches)
axis equal tight off
subplot(1,2,2)
imshow(I_branches)

%% ii)
Limit=3;
pI_code=zeros(size(I_code)+2);
pI_branches=zeros(size(I_code)+2);
[m,n]=size(pI_code);
pI_code(2:end-1,2:end-1)=I_code;
pI_branches(2:end-1,2:end-1)=I_branches;
index=find(pI_code>Limit);
index=[index-m;index-m-1;index-m+1;index-1;index+1;index+m;index+m-1;index+m+1];
index(index<1)=1;
index(index>m*n)=m*n;
rseg=unique(I_branches(index));
I_branches3=repmat(I_branches,1,1,numel(rseg))-repmat(reshape(rseg,1,1,[]),size(I_code));
I_branches3(I_branches3~=0)=1;
I_branches3=prod(I_branches3,3);


I_skel3=I_skel.*I_branches3+double(I_code>2);
I_branches3=bwlabel(I_branches3);
disp(['Number of remaining branches is equal to ' num2str(max(max(I_branches3)))])
figure,
subplot(2,2,1)
imshow(I_branches)
title('Branches before')
subplot(2,2,3)
imagesc(I_branches)
axis equal tight off
subplot(2,2,2)
imshow(I_branches3)
title('Branches after')
subplot(2,2,4)
imagesc(I_branches3)
axis equal tight off
I_code3=code_branches(I_skel3);


%% iii)
Unq=unique(I_branches);
Unq(1)=[];
Rep_branches=repmat(I_branches,1,1,numel(Unq));
Rep_values=repmat(reshape(Unq,1,1,[]),size(I_branches));
I_branches3a=double(Rep_branches==Rep_values);
Modfr=sum(sum(I_branches3a));
Modfr(Modfr<4)=0;
Modfr(Modfr~=0)=1;
Modfr=repmat(Modfr,size(I_branches));
I_branches3a=sum((I_branches3a.*Modfr),3);
I_skel3a=I_branches3a+double(I_code>2);
I_code3a=code_branches(I_skel3a);
I_branches3a=bwlabel(I_branches3a);
disp(['Number of remaining branches is equal to ' num2str(max(max(I_branches3a)))])
figure
subplot(1,2,1)
imagesc(I_branches3a)
axis equal tight off
subplot(1,2,2)
imshow(I_branches3a)

%% iv and v)
lambda=11;
[m,n]=size(I_code3a);
[r,c]=find((I_code3a==3)+(I_code3a==4));
rmin1=r-3; rmax1=r+3; cmin1=c-3; cmax1=c+3;
rmin2=r-lambda-3; rmax2=r+lambda+3; cmin2=c-lambda-3; cmax2=c+lambda+3;

rmin1(rmin1<1)=1; cmin1(cmin1<1)=1;
rmin2(rmin2<1)=1; cmin2(cmin2<1)=1;
rmax1(rmax1>m)=m; cmax1(cmax1>n)=n;
rmax2(rmax2>m)=m; cmax2(cmax2>n)=n;

I_branches3b=I_branches3a;

for i=1:numel(r)
    select_window=zeros(size(I_code3a));
    select_window(rmin1(i):rmax1(i),cmin1(i):cmax1(i))=1;
    select_branch=select_window.*I_branches3a;
    Unq=unique(select_branch);
    Unq(Unq==0)=[];
    if numel(Unq)==3
        analysis_window=zeros(size(I_code3a));
        analysis_window(rmin2(i):rmax2(i),cmin2(i):cmax2(i))=1;
        analysis_branch=analysis_window.*I_branches3a;
        Npix(1)=sum(sum(I_branches3a==Unq(1)));
        Npix(2)=sum(sum(I_branches3a==Unq(2)));
        Npix(3)=sum(sum(I_branches3a==Unq(3)));
        sNpix=sort(Npix);
        [x,y]=find(analysis_branch==Unq(1));
        p1=polyfit(x,y,1);
        u1=[p1(2)/p1(1),p1(2)]/sqrt(p1(2)^2/p1(1)^2+p1(2)^2);
        [x,y]=find(analysis_branch==Unq(2));
        p2=polyfit(x,y,1);
        u2=[p2(2)/p2(1),p2(2)]/sqrt(p2(2)^2/p2(1)^2+p2(2)^2);
        [x,y]=find(analysis_branch==Unq(3));
        p3=polyfit(x,y,1);
        u3=[p3(2)/p3(1),p3(2)]/sqrt(p3(2)^2/p3(1)^2+p3(2)^2);
        theta(1)=dot(u2,u3);
        theta(2)=dot(u1,u3);
        theta(3)=dot(u1,u2);
        theta=abs(theta);
        thetac=theta;
        thetac(theta==max(theta))=[];
        index=find(theta==max(theta));
        if sNpix(1)>=lambda
            if (max(theta)>0.85) && ((thetac(1)<=0.55) || (thetac(2)<=0.55))
                if numel(I_branches3b==Unq(index))<=round(5*lambda/6)
                    I_branches3b(I_branches3b==Unq(index))=0;
                end
            end
            if (max(theta)>0.85) && ((thetac(1)>0.55 && thetac(1)<0.85) || (thetac(2)>0.55 && thetac(2)<0.85))
                if numel(I_branches3b==Unq(index))<=round(3*lambda/2)
                    I_branches3b(I_branches3b==Unq(index))=0;
                end
            end
        end
        if (sNpix(1)<lambda)% && (sNpix(2)>=lambda) && (sNpix(3)>=lambda)
            if (max(theta)>0.8) && (thetac(1)<0.8) && (thetac(2)<0.8)
                I_branches3b(I_branches3b==Unq(index))=0;
            end
        end
    end
end
I_skel3b=double((I_branches3b~=0)+(I_code3a>2));
I_code3b=code_branches(I_skel3b);
figure
subplot(1,2,1)
imagesc(I_branches3b)
axis equal tight off
subplot(1,2,2)
imshow(I_branches3b)