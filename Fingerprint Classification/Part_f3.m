tic
Sim=cell(10,7,10);
for i=1:10
   for j=1:10
       for k=1:7
           Sim{j,k,i}=similarity_level(Input{j,k},Temp{i});
       end
   end
   disp(i)
end
toc