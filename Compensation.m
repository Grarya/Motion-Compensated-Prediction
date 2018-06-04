function [newImg] = Compensation(Rframe,n,dopt)
M = size(Rframe,1);
N = size(Rframe,2);

l=1;
m=1;
newImg = uint8(zeros(M, N));
%Reference Image
    for i=1:n:M
       for j=1:n:N
           xo = real(dopt(l,m));
           yo = imag(dopt(l,m));
           newImg(i:i+n-1, j:j+n-1)= Rframe(i+xo:i+xo+n-1,j+yo:j+yo+n-1);
          m=m+1;   
      end
     m=1;
     l=l+1;
    end
end