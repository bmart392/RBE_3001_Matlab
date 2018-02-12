%% This function creates the interval of joint angles required to change.

% Instead of finding the inverse kinematics geometrically, we are using the
% jacobian to figure out the joint angles. In this case, however, we are
% feeding in the delta, not the whole change, so that the arm moves in
% steps, not all at once.

% Both angle column vectors are in degrees.
% The 'qd' term is the wanted set of joint angles.
% The 'q0' term is the current aset of joint angles.
function deltaQ = inversejacobtaylor(qd, q0, threshold)

% q0 are the current angles in a column vector
% qd are the wanted angles in a column vector

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
currentJacobian = jaboc0(q0);

% This is the forward_kinematics of the initial conditions
currentForwardKinematics = forward_kinematics(q0);

% This is the final position forward_kinematics
finalForwardKinematics = forward_kinematics(qd);

% Now we need to take the inverse of 'initialJacobian' linear component
% and multiply it with the result of:
% ( final position column vector - starting position column vector )
% Notice that I specifically chose to use pinv(), the pseudoinverse
% This matrix should be a 3x1 matrix of changes in angles.
deltaBeforeThresh = pinv(currentJacobian(1:3,:)) * ...
    (finalForwardKinematics - currentForwardKinematics);

% Here we change the delta elements to 0 if the difference is not enough.
% Remember, the forwardkin outputs a 4x3 matrix where the part that we want
% is the last row, which is [ X Y Z ];
for k=1:3 % 1,2,3 for x,y,z
    if (abs(finalForwardKinematics(4,k) - ...
            currentForwardKinematics(4,k)...
            ) < thresh(k,1) )
        deltaBeforeThresh(k,1) = 0; % aka. no change
    end
end

% Note, when you are using this function, you will need to test to see if
% all 3 terms in the column vector are non-zero. If they are all 0, then 
% you need to stop iterating through the loop that uses this function.
deltaQ = deltaBeforeThresh;

end