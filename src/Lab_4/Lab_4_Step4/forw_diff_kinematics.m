% This function calculates the velocity of the end position using the
%   jacobian matrix of the arm
% INPUTS:   q_joint_variables = a 3 x 4 matrix holding the locations of the
%                                   of each joint including the base joint
%                                   and the end effector
%           q_dot_joint_velocities = a 3 x 4 matrix holding the velocities
%                                       of the of each joint including the
%                                       base joint and the end effector
% OUTPUTS:  p_dot = a 3 x 1 matrix holding the velocity of the end effector
%
function p_dot = forw_diff_kinematics( q_joint_variables, ...
    q_dot_joint_velocities )

% Calculate the jacobian matrix given the joint variables
jacobian_matrix = jacob0(q_joint_variables);

% Calculate the velocity matrix using the given joint velocities
p_dot = jacobian_matrix*q_dot_joint_velocities;

end

