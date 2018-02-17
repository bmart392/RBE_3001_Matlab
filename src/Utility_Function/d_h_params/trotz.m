% We are assuming that the angle is already in radians.
function T = trotz(theta)
    % Define the matrix to hold the returned matrix
    startmatrix = eye(4);
    % Now we define what the rotations should be.
    % We focus on the upper left corner 2x2.
    startmatrix(1,1) = cos(theta);
    startmatrix(1,2) = -sin(theta);
    startmatrix(2,1) = sin(theta);
    startmatrix(2,2) = cos(theta);
    % Return the result
    T = startmatrix;
end