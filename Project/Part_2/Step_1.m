classdef Step_1
    properties
  
    end
    
    methods
        function obj = Step_1()
          
        end
        
        function elevation = getElevation(~, imData, threshold)
            elevation = double(imData)/threshold;
            elevation = flipud(elevation);
        end
        
        function [X, Y] = getMeshgrid(~, newsize)
            [X, Y] = meshgrid(linspace(0,2500,newsize), linspace(0,2500,newsize));
        end
        
        function [nx,ny,nz] = getNormalVectors(~, X, Y, elevation)
            [nx,ny,nz] = surfnorm(X,Y,elevation);
        end
        
        function normals = getReshape(~, nxyz, newsize, n)
            normals = reshape(nxyz, newsize, newsize, n);
        end
        
        function drawinglayer = getDrawlayer(~, row, col, newsize, elevation, drawinglayer)
            xPos = row;
            yPos = col;
            for i=1:newsize
                drawinglayer = tracevisibilityline(xPos(i),yPos(i),500,i,elevation,drawinglayer);
                drawinglayer = tracevisibilityline(xPos(i),yPos(i),i,500,elevation,drawinglayer);
                drawinglayer = tracevisibilityline(xPos(i),yPos(i),1,i,elevation,drawinglayer);
                drawinglayer = tracevisibilityline(xPos(i),yPos(i),i,1,elevation,drawinglayer);
            end
        end
        
        function result = getCombineWalk(~, imData, drawinglayer)
            result = double(drawinglayer) .* imData;
        end
    end
end