function [GCE,LCE]=compute_GCE_LCE_Mehrdad(Seg,GT)

L1=Seg+1;
n1=numel(unique(L1));
L2=reshape(1:n1,1,1,[]);
L2=repmat(L2,size(L1));
L3=repmat(L1,1,1,n1);
L4=L3-L2;
L4(L4~=0)=1;
L4=abs(L4-1);

mL1=GT+1;
n2=numel(unique(mL1));
mL2=reshape(unique(mL1),1,1,[]);
mL2=repmat(mL2,size(mL1));
mL3=repmat(mL1,1,1,n2);
mL4=mL3-mL2;
mL4(mL4~=0)=1;
mL4=abs(mL4-1);

[~,~,m]=size(L4);
[~,~,n]=size(mL4);
LCE=zeros(2,m*n);
GCE1=0;
GCE2=0;
den1=sum(sum(L4));
den1=den1(:);
den2=sum(sum(mL4));
den2=den2(:);
p=1;
for i=1:m
    for j=1:n
        Num1=sum(sum(L4(:,:,i).*abs(mL4(:,:,j)-1)));
        Num2=sum(sum(mL4(:,:,j).*abs(L4(:,:,i)-1)));
        np=L4(:,:,i)+mL4(:,:,j);
        np(np~=2)=0;
        np=sum(sum(np/2));
        if (np~=0 && Num1~=0 )
            GCE1=GCE1+np*(Num1/den1(i));
            LCE(p)=np*(Num1/den1(i));
        end
        p=p+1;
        if (np~=0 && Num2~=0 )
            GCE2=GCE2+np*(Num2/den2(j));
            LCE(p)=np*(Num2/den2(j));
        end
        p=p+1;
    end
end
LCE=sum(min(LCE))/numel(L1);
GCE=min([GCE1,GCE2])/numel(L1);

end