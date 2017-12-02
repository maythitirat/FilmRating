clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
folder = 'C:\Users\maythitirat\Desktop\image\rifle';
fontSize = 20;
baseFileName = '213.jpg';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
	% Didn't find it there.  Check the search path for it.
	fullFileName = baseFileName; % No path this time.
	if ~exist(fullFileName, 'file')
		% Still didn't find it.  Alert user.
		errorMessage = sprintf('Error: %s does not exist.', fullFileName);
		uiwait(warndlg(errorMessage));
		return;
	end
end
%grayImage=imread(fullFileName);
I=imread(fullFileName);
I=double(I);
[hue,s,v]=rgb2hsv(I);
cb =  0.148* I(:,:,1) - 0.291* I(:,:,2) + 0.439 * I(:,:,3) + 128;
cr =  0.439 * I(:,:,1) - 0.368 * I(:,:,2) -0.071 * I(:,:,3) + 128;
[w h]=size(I(:,:,1));
for i=1:w
    for j=1:h            
        %if  140<=cr(i,j) && cr(i,j)<=165 && 140<=cb(i,j) && cb(i,j)<=195 && 0.01<=hue(i,j) && hue(i,j)<=0.1
        if  0<=cr(i,j) && cr(i,j)<=145 && 0<=cb(i,j) && cb(i,j)<=190 && 0.01<=hue(i,j) && hue(i,j)<=1.0
            segment(i,j)=1;            
        else       
            segment(i,j)=0;    
        end    
    end
end
 %imshow(segment);
im(:,:,1)=I(:,:,1).*segment;   
im(:,:,2)=I(:,:,2).*segment; 
im(:,:,3)=I(:,:,3).*segment; 
%figure,imshow(uint8(im));

grayImage=im;
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(grayImage);
if numberOfColorBands > 1
	% It's not really gray scale like we expected - it's color.
	% Convert it to gray scale by taking only the green channel.
	grayImage = grayImage(:, :, 2); % Take green channel.
    
end
% Display the original gray scale image.
subplot(2, 2, 1);
imshow(grayImage, []);
axis on;
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off') 
binaryImage = grayImage < 40;
% Display the image.
subplot(2, 2, 2);
imshow(binaryImage, []);
title('Binary Image', 'FontSize', fontSize);
% Label the image
labeledImage = bwlabel(binaryImage);
measurements = regionprops(labeledImage, 'BoundingBox', 'Area');

for k = 1 : length(measurements)
  thisBB = measurements(k).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 )
end
% Let's extract the second biggest blob - that will be the hand.
allAreas = [measurements.Area];
[sortedAreas, sortingIndexes] = sort(allAreas, 'descend');
handIndex = sortingIndexes(1); % The hand is the second biggest, face is biggest.
% Use ismember() to extact the hand from the labeled image.
sum = sum(handIndex);
disp(sum);
handImage = ismember(labeledImage, handIndex);
% Now binarize
handImage = handImage > 0;
% Display the image.
subplot(2, 2, 3);
imshow(handImage, []);
title('Hand Image', 'FontSize', fontSize);

folder = 'C:\Users\maythitirat\Desktop\image\rifle';
baseFileName = 'rifle.jpg';
fullFileNameBase = fullfile(folder, baseFileName);
boxImage = rgb2gray(imread(fullFileNameBase));
%show image file
figure;
imshow(boxImage);
boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(segment);
figure;
imshow(boxImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 100));
figure;
sceneImage = segment;
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));
[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
%match between object and scene
boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');
[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');
boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
newBoxPolygon = transformPointsForward(tform, boxPolygon);
figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');