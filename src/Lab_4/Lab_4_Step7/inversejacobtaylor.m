%% This function creates the interval of joint angles required to change.

% Instead of finding the inverse kinematics geometrically, we are using the
% jacobian to figure out the joint angles. In this case, however, we are
% feeding in the delta, not the whole change, so that the arm moves in
% steps, not all at once.

% Both angle column vectors are in degrees.
% The 'pd' term is the wanted final position.
% The 'q0' term is the current set of joint angles.
% q0 are the current angles in a column vector
% pd are the wanted position in a column vector
function deltaQ = inversejacobtaylor(pd, q0, threshold)

% Initialize the threshold value holder.
thresh = zeros(3,1);

% This code simply defaults the threshold value when a zero matrix is
% passed in.
if (threshold == zeros(3,1))
    thresh = [ 0.001; 0.001; 0.001]; % These terms are all in meters.
else
    thresh = abs(threshold);  % only positive values!!
end

% Passing in degrees into the initial conditions to create the jacobian
% that is to be multipied with the deltaQ term.
currentPosJacobian = jacob0(q0);
currentPositionJacobian = currentPosJacobian(1:3,:); % only want pos part

% This is the forward_kinematics of the initial conditions
currentPos = forward_kinematics(q0);
currentForwardKinematics = (currentPos(4,:))';       % Grab end pos

finalForwardKinematics = pd;

% Now we need to take the inverse of 'initialJacobian' linear component
% and multiply it with the result of:
% ( final position column vector - starting position column vector )
% Notice that I specifically chose to use pinv(), the pseudoinverse
% This matrix should be a 3x1 matrix of changes in angles.
pseudoinv = pinv(currentPositionJacobian);
deltaBeforeThresh = pseudoinv * ...
    (finalForwardKinematics - currentForwardKinematics);

% Here we change the delta elements to 0 if the difference is not enough.
% Remember, the forwardkin outputs a 4x3 matrix where the part that we want
% is the last row, which is [ X Y Z ];

% disp(thresh);  Thresh is a row vector

for k=1:3 % 1,2,3 for x,y,z
    if ((abs(finalForwardKinematics(k,1) - ...
            currentForwardKinematics(k,1)...
            )) < thresh(k,1) )
        deltaBeforeThresh(k,1) = 0; % aka. no change
    end
end

% Note, when you are using this function, you will need to test to see if
% all 3 terms in the column vector are non-zero. If they are all 0, then 
% you need to stop iterating through the loop that uses this function.
deltaQ = deltaBeforeThresh;

end