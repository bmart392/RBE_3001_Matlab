% This function determines which colors are present in the image and
% returns the most populated color and the centroid fo that blob.
% INPUT: image = a standard JPG image that has already been read in
% OUPUT: centroid_color = a struct with two fields. The first is the color
% which is a string and the second is a 1 x 2 array that holds the
% centroid

function  centroid_color  = identify_centroid_color(image)

% To determine which function to use, determine the area of white space
% produced by each filter and choose the color that has the most area

% Blur the image to remove small color sections
blurred_image = imfilter(image,ones(3)/15);
imshow(blurred_image);


% Filter the image for each color
filteredimage_green = find_Green_blob_copper(blurred_image);
filteredimage_blue = find_Blue_blob_copper(blurred_image);
filteredimage_yellow = find_Yellow_blob_copper(blurred_image);

% Clean up each image
minimumPix = 100;
blob_green = bwareaopen(filteredimage_green, minimumPix);
blob_blue = bwareaopen(filteredimage_blue, minimumPix);
blob_yellow = bwareaopen(filteredimage_yellow, minimumPix);
imshow(blob_blue);

% Find the centroid and area of each blob
green_stats = regionprops(blob_green);
blue_stats = regionprops(blob_blue);
yellow_stats = regionprops(blob_yellow);

% Determine if the image conatined any of the specific color
num_rows_green = size(green_stats,1);
num_rows_blue = size(blue_stats,1);
num_rows_yellow = size(yellow_stats,1);

% Initialize largest area to ensure that any area is accepted at first
largest_area = 0;

% Check if the most green is in the image
if num_rows_green
    if green_stats.Area > largest_area
        largest_area = green_stats.Area;
        centroid_color.Color = "Green";
        centroid_color.Centroid = green_stats.Centroid;
        imshow(blob_green);
    end
end
% Check if the most  blue is in the image
if num_rows_blue
    if blue_stats.Area > largest_area
        largest_area = blue_stats.Area;
        centroid_color.Color = "Blue";
        centroid_color.Centroid = blue_stats.Centroid;
        imshow(blob_blue);
    end
end
% Check if the most yellow is in the image
if num_rows_yellow
    if yellow_stats.Area > largest_area
        centroid_color.Color = "Yellow";
        centroid_color.Centroid = yellow_stats.Centroid;
        imshow(blob_yellow);
    end
end

end

