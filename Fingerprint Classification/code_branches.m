function I_code=code_branches(I_skel)
[m,n]=size(I_skel);
% shifting all neighbors to each coordinate and summing them in the next nine lines(Padded image)
I1=[zeros(2,n+2); zeros(m,1) I_skel zeros(m,1)];
I2=[zeros(2,n+2); I_skel zeros(m,2)];
I3=[zeros(1,n+2); I_skel zeros(m,2); zeros(1,n+2)];
I4=[I_skel zeros(m,2); zeros(2,n+2)];
I5=[zeros(m,1) I_skel zeros(m,1); zeros(2,n+2)];
I6=[zeros(m,2) I_skel; zeros(2,n+2)];
I7=[zeros(1,n+2); zeros(m,2) I_skel; zeros(1,n+2)];
I8=[zeros(2,n+2); zeros(m,2) I_skel];
I_code=(I1+I2+I3+I4+I5+I6+I7+I8);
%reverting to original size and removing pixels which had zero intensity in
%th e original image by pixelwise multipication to I_skel
I_code=I_code(2:end-1,2:end-1).*I_skel;
end