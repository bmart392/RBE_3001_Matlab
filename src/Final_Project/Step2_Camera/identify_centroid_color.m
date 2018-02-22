function [color blob_centroid] = identify_centroid_color(image)

% To determine which function to use, determine the area of white space
% produced by each filter and choose the color that has the most area

% Filter the image for each color
filteredimage_green = find_Green_blob_copper(image);
filteredimage_blue = find_Blue_blob_copper(image);
filteredimage_yellow = find_Yellow_blob_copper(image);

% Clean up each image
minimumPix = 50;
blob_green = bwareaopen(filteredimage_green, minimumPix);
blob_blue = bwareaopen(filteredimage_blue, minimumPix);
blob_yellow = bwareaopen(filteredimage_yellow, minimumPix);

% Find the centroid and area of each blob
green_stats = regionprops(blob_green);
blue_stats = regionprops(blob_blue);
yellow_stats = regionprops(blob_yellow);

% Determine if the image conatined any of the specific color
num_rows_green = size(green_stats,1);
num_rows_blue = size(blue_stats,1);
num_rows_yellow = size(yellow_stats,1);

% Set the default color to choose
largest_area = 0;

% Check if the most green is in the image
if num_rows_green
    if green_stats.Area > largest_area
        largest_area = green_stats.Area;
        color = "Green";
    end
end
% Check if the most  blue is in the image
if num_rows_blue
    if blue_stats.Area > largest_area
        largest_area = blue_stats.Area;
        color = "Blue";
    end
end
% Check if the most yellow is in the image
if num_rows_yellow
    if yellow_stats.Area > largest_area
        largest_area = yellow_stats.Area;
        color = "Yellow";
    end
else
    error('No matching color was found');
end

blob_centroid = largest_area(1).Centroid;
%blob_centroid(2,1) = largest_area.Centroid(1,2);
%
% % Display the centroid of the blob.
% disp("Centroid");
% disp(stat) % need to do the floor() command
%
% % THis is the size including the porches. The actual image is 640x480.
% % disp(size(blob1))
%
% % Now we need to edit the color image so that the centroid has a
% % cross-hairs over it.
% % The function crosshair returns a matrix of 1's and 0's to denote if the
% % pixel should be black or not. Eventually, it will take in an image and a
% % centroid and return the new image with the crosshair on it.
%
% % This line below simply reminds us what the image in matlab is named.
% % imshow(image)
%
% % Here we create the new image with the given centroid.
% centroid = cat(1, stat.Centroid);
% centrow = centroid(1,1);
% centcolumn = centroid(1,2);
%
% centrow = floor(centrow);
% centcolumn = floor(centcolumn);
%
% % Create our crosshair matrix.
% overlaycross = crosshair(size(image), centrow, centcolumn)';
%
%
% newcrossimage = image; % zeros(size(image,1), size(image, 2), 3);
% % size(image,2)
%
% pause(0.25);
%
% % We will overlay the crosshair over the old image file.
% for L=1:826 % row controller 826 if 2, 571 if 1
%    for Y=1:571 % Column controller
% %        disp(image(L,Y,:))
%         if(overlaycross(L, Y) == 1)
%             newcrossimage(Y,L, 1:3) = [255 255 255];
%         else
%             newcrossimage(Y,L, 1:3) = image(Y,L, 1:3);
%         end
%    end
% end
%
% imshow(newcrossimage);

end