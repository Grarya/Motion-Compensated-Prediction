function [q] = PlotField2(Rframe,Sframe,Tframe, n, dopt1, dopt2)

dopt1=-dopt1*1;
dopt2=-dopt2*1;

M = size(Rframe,1);
N = size(Rframe,2);

[X, Y] = meshgrid(n/2:n:N,n/2:n:M);
figure;
subplot(1,3,1); imshow(Rframe);title('First frame');
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
subplot(1,3,2); imshow(Sframe);title('Second frame: Motion field');
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
q = quiver(X(:),Y(:),real(dopt1(:)),imag(dopt1(:)),'AutoScale','on','color','r');
q = quiver(X(:),Y(:),real(dopt2(:)),imag(dopt2(:)),'AutoScale','on','color','b');
hold off;
subplot(1,3,3); imshow(Tframe);title('Third frame');
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
end