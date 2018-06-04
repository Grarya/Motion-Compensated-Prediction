function [q] = PlotField(Rframe,Sframe,n, dopt)

%Input:
%   Rframe: Reference image
%   Sframe: Current image
%        n: Block size
%     dopt: Motion field

dopt=dopt*-1;

M = size(Rframe,1);
N = size(Rframe,2);

[X, Y] = meshgrid(n/2:n:N,n/2:n:M);
figure;
subplot(1,2,1); imshow(Rframe);title('Reference frame');
hold on;
for k = 1:n:M;
    x = [1 N];
    y = [k k];
    plot(x,y,'Color','k','LineStyle','-');
end
for k = 1:n:N;
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','k','LineStyle','-');
end
hold off;
subplot(1,2,2); imshow(Sframe);title('Motion field');
%Generate the lines for the grid depending on the block size
hold on;
for k = 1:n:M;
    x = [1 N];
    y = [k k];
    plot(x,y,'Color','k','LineStyle','-');
end
for k = 1:n:N;
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','k','LineStyle','-');
end
%Plotting the vectors
q = quiver(X(:),Y(:),real(dopt(:)),imag(dopt(:)),'AutoScale','on','color','r');
hold off;

end