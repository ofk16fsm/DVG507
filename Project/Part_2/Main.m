clc

% Data
walkData = 'myTiffDSM.tif';
demData = 'lasDataDEM.tif';

% New size for image
newsize = 500;

p2 = Project_P2();
s1 = Step_1();

walkIm = p2.readData(walkData);
demIm = p2.readData(demData);

resampledWalkIm = p2.getResampleData(walkIm, newsize, 'nearest');
resampledWalkIm = double(resampledWalkIm)/255;
resampledWalkIm = flipud(resampledWalkIm);
% p2.showData(resampledWalkIm, 'Test', 'Test');
resampledDemIm = p2.getResampleData(demIm, newsize, 'nearest');

elevation = s1.getElevation(resampledDemIm, 256.0);
selectedElevation = min(elevation(:));
[row, col] = find(ismember(elevation, selectedElevation));

% Create X and Y grid points
[X,Y] = s1.getMeshgrid(newsize);

% Calculate normal vectors
[nx,ny,nz] = s1.getNormalVectors(X,Y,elevation);
nxyz = [nx,ny,nz];
% 3 500x500 arrays need to be reshaped into a newsize x newsize x 3 array
normals = s1.getReshape(nxyz,newsize,3);

% Create a data array that serves as a "drawing" layer
drawinglayer = uint8(zeros(newsize,newsize));
drawinglayer(250,250) = 200;
drawinglayer = s1.getDrawlayer(row, col, newsize, elevation, drawinglayer);
drawinglayerBW = p2.getBinarize(drawinglayer);

walkSize = size(find(resampledWalkIm(:) >= 0.906));

visibleWalk = s1.getCombineWalk(resampledWalkIm, drawinglayerBW);
visibleWalkSize = size(find(visibleWalk == 250));

invDrawinglayer = p2.getInvert(drawinglayer);
noVisibleWalk = s1.getCombineWalk(resampledWalkIm, invDrawinglayer);

find1 = find(visibleWalk > 0);
find2 = find(noVisibleWalk > 0);

newImage = zeros(newsize, newsize);
newImage(find1) = 255;
newImage(find2) = 150;

percentage = visibleWalkSize / walkSize;

%p2.showSurface(X,Y,elevation,newImage,normals,'Surface','Result of visible & novisible area');
p2.getSubplot('Result of pie percentage and surface',percentage,X,Y,elevation,newImage, ...
    normals,'Result of visible & novisible area');



