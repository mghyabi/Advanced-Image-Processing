function [GCE,LCE]=compute_GCE_LCE_loopy(Seg,GT)

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
mL2=reshape(1:n2,1,1,[]);
mL2=repmat(mL2,size(mL1));
mL1=sum(mL4.*mL2,3);

[m,n]=size(L1);
LCE=0;
GCE=0;
den1=sum(sum(L4));
den1=den1(:);
den2=sum(sum(mL4));
den2=den2(:);
for i=1:m
    for j=1:n
        ES1S2=sum(sum((L4(:,:,L1(i,j)).*abs(mL4(:,:,mL1(i,j))-1))))/den1(L1(i,j));
        ES2S1=sum(sum((mL4(:,:,mL1(i,j)).*abs(L4(:,:,L1(i,j))-1))))/den2(mL1(i,j));
        LCE=LCE+min([ES1S2,ES2S1]);
        GCE=GCE+[ES1S2,ES2S1];
    end
end
LCE=LCE/numel(L1);
GCE=min(GCE)/numel(L1);

end
