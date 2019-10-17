clc;

% Reads the video file
% For demonstration purposes 123.mpg is used.
vid = VideoReader('123.mpg');

% Creates a loop of reading each video frame and saving the frame as a png
% file
for img = 1:vid.NumberOfFrames;
    
    filename=strcat('E:\Programs\MATLAB\Eye Tracking\imageEyeTracking\Output\',num2str(img),'.png');
    
    imgFrame = read(vid, img);
    
    imshow(imgFrame);
    
    imwrite(imgFrame,filename);
    
end

f = msgbox('Video conversion completed');

movie(img)