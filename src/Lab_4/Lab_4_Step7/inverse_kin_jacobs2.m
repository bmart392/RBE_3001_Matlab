%% This function creates the interval of joint angles required to change.
% All angles in degrees.
% qi are the current angles in a column vector
% q0 are the starting angles in a column vector
% pd are the wanted position in a column vector
% deltaQ is a 1x2 vector. the first element is the deltaQ, the second one
% is a true/false for the while loop conditional statement.
function Qi = inverse_kin_jacobs2(pd, q0, qi, inthreshold)

% This is the forward kinematics of where the arm starts from
startposition = kinematics_general([ 0; 0; 0]);

% This is the starting position jacobian with input radians.
initial_jacobian_matrix = jacobrad(q0);

% This is the top part of the initial position jacobian.
initial_position_jacobian = initial_jacobian_matrix(1:3,:);

% This is the pseudo inverse of the top part of the jacobian.
inverse_position_jacobian = pinv(initial_position_jacobian); 
% inverse_position_jacobian = [ 0 1 0; 1 0 0; 0 0 1];

% Where we want to go taking into account the forward kinematics of 0,0,0.
finalForwardKinematics = pd; % - (startposition(4,:)');

% this is the forward kinematics of the current location.
currentposition = kinematics_general(qi);

disp('Position Error');
disp(finalForwardKinematics...
    - currentposition);
disp('inverse_position_jacobian');
disp(inverse_position_jacobian);
% Here we do the actual delta q calculations, returning degrees.
deltaq = (180/pi).*(inverse_position_jacobian*(finalForwardKinematics...
    - currentposition));
%disp(" delta Q degrees: "); disp(deltaBeforeThresh + qi);

disp('deltaq');
disp(deltaq);
disp('qi');
disp(qi);
Qi = (deltaq.*inthreshold + qi);
disp('Qi');
disp(Qi);

end
