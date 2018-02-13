%% This function creates the interval of joint angles required to change.
% All angles in degrees.
% qi are the current angles in a column vector
% q0 are the starting angles in a column vector
% pd are the wanted position in a column vector
% deltaQ is a 1x2 vector. the first element is the deltaQ, the second one
% is a true/false for the while loop conditional statement.
function deltaQ = inverse_kin_jacobs(pd, q0, qi, threshold)

% Initialize the threshold value holder.
thresh = zeros(3,1);

% This code simply defaults the threshold value when a zero matrix is
% passed in.
if (threshold == zeros(3,1))
    thresh = [ 0.002; 0.002; 0.002]; % These terms are all in meters.
else
    thresh = abs(threshold);  % only positive values!!
end

% This is the forward kinematics of where we started from.
startpos = forward_kinematics(q0);
startposition = startpos(4,:);

% This is the starting position jacobian with degrees.
a = jacob0(q0);

% This is the top part of the jacobian.
b = a(1:3,:);

% This is the pseudo inverse of the top part of the jacobian.
c = pinv(b);

% Where we want to go.
finalForwardKinematics = pd;

% this is the forward kinematics of the current location.
currentpos = forward_kinematics(qi);
currentposition = currentpos(4,:)';
    
disp((finalForwardKinematics - currentposition));
% Here we do the actual delta q calculations, returning degrees.
deltaBeforeThresh = (180/pi).*(c*(finalForwardKinematics...
    - currentposition)');
disp(" delta Q degrees: "); disp(deltaBeforeThresh);

% This is where we check to see if the loop needs to keep occuring.
if ( (abs(finalForwardKinematics(1,1) - currentposition(1,1)) > ...
        thresh(1,1)) || ...
        (abs(finalForwardKinematics(2,1) - currentposition(2,1)) > ...
        thresh(2,1)) || ...
        (abs(finalForwardKinematics(3,1) - currentposition(3,1)) > ...
        thresh(3,1)) )
    deltaQ = cat(2, deltaBeforeThresh, [ 1 1 1 ]');
else
    deltaQ = cat(2, deltaBeforeThresh, [ 0 0 0 ]');
end

end