
%name of the video input for real time video processing
%in this case, it's the local laptop webcam
vid = videoinput('winvideo');

% Set the properties of the video object
set(vid, 'FramesPerTrigger', Inf);
set(vid, 'ReturnedColorspace', 'rgb');
vid.FrameGrabInterval = 5;

%start the video aquisition here
start(vid)

%Loop to analyse per frame -> configure this value to
% set the duration of the test
while(vid.FramesAcquired<=200)
    
    %capture the image from the video for processing
    data = getsnapshot(vid);
    greyData = rgb2gray(data);
        
   %set up eye detector to detect the eyes category
  eyeDetector = vision.CascadeObjectDetector('EyePairSmall');
  
  %flip the image
  flipedImg = flip(greyData,2);
  
   BB=eyeDetector(flipedImg);

   %insert and display the label
  eyeLabel = insertObjectAnnotation(flipedImg,'rectangle',BB,'Eyes');  
  
  
  
imshow(eyeLabel)
title('Detected Eyes');

end
stop(vid);

