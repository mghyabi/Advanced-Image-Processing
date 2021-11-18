%% i)
I1=double(imread('a i screenshot.jpg'))/255;
figure
imshow(I1)
title('Screenshot of command prompt window')

I2=double(imread([cd '\siftDemoV4\scene.pgm']))/255;
figure
imshow(I2)
title('Original Scene Image')

I3=double(imread([cd '\siftDemoV4\result.pgm']))/255;
figure
imshow(I3)
title('SIFT Result Image')

%% ii)
system('siftDemoV4\siftWin32 -display<scene.pgm>result.pgm')

I=double(imread('result.pgm'))/255;
figure
imshow(I)
title('SIFT Result Image')

%% iii)
system('siftDemoV4\siftWin32 <scene.pgm>result.key')
fID=fopen('result.key');
C1=fscanf(fID,'%d',[1 2]);
C2=fscanf(fID,'%f',[1 4]);
C3=fscanf(fID,'%d',[6 20]);
C4=fscanf(fID,'%d',[1 8]);
fclose(fID);

C1=num2str(C1);
C2=num2str(C2);
C3=num2str(C3);
C4=num2str(C4);

n=[size(C1,2);size(C2,2);size(C3,2);size(C4,2);];

C=[[C1 repmat(' ',1,max(n)-n(1))];[C2 repmat(' ',1,max(n)-n(2))];[C3 repmat(' ',1,max(n)-n(3))];[C4 repmat(' ',1,max(n)-n(4))]];

disp('The first nine lines of "result.key":' )
disp(C)

%% iv)
I=double(imread([cd '\siftDemoV4\scene.pgm']))/255;
res=[1 2 4 8 16 32]';
N=nan(6,1);
for i=1:6
    I1=imresize(I,size(I)/res(i));
    imwrite(I1,'Image.pgm')
    system('siftDemoV4\siftWin32 <Image.pgm>result.key')
    fID=fopen('result.key');
    N(i)=fscanf(fID,'%d',[1 1]);
    fclose(fID);
end

figure
plot(res,N,'LineWidth',2)
grid on
axis tight
xlabel('res factor')
ylabel('number of keypoints')

%% v)
system('siftDemoV4\siftWin32 <scene.pgm>result.key')
I=double(imread([cd '\siftDemoV4\scene.pgm']))/255;
fID=fopen('result.key');
N=fscanf(fID,'%d',[1 2]);
N=N(1);
Data=nan(N,4);
for i=1:N
    Line=fscanf(fID,'%f',[1 4]);
    Data(i,:)=Line;
    fscanf(fID,'%d',[1 128]);
end
fclose(fID);

AmpFactor=6;
ArrowAngle=7*pi/6;

x2y2=[Data(:,1)+AmpFactor*Data(:,3).*cos(Data(:,4)+pi/2) Data(:,2)+AmpFactor*Data(:,3).*sin(Data(:,4)+pi/2)];
x3y3=[x2y2(:,1)+Data(:,3).*cos(Data(:,4)+pi/2+ArrowAngle) x2y2(:,2)+Data(:,3).*sin(Data(:,4)+pi/2+ArrowAngle)];
x4y4=[x2y2(:,1)+Data(:,3).*cos(Data(:,4)+pi/2-ArrowAngle) x2y2(:,2)+Data(:,3).*sin(Data(:,4)+pi/2-ArrowAngle)];

figure
imshow(I)
hold on
% scatter(Data(:,2),Data(:,1),'+','c')
% scatter(x2y2(:,2),x2y2(:,1),'+','r')
for i=1:N
   line([Data(i,2) x2y2(i,2)], [Data(i,1) x2y2(i,1)],'color','y')
   line([x3y3(i,2) x2y2(i,2)], [x3y3(i,1) x2y2(i,1)],'color','y')
   line([x4y4(i,2) x2y2(i,2)], [x4y4(i,1) x2y2(i,1)],'color','y')
end
