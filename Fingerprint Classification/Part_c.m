clear
close all
for k=101:110
%     figure
    for l=1:8
        dir_name=[cd '\DB1_B_png\'];
        A=double(imread([dir_name num2str(k) '_' num2str(l) '.png']))/255;
        A=abs(A-1);
        A_otsu2=nan(size(A));
        step=30;
        part=10;
        T=nan(part,part);
        for i=1:part
            for j=1:part
                Nghbr=A((i-1)*step+1:(i-1)*step+step,(j-1)*step+1:(j-1)*step+step);
                T(i,j)=1.00*graythresh(Nghbr);
            end
        end
        medT=median(T(:));
        T(T<medT/1.5)=medT/1.5;
        for i=1:part
            for j=1:part
                Nghbr=A((i-1)*step+1:i*step,(j-1)*step+1:j*step);
                A_otsu2((i-1)*step+1:i*step,(j-1)*step+1:j*step)=double(Nghbr>=T(i,j));
            end
        end
        if l==1
            figure
            imshow(A_otsu2)
            title('Thresholded 101_1.png by adaptive otsus method before applying morphological opening')
        end
%         A_otsu2=imerode(A_otsu2,strel('disk',1));
        A_otsu2=imopen(A_otsu2,strel('disk',1));
        Seg=bwlabel(A_otsu2);
        if l==1
            figure(k)
            subplot(1,2,1),imagesc(Seg), axis equal tight off
            title(['Visualization of segmented image ' num2str(k) '-' num2str(l) '.png'])
            subplot(1,2,2),imshow(Seg)
        end
%         subplot(3,3,l)
%         imshow(Seg)
        imwrite(Seg,[cd '\Binary\' num2str(k) '_' num2str(l) '.png'])
    end
end
