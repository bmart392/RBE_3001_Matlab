function T = cubiccoefficients(startTime, endTime, startVel, endVel, startPosition, endPosition)

% This is the matrix that we will be doing row echelon form on.
rowechmatrix = zeros(4);

% These are the (1,4) matrix for solving for t, t^2, and t^3.
positionInitial = ([0 (startTime) (startTime * startTime) (startTime * startTime * startTime) ]);
positionFinal = ([0 (endTime) (endTime * endTime) (endTime * endTime * endTime) ]);
velocityInitial = ([0 0 (2 * startTime) (3 * startTime * startTime) ]);
velocityFinal = ([0 0 (2 * endTime) (3 * endTime * endTime) ]);

% We are doing the Ax=B form.
% A is the matrix with the 4 matrices above combined into one 4x4 matrix.
% B is the matrix that is the result of plugging in the respective times, aka q(t0), q(tf), q.(t0), q.(tf)
% We are now filling in the A matrix.

rowechmatrix(1,:) = positionInitial;
rowechmatrix(2,:) = positionFinal;
rowechmatrix(3,:) = velocityInitial;
rowechmatrix(4,:) = velocityFinal;

% Now we define the B Matrix.

bMatrix = ([startPosition endPosition startVel endVel]);

% Now we take the inverse of the A matrix. WE SHOULD CHECK TO SEE IF WE CAN OR CANNOT DO THE INVERSE OF THE MATRIX!!!!!!!

inversedA = inv(rowechmatrix);

% Now we multiply the 4x4 inverse matrix (A^-1) with the 4x1 position and velocity matrix (B).

T = inversedA * bMatrix;

end