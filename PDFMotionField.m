function [Vx,cx, Vy, cy] = PDFMotionField(dopt)

x = real(dopt); 
y = imag(dopt);

Vx = unique(x); %Find the unique values in a matrix
Vy = unique(y); %Find the unique values in a matrix
cx =  histcounts(x,length(Vx),'Normalization','probability'); %Count the number of values that correspond to vector C
cy =  histcounts(y,length(Vy),'Normalization','probability'); %Count the number of values that correspond to vector C

Hx = (-1*log2(cx(cx~=0)))*cx(cx~=0)';
Hy = (-1*log2(cy(cy~=0)))*cy(cy~=0)';


figure;
subplot(1,2,1); bar(Vx,cx); xlabel('x'); ylabel('Px'); title(['Entropy: ', num2str(Hx),' bits/xpos']);grid on;
subplot(1,2,2); bar(Vy,cy); xlabel('y'); ylabel('Py'); title(['Entropy: ', num2str(Hy),' bits/ypos']);grid on;

end