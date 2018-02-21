%% Crosshair generation
% This creates the matrix to overlay a black crosshair over an image. This
% function creates the crosshair matrix that is a square denoted by side
% length n.
% imagexy is => size(img)
function cross = crosshair(imagexy, centroidx, centroidy)

% Line thickness
thicc = 4;

% Say n equals 40 for now. This is the side length of the crosshair.
n = 40;

% Image dimensions
imagex = imagexy(1,2); % 826
disp(imagex);
imagey = imagexy(1,1); % 571
disp(imagey);

% Center of matrix start.
centleft = centroidx-(thicc/2);

centright = centroidx+(thicc/2);

centup = centroidy; %-(thicc/2);

centdown = centroidy + thicc; %+(thicc/2);

% This will hold our values.
startmatrix = zeros(imagex, imagey);

% Now we fill in the vertical component of the cross hair.
for i=centleft:centright % The column controller, crosshair width
    for c=centroidy-(n/2):centroidy+(n/2) % The row controller crosshair length
        startmatrix(c,i) = 1;
    end
end

% Now we fill in the horizontal component of the cross hair.
for i=centroidx-(n/2):centroidx+(n/2) % The row controller, crosshair width
    for c=centup:centdown  % The column controller crosshair length
        startmatrix(c,i) = 1;
    end
end


% Now we return the crosshairs matrix. Remember, set the RGB values to 1 to
% make them black.

cross = startmatrix;

end