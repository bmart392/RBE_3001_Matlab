% This function implements inverse differential kinematics by solving the
% equation: q_dot = inv(Jp(q))*p_dot
% where: q_dot is the joint velocities
%        Jp is the first 3 rows (all columns) of the jacobian matrix
%        p_dot is the task-space velocities

function q_dot = inv_diff_kinematics( q_joint_angles, p_dot)

%   INPUTS: 
%           q_joint_angles: a 3 x 1 vector holding the joint angles
%                           of each joint
%           p_dot: a 3x1 vector holding the task-space velocities of
%                  the end effector
%   OUTPUTS:
%           q_dot: a 3x1 vector holding the velocities of each joint

% calculate the jacobian given the joint angles
jacobian = jacob0(q_joint_angles);

Jp = zeros(3,3);

% only take the first 3 rows (all the columns)
for i = 1:3
    Jp(i,:) = jacobian(i,:);
end

% take the inverse of Jp
inv_Jp = inv(Jp);

% calculate the joint velocities
q_dot = inv_Jp * p_dot;

end

