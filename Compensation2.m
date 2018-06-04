function [dopt, newImg] = Compensation2(Fframe,Sframe,Tframe, n, dopt12, dopt32)
M = size(Fframe,1);
N = size(Fframe,2);

l=1;
m=1;
newImg = uint8(zeros(M, N));
dopt = zeros(M/n, N/n);

    for i=1:n:M
       for j=1:n:N
         Sblockd = Sframe(i:i+n-1,j:j+n-1);
         %Image One
         x = real(dopt12(l,m));
         y = imag(dopt12(l,m));
         Fblockd = Fframe(i+x:i+x+n-1,j+y:j+y+n-1);
          %Image Third
         x3 = real(dopt32(l,m));
         y3 = imag(dopt32(l,m));
         Tblockd = Tframe(i+x3:i+x3+n-1,j+y3:j+y3+n-1);
         
         MAD12 = sum(sum(imabsdiff(Fblockd,Sblockd)))/(n*n);
         MAD32 = sum(sum(imabsdiff(Tblockd,Sblockd)))/(n*n);
                        
         if(MAD12<MAD32)
           dopt(l,m)= +x + 1i*(y);
           newImg(i:i+n-1, j:j+n-1)= Fframe(i+x:i+x+n-1,j+y:j+y+n-1);
         else
           dopt(l,m)= +x3 + 1i*(y3);
           newImg(i:i+n-1, j:j+n-1)= Tframe(i+x3:i+x3+n-1,j+y3:j+y3+n-1);
         end
          m=m+1;   
      end
     m=1;
     l=l+1;
    end
end