% This function creates a 4x4 matrix with the input translation parameters.
function T = translate(x, y, z)
    % Define the matrix to hold the returned matrix
    startmatrix = eye(4);
    % Now we define the translation of the matrix.
    startmatrix(1,4) = x;
    startmatrix(2,4) = y;
    startmatrix(3,4) = z;
    % Return the result
    T = startmatrix;
end