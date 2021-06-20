classdef Project_P2
    properties
        
    end
    methods
        function obj = Project_P2()
            
        end
        
        function im = readData(~, imData)
            im = imread(imData);
        end

        function showData(~, imData, figTitle, imTitle)          
           figure('Name',figTitle), 
           imshow(imData), title(imTitle);
        end
        
        function showSurface(~, X, Y, elevation, imData, normals, imTitle, walkSubplot)
            s = surf(X,Y,elevation,imData,'VertexNormals',normals,'CDataMapping','scaled'); title(imTitle);
            s.EdgeColor = 'none';
            s.FaceAlpha = 0.75;
            s.FaceLighting = 'gouraud';
            % Set scaling along z-axis to same as x/y (assuming that the data is show
            % in a cube)
            ax = gca;
            ax.ZLim = [0,2500];
            colormap(walkSubplot,[0.2 0.1 0.5
                      0.1 0.5 0.8
                      0.2 0.7 0.6
                      0.8 0.7 0.3
                      0.9 1 0]);

            lighting gouraud;
            view(3);
            camlight('headlight');
        end
        
        function showPercentage(~, percentage, pSubplot)
            percentages = [1-percentage percentage];
            labels = ["Novisible", "Visible"];
            pie(percentages);
            legend(labels, 'Location', 'bestoutside');
            colormap(pSubplot,[ 0 1 0; 1 1 0]);
        end
        
        function getSubplot(obj, figTitle, percentage, X, Y, ...
            elevation, imData, normals, imTitle)
            figure('Name', figTitle),
            pSubplot = subplot(3,2,[1,2]);
            obj.showPercentage(percentage, pSubplot);
            hold on;
            walkSubplot = subplot(3,2,[3 4 5]);
           
            obj.showSurface(X,Y,elevation,imData,normals,imTitle, walkSubplot);
            hold off;
        end
        
        function resampleIm = getResampleData(~, imData, newsize, method)
            resampleIm = imresize(imData, [newsize, newsize], 'Method', method);
        end
                
        function bw = getBinarize(~, imData)
           bw = imbinarize(imData);           
        end
        
        function imcomp = getInvert(~, imData)
            imcomp = imcomplement(double(imData));
        end
    end
end