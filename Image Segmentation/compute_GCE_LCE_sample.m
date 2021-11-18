function [UhBvybLpCs,UhBvybLpCr] = compute_GCE_LCE_sample(UhBvybLpC1,UhBvybLpC2)
UhBvybLpCg=min(min(UhBvybLpC1));
UhBvybLpCx=max(max(UhBvybLpC1));
UhBvybLpCl=min(min(UhBvybLpC2));
UhBvybLpCe=max(max(UhBvybLpC2));
UhBvybLpCA=zeros(UhBvybLpCx+1,UhBvybLpCe+1);
for UhBvybLpC3=UhBvybLpCg:UhBvybLpCx
    for UhBvybLpC4=UhBvybLpCl:UhBvybLpCe
        UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1)=sum(sum((UhBvybLpC1==UhBvybLpC3)&(UhBvybLpC2==UhBvybLpC4)));
    end
end
UhBvybLpCd=0;
UhBvybLpCa=0;
UhBvybLpCr=0;
UhBvybLpCY=0;
for UhBvybLpC3=UhBvybLpCg:UhBvybLpCx
    for UhBvybLpC4=UhBvybLpCl:UhBvybLpCe
        if UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1)>0
            UhBvybLpCk=(sum(sum(UhBvybLpCA(UhBvybLpC3+1,:)))-UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1))/sum(sum(UhBvybLpCA(UhBvybLpC3+1,:)));
            UhBvybLpCm=(sum(sum(UhBvybLpCA(:,UhBvybLpC4+1)))-UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1))/sum(sum(UhBvybLpCA(:,UhBvybLpC4+1)));
            UhBvybLpCd=UhBvybLpCd+UhBvybLpCk*UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1);
            UhBvybLpCa=UhBvybLpCa+UhBvybLpCm*UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1);
            UhBvybLpCr=UhBvybLpCr+min(UhBvybLpCk,UhBvybLpCm)*UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1);
            UhBvybLpCY=UhBvybLpCY+UhBvybLpCA(UhBvybLpC3+1,UhBvybLpC4+1);
        end
    end
end
UhBvybLpCs=min(UhBvybLpCd,UhBvybLpCa)/(UhBvybLpCY);
UhBvybLpCr=UhBvybLpCr/(UhBvybLpCY);
% Created by pyminifier (https://github.com/liftoff/pyminifier)