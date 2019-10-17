% Clears the command window
clc;

% Establishes the eye object detector using Viola-Jones algorithm
eyeDetector = vision.CascadeObjectDetector('EyePairSmall');

% Reads the image file
img = imread('Output\97.png');

% Used to detect the eyes in the image
BB = step(eyeDetector,img);

% Creates a box that shows the detected eyes in the image
eyeLabel = insertObjectAnnotation(img,'rectangle',BB,'Eyes');  

% Displays the detected eyes in an output
% eyeLabel would not be able to mark if only one eye is found
figure, imshow(eyeLabel);

% Creates a title for the display output
title('Detected eyes');

clear all;