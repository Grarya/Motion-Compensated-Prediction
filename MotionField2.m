function [dopt, newImg] = MotionField2(Fframe,Sframe, Tframe,n,Dmax)
[M, N] = size(Fframe);
dopt = zeros(M/n, N/n);
l=1;
m=1;
newImg = uint8(zeros(M, N));
%Padding
temp = uint8(zeros(M+2*Dmax, N+2*Dmax));
temp(Dmax+1:end-Dmax, Dmax+1:end-Dmax) = Fframe;
Fframe = temp;
temp(Dmax+1:end-Dmax, Dmax+1:end-Dmax) = Tframe;
Tframe = temp;

%Reference Image
    for i=1:n:M-n+1
       for j=1:n:N-n+1
         MADRef = 300;
         Fblockd = Sframe(i:i+n-1,j:j+n-1);
         %Image
         for x=-Dmax:1:Dmax
            for y=-Dmax:1:Dmax
                Sblockd = 0.5*Fframe(Dmax+x+i:Dmax+x+i+n-1,Dmax+y+j:Dmax+y+j+n-1);
                Tblockd = 0.5*Tframe(Dmax-x+i:Dmax-x+i+n-1,Dmax-y+j:Dmax-y+j+n-1);
                MAD = sum(sum((imabsdiff(Fblockd,imadd(Sblockd,Tblockd)))))/(n*n);
                if(MAD<MADRef)
                    MADRef = MAD;
                    dopt(l,m)= +x + 1i*(y);
                    xo=x;
                    yo=y;
                end        
            end
          end
          newImg(i:i+n-1, j:j+n-1)= imadd(0.5*Fframe(Dmax+xo+i:Dmax + xo+i+n-1,Dmax + yo+j:Dmax+yo+j+n-1), 0.5*Tframe(Dmax-xo+i:Dmax-xo+i+n-1,Dmax-yo+j:Dmax-yo+j+n-1));
          m=m+1;   
      end
     m=1;
     l=l+1;
    end
end