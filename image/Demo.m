%% K-means Segmentation (option: K Number of Segments)
%% initialize
clc
clear all
close all
%%
%select = 'g';
%
%if select == 'r'
 %   a = 255;
 %   b = 0;
  %  c = 0;
%elseif select == 'g'
 %   a = 0;
 %   b = 240;
 %   c = 0;
%elseif select == 'b'
 %   a = 0;
%    b = 0;
%    c = 255;
%end

%% Load Image
I = im2double(imread('taken2.jpg'));
figure, imshow(I); title('Input Image'), impixelinfo
% Load Image
I = imresize(I, [256 256]);
IG = rgb2gray(I);
F = reshape(I,size(I,1)*size(I,2),3);                 % Color Features
%% K-means
K     = 3;                                            % Cluster Numbers
CENTS = F( ceil(rand(K,1)*size(F,1)) ,:);             % Cluster Centers
DAL   = zeros(size(F,1),K+2);                         % Distances and Labels
KMI   = 10;                                           % K-means Iteration
for n = 1:KMI
   for i = 1:size(F,1)
      for j = 1:K  
        DAL(i,j) = norm(F(i,:) - CENTS(j,:));      
      end
      [Distance, CN] = min(DAL(i,1:K));               % 1:K are Distance from Cluster Centers 1:K 
      DAL(i,K+1) = CN;                                % K+1 is Cluster Label
      DAL(i,K+2) = Distance;                          % K+2 is Minimum Distance
   end
   for i = 1:K
      A = (DAL(:,K+1) == i);                          % Cluster K Points
      CENTS(i,:) = mean(F(A,:));                      % New Cluster Centers
      if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
end

X = zeros(size(F));
for i = 1:K
idx = find(DAL(:,K+1) == i);
X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
end
T = reshape(X,size(I,1),size(I,2),3);
figure, imshow(T); title('segmented'), impixelinfo
T = uint8(T*255);
T = rgb2gray(T);
figure, imshow(T); title('Gray Scale'), impixelinfo
%%
[rr cc] = size(T);
for ii = 1:rr
    for jj = 1:cc
        if T(ii,jj) >= 0 && T(ii,jj) <= 50
            T(ii,jj) = 255;
        else
            T(ii,jj) = 0;
        end
    end
end
figure, imshow(T); title('Threshold - segmented'), impixelinfo
bw = bwareaopen(T,800);
%% Show
figure, imshow(bw); title('Remove Noise - segmented'), impixelinfo
disp('number of segments ='); disp(K)
%%
bww = bw.* IG;
figure, imshow(bww)
%%
%temp = imread('b.jpg');
%%temp_r = mean(mean(temp(:,:,1)));
%temp_g = mean(mean(temp(:,1,:)));
%temp_b = mean(mean(temp(:,:,3)));

%[rt ct kt] = size(I);

%for it = 1:rt
 %   for jt = 1:ct
%        for kkt = 1:kt
%        if bw(it,jt) == 1
%            bw(it,jt,1) = round(temp_r);
%            bw(it,jt,2) = round(temp_g);
 %          I(it,jt,1) = a;
%           I(it,jt,2) = b;
 %          I(it,jt,3) = c;
%        end
%        end
 %   end
%end
%bw = bw*255;
%figure, imshow(I),impixelinfo
% out = cat(3,I1,I2,I3);
% figure, imshow(out)
