%% Part 8: Object Localization
% uses a function that takes in a framE from the camera,
% identifies the centroid of a solid colored spherical tracking object
% and overlays a marker on the display video feed
% colors are blue, yellow or green. 

close all; clear all;

% Instantiate hardware (turn on camera)
if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

% Preview what the camera sees
% preview(cam)

% Next we take a snapshot from the camera
% img = snapshot(cam);

% Here we import an image from the hard drive.
img = imread('green_Copper.jpg');

% Show the snapshot
% imshow(img)

% Now we want to pass in the image to some filters. The first filter we
% should do is isolate all colors but the correct color.
% What is returned is an image that is black and white. The white blob is
% the object we want.
filteredimg = find_Green_blob_copper(img);

% Next we want to get rid of all the last dots in the image.

% removes all connected components (objects) that have fewer than 
% P pixels from the binary image BW, producing another binary image, BW2. 
% The default connectivity is 8 for two dimensions, 26 for three 
% dimensions, and conndef(ndims(BW), 'maximal') for higher dimensions. 
% This operation is known as an area opening. 
minimumPix = 20;
blob1 = bwareaopen(filteredimg, minimumPix);
    
% Display the filtered image.
imshow(blob1);

% Now we find the centroid of the object in the camera frame.
% Ilabel = bwlabel(blob1);
stat = regionprops(blob1,'centroid');

% Display the centroid of the blob.
disp("Centroid");
disp(stat) % need to do the floor() command

% THis is the size including the porches. The actual image is 640x480.
disp(size(blob1))

% Now we need to edit the color image so that the centroid has a
% cross-hairs over it.
% The function crosshair returns a matrix of 1's and 0's to denote if the
% pixel should be black or not. Eventually, it will take in an image and a
% centroid and return the new image with the crosshair on it.

% This line below simply reminds us what the image in matlab is named.
% imshow(img)

% Here we create the new image with the given centroid.
% centx = floor(stat(1,1));
% centy = floor(stat(1,2));

% Make sure the size is correct for the new image.
newBWimage = zeros(size(blob1));




% If we so choose, we can write the jpg to a file.
% imwrite(colorfiltered, 'filtered_green_Copper.jpg');


