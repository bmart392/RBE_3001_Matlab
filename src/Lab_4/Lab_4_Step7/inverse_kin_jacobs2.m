%% This function creates the interval of joint angles required to change.
% All angles in degrees.
% qi are the current angles in a column vector
% q0 are the starting angles in a column vector
% pd are the wanted position in a column vector
% deltaQ is a 1x2 vector. the first element is the deltaQ, the second one
% is a true/false for the while loop conditional statement.
function Qi = inverse_kin_jacobs2(pd, q0, qi, inthreshold)

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



% Here we do the actual delta q calculations, returning degrees.
deltaBeforeThresh = (180/pi).*(c*(finalForwardKinematics...
    - currentposition));
%disp(" delta Q degrees: "); disp(deltaBeforeThresh + qi);


Qi = (deltaBeforeThresh + qi).* inthreshold;
disp(Qi);
end
