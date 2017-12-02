bodyDetector = vision.CascadeObjectDetector('UpperBody'); 
bodyDetector.MinSize = [60 60];
bodyDetector.MergeThreshold = 10;
I2 = imread('C:\Users\maythitirat\Desktop\image\nude\mes2.jpg');
bboxBody = step(bodyDetector, I2);
IBody = insertObjectAnnotation(I2, 'rectangle',bboxBody,'Upper Body');
figure, imshow(IBody), title('Detected upper bodies');