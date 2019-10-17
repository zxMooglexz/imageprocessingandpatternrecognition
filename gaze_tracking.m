clear all;

camera = webcam();  % create webcam object

% Create a detector for face using Viola-Jones
faceDetector = vision.CascadeObjectDetector(); 

% Create detector for the Eye Pair
eyesDetector = vision.CascadeObjectDetector('EyePairSmall'); 

% Loop infinitely tracking
while true 
    
    % Get a snapshot of webcam
    webcamSnap = snapshot(camera);  
    
    % Convert to grayscale this improves accuracy of pupil direction
    % detection
    webcamSnap = rgb2gray(webcamSnap);  
    stillImg = flip(webcamSnap, 2); % Flips the image horizontally because our image is flipped from the camera
    
    faceBoundingBox = step(faceDetector, stillImg); % Creating bounding box using detector  
      
    if ~isempty(faceBoundingBox)  % Check if our face exists 
        biggestBox = 1; % There is a minimum of 1 bounding box so the biggest is currently the first     
        for i=1:rank(faceBoundingBox) % find the biggest face
            if faceBoundingBox(i, 3) > faceBoundingBox(biggestBox, 3)
                biggestBox = i;
            end
        end

        faceImage = imcrop(stillImg, faceBoundingBox(biggestBox,:)); % Get the face from the image
        eyesBoundingBox = step(eyesDetector, faceImage); % Get the bounding box of the eyepair

        % Displays webcam shot
        subplot(2,1,1), 
        imshow(stillImg); 
        hold off; 

        % Draw a box around the largest face detected
        rectangle('position', faceBoundingBox(biggestBox, :), 'lineWidth', 2, 'edgeColor', 'r');

        % Display face image
        subplot(2,2,3), imshow(faceImage);     

        % Check if eyes are found
        if ~ isempty(eyesBoundingBox)  

            biggestBoxEyes = 1; % There is a minimum of 1 bounding box so the biggest is currently the first   
            for i=1:rank(eyesBoundingBox) % find the biggest eyepair
                if eyesBoundingBox(i,3) > eyesBoundingBox(biggestBoxEyes,3)
                    biggestBoxEyes = i;
                end
            end

            % Get the left eye in the bounding box
            leftEye = [eyesBoundingBox(biggestBoxEyes, 1), eyesBoundingBox(biggestBoxEyes, 2), eyesBoundingBox(biggestBoxEyes, 3) / 3, eyesBoundingBox(biggestBoxEyes, 4)];  

            % Draw a box around each eye
            rectangle('position', eyesBoundingBox(biggestBoxEyes, :), 'lineWidth', 2, 'edgeColor', 'b');

            % Extract the left eye from the eyepair in the main image
            eyesImage = imcrop(faceImage, leftEye(1,:));
            
            % Adjust contrast for better pupil detection
            eyesImage = imadjust(eyesImage); 
            
            % Get the center of the eye
            boundingEyeCenter = leftEye(1, 4) / 4; 

            minEyeSize = floor(boundingEyeCenter - boundingEyeCenter / 4); % Radius for the smallest possible pupil
            maxEyeSize = floor(boundingEyeCenter + boundingEyeCenter / 2); % Radius for the largest possible pupil

            % Since the imfindcircles accuracy is very little below a
            % radius of 5 we will skip
            if minEyeSize > 5
                % Using hough transfrom to extract the pupil. This is done
                % using the dark ObjectPolarity settings
                [centers, radii] = imfindcircles(eyesImage, [minEyeSize, maxEyeSize], 'ObjectPolarity','dark', 'Method', 'TwoStage', 'Sensitivity', 0.93); 
                
                % Show the eyes frame
                subplot(2, 2, 4), imshow(eyesImage); hold off; 

                if ~isempty(centers)
                    pupil = centers(1);
                    
                    % Draw the pupil circle
                    viscircles([centers(1), centers(2)], radii(1), 'EdgeColor','y');
                    
                    distanceLeft = abs(0 - pupil); % Distance from left edge to center point
                    distanceRight = abs(eyesBoundingBox(1,3) / 3 - pupil); % Distance from right edge to center point
                   
                    % Check to see if the pupil is left or right of center
                    % or center
                    if distanceLeft > distanceRight + (radii * 2)
                        disp("Looking Right");
                    else
                        if distanceRight > distanceLeft - radii
                            disp("Looking Left");
                        else
                            disp("Looking Straight");
                        end
                    end
                end   
            end
        end
    end
end
