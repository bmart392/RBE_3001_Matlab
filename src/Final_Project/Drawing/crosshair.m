%% Crosshair generation
% This creates the matrix to overlay a black crosshair over an image. This
% function creates the crosshair matrix that is a square denoted by side
% length n.
% imagexy is => size(img)
function cross = crosshair(imagexy, centroidrow, centroidcolumn)

% Line thickness
line_thickness = 4;

% Say n equals 40 for now. This is the side length of the crosshair.
cross_height_width = 40;

% Image dimensions
imagerow = imagexy(1,1); 
disp(imagerow);
imagecolumn = imagexy(1,2); 
disp(imagecolumn);

% Center of matrix start.
centleft = centroidrow-(line_thickness/2);

centright = centroidrow+(line_thickness/2);

centup = centroidcolumn-(line_thickness/2);

centdown = centroidcolumn +(line_thickness/2);

% This will hold our values.
startmatrix = zeros(imagerow, imagecolumn);

% Now we fill in the vertical component of the cross hair.
for i=centleft:centright % The column controller, crosshair width
    for c=centroidcolumn-(cross_height_width/2):centroidcolumn+(cross_height_width/2) % The row controller crosshair length
        startmatrix(c,i) = 1;
    end
end

% Now we fill in the horizontal component of the cross hair.
for i=centroidrow-(cross_height_width/2):centroidrow+(cross_height_width/2) % The row controller, crosshair width
    for c=centup:centdown  % The column controller crosshair length
        startmatrix(c,i) = 1;
    end
end


% Now we return the crosshairs matrix. Remember, set the RGB values to 1 to
% make them black.

cross = startmatrix;

end