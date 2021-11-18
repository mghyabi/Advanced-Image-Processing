function ml=matching_level(Fgi,Fgk,sl)
Bg=[8 pi/6 pi/6]';
ml=zeros(size(Fgi,2),size(Fgk,2));
for i=1:size(Fgi,2)
    for j=1:size(Fgk,2)
        if sum(abs(Fgi(i)-Fgk(j))<Bg)==3
           ml(i,j)=0.5+0.5*sl(i,j); 
        end
    end
end
for i=1:size(ml,1)
    for j=1:size(ml,2)
        if sum(sum(ml(i,j)<ml(i,:)))>0 || sum(sum(ml(i,j)<ml(:,j)))>0
            ml(i,j)=0;
        end
    end
end
end