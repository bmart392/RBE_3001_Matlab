% We are assuming that the angle is already in radians.
function T = trotx(theta)
    % Define the matrix to hold the returned matrix
    startmatrix = eye(4);
    % Now we define what the rotations should be.
    % We focus on the upper left corner 3x3.
    startmatrix(2,2) = cos(theta);
    startmatrix(2,3) = -sin(theta);
    startmatrix(3,2) = sin(theta);
    startmatrix(3,3) = cos(theta);
    % Return the result
    T = startmatrix;
end