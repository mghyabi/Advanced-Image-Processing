function dp=dPhi(t1,t2)
dp=t1-t2;
dp(dp<-pi)=dp(dp<-pi)+2*pi;
dp(dp>pi)=-dp(dp>pi)+2*pi;
end