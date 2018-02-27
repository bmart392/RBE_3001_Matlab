% Auto-generated by cameraCalibrator app on 27-Feb-2018
%-------------------------------------------------------


% Define images to process
imageFileNames = {'/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image1.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image2.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image3.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image4.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image5.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image6.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image7.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image8.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image9.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image10.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image11.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image12.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image13.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image14.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image15.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image16.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image17.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image18.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image19.png',...
    '/adhome/bgmart/RBE3001_Matlab_Team_C18_01/src/Final_Project/Pictures/Checkerboard_Testing/Image20.png',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 25;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 3, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
%h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
%h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
%displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
