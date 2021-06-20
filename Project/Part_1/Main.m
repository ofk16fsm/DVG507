clc

% Data
demData = 'lasDataDEM.tif';
dsmData = 'lasDataDSM.tif';
ortoIRData = 'IRComb.tif';
shpFiles = ["mp_get.shp", "ml_get.shp", "mv_get.shp", "ma_get.shp", "mb_get.shp", "mo_get.shp", "my_get.shp"];

% Create an instance of Project_P1
p1 = Project_P1();

% DEM
dem = DEM(demData);
imDEM = p1.readData(demData);
medDEM = p1.getMedFilt(imDEM);
% p1.showData(imDEM, 'DEM', 'DEM of las files');
% p1.showData(medDEM, 'DEM', 'Filtered DEM');

% OrtofotoIR
orto = Ortofoto(ortoIRData);
imOrto = p1.readData(ortoIRData);
imOrto = double(imOrto)/255;
p1.showData(imOrto, 'Ortofoto', 'Ortofoto IR');
[nir, red, green] = p1.getRGB(imOrto);
images = {nir, red, green}; img_titles = ["Nir", "Red", "Green"];
% p1.getSubplot('RGB Images', images, img_titles);
ndvi = orto.getNDVI(nir, red);
% p1.showData(ndvi, 'Ortofoto', 'Normalized Difference Vegetation Index');
ndvi_t = orto.getNDVIThreshold(ndvi, 0.0000001);
% p1.showData(ndvi_t, 'Ortofoto', 'NDVI with threshold');
ndwi = orto.getNDWI(nir, green);
% p1.showData(ndwi, 'Ortofoto', 'Normalized Difference Water Index');
ndwi_t = orto.getNDWIThreshold(ndwi, 0.095);
% p1.showData(ndwi_t, 'Ortofoto', 'NDWI with threshold');
resultOrto = orto.getResultOrto(red, ndvi_t, ndwi_t);
p1.showData(resultOrto, 'Ortofoto', 'Result of ortofoto');

% Image classification
% Training sites and groups
g = [1 1 1 1 1 2 2 2 2 2 ];
g1 = [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4]; 
t = [0.2093 -0.1304 % Forest
    0.1862 -0.1316
    0.1717 -0.1048
    0.2169 -0.1543
    0.2097 -0.1450
    -0.1389 0.2152 % Water
    -0.09756 0.1494
    -0.14 0.2037
    -0.1507 0.2051
    -0.1316 0.1951];

t1 = [0.1373 0.1608 % Water
     0.1451 0.1529
     0.1412 0.1647
     0.1882 0.2157
     0.1333 0.1569
     0.3529 0.3608 % Forest
     0.3804 0.3725
     0.4392 0.4431
     0.3255 0.3216
     0.3765 0.3882
     0.5686 0.5608 % Open area
     0.6941 0.6824
     0.6118 0.6039
     0.5294 0.5216
     0.5608 0.5333
     0.5569 0.5294 % Road
     0.6431 0.6235
     0.5765 0.5529
     0.5412 0.5255
     0.5373 0.5098];

imageClass = ImageClassification(resultOrto, green);
v = imageClass.getDouble(); 

% Supervised classification
supervised = imageClass.getSupervised(v, t1, g1, nir); 
% Unsupervised classification
unsupervised = imageClass.getUnsupervised(v, 3, nir); 
% Binary image of supervised classification
superBW = p1.getBinarize(supervised(:,:,1)); 
% Binary image of unsupervised classification
unsuperBW = p1.getBinarize(unsupervised(:,:,1)); 
% Result of supervised classification
resultSupervised = imageClass.getResultClassification(superBW, ndvi_t, ndwi_t); 
% Result of unsupervised classification
resultUnsupervised = imageClass.getResultClassification(unsuperBW, ndvi_t, ndwi_t);  
% p1.showData(resultSupervised, 'Classification', 'Result of supervised classification');
% p1.showData(resultUnsupervised, 'Classification', 'Result of unsupervised classification'); 


% Edge results
% You can choose disk, square and cube.
edge = p1.findEdges(resultSupervised, 'square', 2); 
% p1.showData(edge, 'Edge', 'Edge of result biggest DSM');

% DSM
dsm = DSM(dsmData);
imDSM = p1.readData(dsmData);
imDSMD = double(imDSM)/255;
medDSM = p1.getMedFilt(imDSMD);
% medDSMBW = p1.getBinarize(resultOrto(:,:,1));
resultDSM = dsm.getWalkAreaDSM(medDSM, edge);
imBiggest = dsm.getBiggest(resultDSM);
% p1.showData(imDSM, 'DSM', 'DSM of las files');
% p1.showData(medDSM, 'DSM', 'Filtered DSM');
% p1.showData(resultDSM, 'DSM', 'Result of DSM');
% p1.showData(imBiggest, 'DSM', 'Result of biggest area');

resultImages = {resultOrto, resultDSM, resultSupervised, resultUnsupervised};
resultImgTitles = ["Result of ortofoto", "Result of DSM", "Result of supervised classification", "Result of unsupervised classification"];
p1.getSubplot('Result images', resultImages, resultImgTitles);
close = p1.getMorphClose(imBiggest);
p1.showData(close, 'Close', 'Result of morphological closing');

% Improfile
xPos = [595 638 658 677]; yPos = [300 230 157 138];
titleText = "Intensity value of a road with coordinate " ...
               + "(595,300),(638,230),(658,157),(677,138)";
p1.getImprofile('Intensity value',imDSM, xPos, yPos, titleText);

% Shape
shp = Shape(shpFiles);
shpData = shp.readShape();

shp.showShapes('Shape');
shpDesc = shpData{1}.DETALJTYP;
fprintf('Shape description: %s\n', shpDesc);

shpInfo = shp.getShapeInfo();
fprintf('Shape type: %s\n', shpInfo.ShapeType{1});
fprintf('Shape BoandingBox: %s\n', shpInfo.BoundingBox{1});
fprintf('Shape NumFeatures: %d\n', shpInfo.NumFeatures(1));