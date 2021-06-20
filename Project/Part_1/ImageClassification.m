classdef ImageClassification
   % ImageClassification create supervised and unsupervised classification
   
   properties
       imData1
       imData2
   end
   
   methods
       function obj = ImageClassification(imData1, imData2)
           obj.imData1 = imData1;
           obj.imData2 = imData2;
       end
       
       function v = getDouble(obj)
           v = double([obj.imData1(:), obj.imData2(:)]);
       end
       
       function super = getSupervised(~,v, t_value, g_value, imData)
           classIM = classify(v, t_value, g_value);
           a = vec2mat(classIM, size(imData, 1));
           super = ind2rgb(a', prism);
       end 
       
       function unsuper = getUnsupervised(~, v, threshold, imData)
            idx = kmeans(v, threshold);
            a1 = vec2mat(idx, size(imData, 1));
            unsuper = ind2rgb(a1', prism);
       end

       function result = getResultClassification(~, superBW, ndvi_t, ndwi_t)
            result = superBW .* ndvi_t .* ndwi_t;
       end
   end
end