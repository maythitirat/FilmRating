
% STEP 1: Use getHSVColorFromDirectory(dirName) in order to estimate the
% average HSV values of your objects of interest.

HSV = getHSVColorFromDirectory('train');

%
% The above function call will let the user choose manually (through simple
% mouse clicks) several "seeds" from each image.
% At the end the HSV matrix contains M rows (M is the total number of jpeg files
% in dirName): each row corresponds to the average HSV value of the
% selected seeds in the respective image.
% The average (or median) value of this matrix (column-wise) can be used,
% in the sequence for detecting the speficic color values.
%

% STEP 2: Use the estimated (average) hsv value for detecting the specified
% color in a specific image.

%colorDetectHSV('balls.JPG', median(HSV), [0.05 0.05 0.2]);
RGB = imread('balls.JPG');

HSV = rgb2hsv(RGB);

% find the difference between required and real H value:
diffH = abs(HSV(:,:,1) - );

[M,N,t] = size(RGB);
I1 = zeros(M,N); I2 = zeros(M,N); I3 = zeros(M,N);

T1 = tol(1);

I1( find(diffH < T1) ) = 1;

if (length(tol)>1)
    % find the difference between required and real S value:
    diffS = abs(HSV(:,:,2) - hsvVal(2));    
    T2 = tol(2);
    I2( find(diffS < T2) ) = 1;    
    if (length(tol)>2)
        % find the difference between required and real V value:
        difV = HSV(:,:,3) - hsvVal(3);    
        T3 = tol(3);
        I3( find(diffS < T3) ) = 1;
        I = I1.*I2.*I3;
    else
        I = I1.*I2;
    end
else
    I = I1;    
end

subplot(1,2,1),imshow(RGB); title('Original Image');
subplot(1,2,2),imshow(I,[]); title('Detected Areas');

