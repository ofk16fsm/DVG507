classdef Shape
    properties
        shpData
    end
    methods
        function obj = Shape(shpData)
            obj.shpData = shpData;
        end
        
        function shp = readShape(obj)
            for n=1:length(obj.shpData)
                shp = {shaperead(obj.shpData(n))};
            end
        end
        
        function showShapes(obj, figTitle)
           data = obj.readShape();
           figure('Name', figTitle),
           for n=1:length(data)
               mapshow(data{n}, 'Marker', 'o', 'MarkerFaceColor', 'red', 'MarkerSize', 5, 'LineStyle', ':'), title('Shape');
           end
        end
        
        function shpInfo = getShapeInfo(obj)
           for n=1:length(obj.shpData)
              shpStruct = shapeinfo(obj.shpData(n));
              shpInfo = struct2table(shpStruct, 'AsArray', true);
           end            
        end
    end
    
end
        