%% Test Centroid drawing.
% This currently reads a picture from the hard drive, finds the centroid,
% adds a crosshair to the original image, and then displays the image.

close all; clear all; clc

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
%img = imread('green_Copper.jpg');
img = imread('blue_Copper.jpg');
%img = imread('yellow_Copper.jpg');

% Show the snapshot
% imshow(img)

% Now we want to pass in the image to some filters. The first filter we
% should do is isolate all colors but the correct color.
% What is returned is an image that is black and white. The white blob is
% the object we want.
%filteredimg = find_Green_blob_copper(img);
filteredimg = find_Blue_blob_copper(img);
%filteredimg = find_Yellow_blob_copper(img);

% Next we want to get rid of all the last dots in the image.

% removes all connected components (objects) that have fewer than 
% P pixels from the binary image BW, producing another binary image, BW2. 
% The default connectivity is 8 for two dimensions, 26 for three 
% dimensions, and conndef(ndims(BW), 'maximal') for higher dimensions. 
% This operation is known as an area opening. 
minimumPix = 50;
blob1 = bwareaopen(filteredimg, minimumPix);
    
% Display the filtered image.
%imshow(blob1);

% Now we find the centroid of the object in the camera frame.
% Ilabel = bwlabel(blob1);
stat = regionprops(blob1,'centroid');

% Display the centroid of the blob.
disp("Centroid");
disp(stat) % need to do the floor() command

% THis is the size including the porches. The actual image is 640x480.
% disp(size(blob1))

% Now we need to edit the color image so that the centroid has a
% cross-hairs over it.
% The function crosshair returns a matrix of 1's and 0's to denote if the
% pixel should be black or not. Eventually, it will take in an image and a
% centroid and return the new image with the crosshair on it.

% This line below simply reminds us what the image in matlab is named.
% imshow(img)

% Here we create the new image with the given centroid.
centroid = cat(1, stat.Centroid);
centrow = centroid(1,1);
centcolumn = centroid(1,2);

centrow = floor(centrow);
centcolumn = floor(centcolumn);

% Create our crosshair matrix.
overlaycross = crosshair(size(img), centrow, centcolumn)';
 %disp(overlaycross)

% disp("Image size");
% disp(size(img));

newcrossimage = img; % zeros(size(img,1), size(img, 2), 3);
% size(img,2)

pause(0.25);

% We will overlay the crosshair over the old image file.
for L=1:826 % row controller 826 if 2, 571 if 1
   for Y=1:571 % Column controller
%        disp(img(L,Y,:))
        if(overlaycross(L, Y) == 1)
            newcrossimage(Y,L, 1:3) = [255 255 255];
        else
            newcrossimage(Y,L, 1:3) = img(Y,L, 1:3);
        end
   end
end

imshow(newcrossimage);

% If we so choose, we can write the jpg to a file.
% imwrite(colorfiltered, 'filtered_green_Copper.jpg');


