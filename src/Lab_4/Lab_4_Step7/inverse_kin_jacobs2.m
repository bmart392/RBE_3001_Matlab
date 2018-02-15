%% This function creates the interval of joint angles required to change.
% All angles in radians.
% qi are the current angles in a column vector
% pd are the wanted position in a column vector
function Qi = inverse_kin_jacobs2(pd,qi)

% This is the jacobian matrix of the current arm position.
current_position_jacobian_matrix = jacob0(qi);

% this is the forward kinematics of the current location.
currentposition = forward_kinematics_rad(qi);

% Calculate deltaq
deltaq = (current_position_jacobian_matrix \ (pd-(currentposition(4,:)')));

Qi = (deltaq + qi);

end
