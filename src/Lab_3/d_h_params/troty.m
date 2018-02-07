% We are assuming that the angle is already in radians.
function T = troty(theta)
    % Define the matrix to hold the returned matrix
    startmatrix = eye(4);
    % Now we define what the rotations should be.
    % We focus on the upper left corner 3x3.
    startmatrix(1,1) = cos(theta);
    startmatrix(1,3) = sin(theta);
    startmatrix(3,1) = -sin(theta);
    startmatrix(3,3) = cos(theta);
    % Return the result
    T = startmatrix;
end