function [dopt, newImg] = MotionField(Rframe,Sframe,n,Dmax)

%Input:
%   Rframe: Reference frame
%   Sframe: Current frame
%        n: Block size
%     Dmax: Maximum search distance


M = size(Rframe,1);
N = size(Rframe,2);
dopt = zeros(M/n, N/n);
l=1;
m=1;
newImg = uint8(zeros(M, N));

%Reference Image
    for i=1:n:M
       for j=1:n:N
         MADRef = 300;
         Fblockd = Sframe(i:i+n-1,j:j+n-1);
         %Image
         for x=-Dmax:1:Dmax
                for y=-Dmax:1:Dmax
                   if(x+i>=1)&&(y+j>=1)&&(y+j+n-1<=N)&&(x+i+n-1<=M)
                       Sblockd = Rframe(x+i:x+i+n-1,y+j:y+j+n-1);
                       MAD = sum(sum((imabsdiff(Fblockd,Sblockd))))/(n*n); %Mean Absolute Diff
                       if(MAD<MADRef)
                       MADRef = MAD;
                       dopt(l,m)= +x + 1i*(y);
                       xo=x;
                       yo=y;
                       end        
                    end
                 end
          end
          newImg(i:i+n-1, j:j+n-1)= Rframe(i+xo:i+xo+n-1,j+yo:j+yo+n-1);
          m=m+1;   
      end
     m=1;
     l=l+1;
    end
    
end