function [PastDisp, FutDisp fp] = ebma2( f1, f2, f3, N, Dmax)
% N is the dimension of the block (NxN)
% f1 is target frame
% f2 is past reference frame
% f3 is future reference frame
[height, width] = size(f2);
pmvx = zeros(size(f2,1)/N, size(f2,2)/N);
pmvy = zeros(size(f2,1)/N, size(f2,2)/N);
fmvx = zeros(size(f2,1)/N, size(f2,2)/N);
fmvy = zeros(size(f2,1)/N, size(f2,2)/N);
temp = zeros(size(f2,1)+Dmax*2, size(f2,2)+Dmax*2);
temp(Dmax+1:end-Dmax, Dmax+1:end-Dmax) = f2(:,:);
f2 = temp;
temp = zeros(size(f3,1)+Dmax*2, size(f3,2)+Dmax*2);
temp(Dmax+1:end-Dmax, Dmax+1:end-Dmax) = f3(:,:);
f3 = temp;
for i=1:N:height-N+1
    for j=1:N:width-N+1
        MAD_min = 256;
        for k=-Dmax:1:Dmax
            for l=-Dmax:1:Dmax
                MAD = sum(sum(abs(f1(i:i+N-1,j:j+N-1)-...
                    (f2(i+Dmax+k:i+Dmax+k+N-1, j+Dmax+l:j+Dmax+l+N-1)+...
                    f3(i+Dmax-k:i+Dmax-k+N-1, j+Dmax-l:j+Dmax-l+N-1))/2)))/(N*N);
                if (MAD < MAD_min)
                    MAD_min = MAD;
                    pdx = k;
                    pdy = l;
                    fdx = -k;
                    fdy = -l;
                end
            end
        end      
        fp(i:i+N-1,j:j+N-1)= (f2(i+Dmax+pdx:i+Dmax+pdx+N-1,j+Dmax+pdy:j+Dmax+pdy+N-1)+...
            f3(i+Dmax+fdx:i+Dmax+fdx+N-1,j+Dmax+fdy:j+Dmax+fdy+N-1))/2; 
        iblk = floor(i/N)+1;
        jblk = floor(j/N)+1;
        pmvx(iblk,jblk) = pdx;
        pmvy(iblk,jblk) = pdy;
        fmvx(iblk,jblk) = fdx;
        fmvy(iblk,jblk) = fdy;
    end
end
PastDisp = cat(3, pmvx, pmvy);
FutDisp = cat(3, fmvx, fmvy);
end

