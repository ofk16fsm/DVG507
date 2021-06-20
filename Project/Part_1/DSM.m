classdef DSM
    % DSM create an object of DSM image
    % Get walkable area
    % Get biggest walkable area
    
    properties
        imData
    end
    
    methods
        function obj = DSM(imData)
            obj.imData = imData;
        end
        
        function result = getWalkAreaDSM(~, dsmMedian, edge)
            % gt = graythresh(dsmMedian);
            dsmMedian = (dsmMedian <= 0.38 & dsmMedian >= 0.045);
            gtDSM = dsmMedian ;
            bwDSM = imbinarize(uint8(gtDSM));
            result = bwDSM .* edge;            
        end
        
        function biggest = getBiggest(~, imData)
            [L, num] = bwlabel(imData, 8);
            regionMeasurements = regionprops(L, 'basic');  

            allAreas = [regionMeasurements.Area];

            [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
            
            new_Biggest = 0;

            for m = 1:2000
                new_Biggest = new_Biggest + (L  == sortIndexes(m));
            end

            biggestArea1 = sortedAreas(1:1);
            biggestArea2 = sortedAreas(2:2);
            biggestArea3 = sortedAreas(3:3);
            % new_Biggest = (L  == sortIndexes(1));
            fprintf('Biggest area 1: %d\nBiggest area 2: %d\nBiggest area 3: %d\n', ...
                    biggestArea1, biggestArea2, biggestArea3);
%             % Multiply with the original to segment just the biggest area
%             double(new_Biggest);
             biggest = new_Biggest;
        end
    end
end