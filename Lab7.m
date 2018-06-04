%METHOD 2
clear all;
close all;

%Load 3 consecutive frames of a QCIF yuv 4:2:0 video.
fileName= 'foreman.yuv';
idxFrame = 1:3;
width = 176;
height = 144;
v = loadFileYuv(fileName, 176, 144, idxFrame);

%Get images from the struct
Fframe = v(1).cdata(:,:,1); %Fist frame
Sframe = v(2).cdata(:,:,1); %Second frame
Tframe = v(3).cdata(:,:,1); %Third frame

figure;
subplot(1,3,1); imshow(Fframe);title('First frame');
subplot(1,3,2); imshow(Sframe);title('Second frame');
subplot(1,3,3); imshow(Tframe); title('Third frame');

tic
%Define block size and maximum search distance
n=16;
Dmax=n*4;

%Motion field on the 2nd frame with the 1st one as a reference frame using a block matching algorithm with 16 x 16 macroblocks.
%A referencial value to start the algorithm
[dopt12, newImg12] = MotionField(Fframe, Sframe, n, Dmax);
%Plotting the results 
toc
PlotField(Fframe,Sframe, n, dopt12); 
%Getting the Displaced Frame Difference
figure;
subplot(1,2,1); imshow(Sframe); title('Second frame');
subplot(1,2,2); imshow(newImg12); title('Compensation: 2nd frame from 1st');
DFdiff12 = imabsdiff(newImg12,Sframe);
%Energy of Displaced Frame Difference signal
E_DFdiff12 = sum(DFdiff12(:));
figure;
imshow(DFdiff12);title({'Residual image: 2nd frame from 1st'; ['Energy: ', num2str(E_DFdiff12/1000),'e+3']});

%Motion feld on the second frame using now the third one as a reference frame.
[dopt32, newImg32] = MotionField(Tframe, Sframe, n, Dmax);
PlotField(Tframe, Sframe, n, dopt32);
figure;
subplot(1,2,1); imshow(Sframe); title('Second frame');
subplot(1,2,2); imshow(newImg32); title('Compensation: 2nd frame from 3rd');
DFdiff32 = imabsdiff(newImg32,Sframe);

E_DFdiff32 = sum(abs(DFdiff32(:)));
figure;
imshow(DFdiff32);title({'Residual image: 2nd frame from 3rd'; ['Energy: ', num2str(E_DFdiff32/1000),'e+3']});

%Motion feld on the second frame using both the frst and the third frames
[dopt132, newImg132] = MotionField2(Fframe,Sframe, Tframe,n,Dmax);
PlotField2(Fframe, Sframe, Tframe, n, dopt12, dopt32);

%PlotField2(Fframe, Sframe, Tframe, n, dopt132, -1*dopt132);

figure;
subplot(1,2,1); imshow(Sframe); title('Second frame');
subplot(1,2,2); imshow(newImg132); title('Compensation: 2nd frame from 3rd and 1st');
DFdiff132 = imabsdiff(newImg132,Sframe);

E_DFdiff132 = sum(abs(DFdiff132(:)));
figure;
imshow(DFdiff132);title({'Residual image: 2nd frame from 3rd and 1st'; ['Energy: ', num2str(E_DFdiff132/1000),'e+3']});


%Qualitatively comparison
figure;
subplot(2,3,2); imshow(Sframe); title('Second frame');
subplot(2,3,4); imshow(newImg12); title('Compensation: 2nd frame from 1st');
subplot(2,3,5); imshow(newImg32); title('Compensation: 2nd frame from 3rd');
subplot(2,3,6); imshow(newImg132); title('Compensation: 2nd frame from 3rd and 1st');

%Energy comparison of the residual images
figure;
subplot(1,3,1); imshow(DFdiff12);title({'Residual image: 2nd frame from 1st'; ['Energy: ', num2str(E_DFdiff12/1000),'e+3']});
subplot(1,3,2); imshow(DFdiff32);title({'Residual image: 2nd frame from 3rd'; ['Energy: ', num2str(E_DFdiff32/1000),'e+3']});
subplot(1,3,3); imshow(DFdiff132);title({'Residual image: 2nd frame from 3rd and 1st'; ['Energy: ', num2str(E_DFdiff132/1000),'e+3']});


%PDF of the Second frame
totpix=numel(Sframe);
[pixelCounts, grayLevels] = imhist(Sframe);
Spdf = pixelCounts /totpix; %Normalization

[pixelCounts, grayLevels] = imhist(DFdiff12);
DFdiff12pdf = pixelCounts /totpix; %Normalization

[pixelCounts, grayLevels] = imhist(DFdiff32);
DFdiff32pdf = pixelCounts /totpix; %Normalization

[pixelCounts, grayLevels] = imhist(DFdiff132);
DFdiff132pdf = pixelCounts /totpix; %Normalization

%Obtain the entropies
HSpdf = (-1*log2(Spdf(Spdf~=0)))'*Spdf(Spdf~=0);
HDFdiff12 = (-1*log2(DFdiff12pdf(DFdiff12pdf~=0)))'*DFdiff12pdf(DFdiff12pdf~=0);
HDFdiff32 = (-1*log2(DFdiff32pdf(DFdiff32pdf~=0)))'*DFdiff32pdf(DFdiff32pdf~=0);
HDFdiff132 = (-1*log2(DFdiff132pdf(DFdiff132pdf~=0)))'*DFdiff132pdf(DFdiff132pdf~=0);

figure;
subplot(2, 3, 2); histogram(Sframe, 'Normalization', 'pdf', 'FaceColor','k'); 
title({'Probability density function: 2nd Frame'; ['Entropy: ', num2str(HSpdf),' bits/pixel']}); 
subplot(2, 3, 4); histogram(DFdiff12, 'Normalization', 'pdf', 'FaceColor','r'); 
title({'Prediction error: 1st Frame as reference'; ['Entropy: ', num2str(HDFdiff12),' bits/pixel']}); 
subplot(2, 3, 5); histogram(DFdiff32, 'Normalization', 'pdf', 'FaceColor','r'); 
title({'Prediction error: 3rd Frame as reference'; ['Entropy: ', num2str(HDFdiff32),' bits/pixel']});  
subplot(2, 3, 6); histogram(DFdiff132, 'Normalization', 'pdf', 'FaceColor','r'); 
title({'Prediction error: 1st and 3rd Frame as reference'; ['Entropy: ', num2str(HDFdiff132),' bits/pixel']});  


%Find the entropy of the motion vectors.
[Vx12, cx12, Vy12, cy12] = PDFMotionField(dopt12); %PDF of Motion Field: 1st scheme');
[Vx32, cx32, Vy32, cy32] = PDFMotionField(dopt32); %title('PDF of Motion Field: 2nd scheme');
[Vx132, cx132, Vy132, cy132] = PDFMotionField(dopt132);% title('PDF of Motion Field: 3rd scheme');







