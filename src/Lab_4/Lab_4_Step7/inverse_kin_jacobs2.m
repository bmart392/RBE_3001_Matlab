%% This function creates the interval of joint angles required to change.
% All angles in degrees.
% qi are the current angles in a column vector
% q0 are the starting angles in a column vector
% pd are the wanted position in a column vector
function Qi = inverse_kin_jacobs2(pd,qi)

% This is the jacobian matrix of the current arm position.
current_position_jacobian_matrix = jacobrad2(qi);

% This is the pseudo inverse of the top part of the jacobian.
inverse_position_jacobian = pinv(current_position_jacobian_matrix(1:3,:)); 

% this is the forward kinematics of the current location.
currentposition = forward_kinematics_rad(qi);

% Calculate deltaq
deltaq = (inverse_position_jacobian*(pd-(currentposition(4,:)')));

Qi = (deltaq + qi);

end
