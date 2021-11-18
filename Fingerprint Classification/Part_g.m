%% i)
C=zeros(10);
for i=1:10
    for j=1:7
        Mss=Ms(i,j,:);
        Mss=Mss(:);
        index=find(Mss==max(Mss));
        C(i,index)=C(i,index)+1;
    end
end

disp(C)
   
%% ii)

disp(['Accuracy is equal to ' num2str(sum(diag(C)/sum(sum(C))))])