function [xyso,F]=create_feature_matrices(key_filename)
fID=fopen(key_filename);
K=fscanf(fID,'%d',[1 1]);
fscanf(fID,'%d',[1 1]);
xyso=nan(K,4);
F=nan(K,128);
for i=1:K
    xyso(i,:)=fscanf(fID,'%f',[1 4]);
    F(i,:)=fscanf(fID,'%d',[1 128]);
end
fclose(fID);
end