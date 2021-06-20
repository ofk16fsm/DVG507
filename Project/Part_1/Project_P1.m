

classdef Project_P1
   % PROJECT_P1 Tiff data reader & viewer
   % Minimize the impulse noise
   % Find edge of the result image
   
   properties
       
   end
   methods
       function obj = Project_P1()
           
       end
       
       function im = readData(~, data)           
%            las_file = Tiff(data, 'r+');
%            im = double(read(las_file))/255;
           [A, R, bb]= geotiffread(data);
           im = A;
           %im = double(imread(obj.dataname))/255;
       end
       
       function showData(~, imData, figTitle, imTitle)          
           figure('Name',figTitle), 
           imshow(imData), title(imTitle);
       end
       
       function medFilt = getMedFilt(~, imData)
           medFilt = medfilt2(imData);
       end
       
       function [r,g,b] = getRGB(~, imData)
          r = imData(:,:,1);
          g = imData(:,:,2);
          b = imData(:,:,3);           
       end
       
       function getSubplot(~, figTitle, images, imgTitles)
           figure('Name', figTitle),
           for i=1:length(images)
               if length(images) <= 3
                   subplot(3,1,i), imshow(images{i}), title(imgTitles(i));               
               elseif length(images) <= 4
                   subplot(2,2,i), imshow(images{i}), title(imgTitles(i));
               elseif length(images) <= 6
                   subplot(3,2,i), imshow(images{i}), title(imgTitles(i));
               end               
           end
       end     
       
       function bw = getBinarize(~, imData)
           bw = imbinarize(imData);           
       end
       
       function edgeResult = findEdges(obj, imData, strelAlt, r)
           se = strel(strelAlt, r);
           imDataBW_d = imdilate(imData, se);
           edgeResult = double(imDataBW_d) ~= double(imData);
       end
       
       function closeResult = getMorphClose(~, imData)
           closeResult = bwmorph(imData, 'close', 1);        
       end
             
       function getImprofile(~, figTitle, imData, xPos, yPos, imTitle)
           figure('Name', figTitle),           
           improfile(imData, xPos, yPos),
           title(imTitle), 
           grid on;
       end
       
   end
   
end