% This function calculates the velocity of the end position using the
%   jacobian matrix of the arm
% INPUTS:   q_joint_angles = a 3 x 1 vector holding the angles of each
%                               joint in degrees
%           q_dot_joint_velocities = a 3 x 1 matrix holding the joint 
%                                    velocities in degrees per second
% OUTPUTS:  p_dot = a 3 x 1 matrix holding the velocity of the end effector
%
function p_dot = forw_diff_kinematics( q_joint_angles, ...
    q_dot_joint_velocities )

% Calculate the jacobian matrix given the joint variables
% jacobian_matrix is a 6x3
jacobian_matrix = jacob0(q_joint_angles);

Jp = zeros(3,3);

% only take the first 3 rows (all the columns)
for i = 1:3
    Jp(i,:) = jacobian_matrix(i,:);
end

% Calculate the velocity matrix using the given joint velocities
p_dot = Jp * q_dot_joint_velocities;

end

