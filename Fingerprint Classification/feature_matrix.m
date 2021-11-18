function [F3,F]=feature_matrix(I_bin)
I_skel=double(bwmorph(I_bin,'skel',inf));
I_code=code_branches(I_skel);
I_branches=I_skel;
I_branches(I_code>2)=0;
I_branches=bwlabel(I_branches);
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
F(:,isnan(F(3,:)))=[];
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
end