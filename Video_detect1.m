clc;
      clear all;
      obj=vision.VideoFileReader('123.mpg','VideoOutputDataType', 'uint8');
       FaceDetect = vision.CascadeObjectDetector('eyepairbig');
       for k=0:99
      videoFrame = step(obj);
           %FaceDetect
            BB = step(FaceDetect,videoFrame);
            %BB
             figure(2),imshow(videoFrame);
      for i = 1:size(BB,1)
           rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
      end
      %crop faces and convert it to gray
      for i = 1:size(BB,1)
      J= imcrop(videoFrame,BB(i,:));
      I=(imresize(J,[292,376]));
      %save cropped faces in folder
      filename = ['H:\Personal\Eye_video\database\' num2str(i+k*(size(BB,1))) '.jpg'];
          imwrite(I,filename);
      end
      end
    