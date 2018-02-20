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
filteredimg = find_Green_blob_copper(img);

% Extract the color image
colorfiltered = filteredimg(1,1);

% Display the filtered image.
% imshow(colorfiltered);
imwrite(colorfiltered, 'filtered_green_Copper.jpg');
