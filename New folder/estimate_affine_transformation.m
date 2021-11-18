function t=estimate_affine_transformation(P,xyso,xyso_t)
A=nan(2*sum(P~=0),6);
b=nan(2*sum(P~=0),1);
j=1;
for i=1:numel(P)
   if P(i)~=0
       A(j:j+1,:)=[xyso(i,1) xyso(i,2) 0 0 1 0;0 0 xyso(i,1) xyso(i,2) 0 1];
       b(j:j+1)=[xyso_t(P(i),1);xyso_t(P(i),2)];
      j=j+2;
   end
end
t=pinv(A)*b;
end