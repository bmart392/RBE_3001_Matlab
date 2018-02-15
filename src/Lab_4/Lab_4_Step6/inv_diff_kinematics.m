% This function implements inverse differential kinematics by solving the
% equation: q_dot = inv(Jp(q))*p_dot
% where: q_dot is the joint velocities in radians per second
%        Jp is the first 3 rows (all columns) of the jacobian matrix
%        p_dot is the task-space velocities in meters per second

function q_dot = inv_diff_kinematics( q_joint_angles, p_dot)

%   INPUTS: 
%           q_joint_angles: a 3 x 1 vector holding the current angle
%                           of each joint in radians
%           p_dot: a 3x1 vector holding the task-space velocity of
%                  the end effector in meters/sec
%   OUTPUTS:
%           q_dot: a 3x1 vector holding the angular velocity of each joint

% calculate the jacobian given the joint angles
jacobian = jacob0(q_joint_angles);

% calculate the joint velocities
q_dot = jacobian \ p_dot;

end

