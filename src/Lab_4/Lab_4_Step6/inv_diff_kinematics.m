% This function implements inverse differential kinematics by solving the
% equation: q_dot = inv(Jp(q))*p_dot
% where: q_dot is the joint velocities in degrees
%        Jp is the first 3 rows (all columns) of the jacobian matrix
%        p_dot is the task-space velocities in radians per second

function q_dot = inv_diff_kinematics( q_joint_angles, p_dot)

%   INPUTS: 
%           q_joint_angles: a 3 x 1 vector holding the joint angles
%                           of each joint in degrees
%           p_dot: a 3x1 vector holding the task-space velocities of
%                  the end effector in meters/sec
%   OUTPUTS:
%           q_dot: a 3x1 vector holding the velocities of each joint

% calculate the jacobian given the joint angles
jacobian = jacob0(q_joint_angles);
disp('jacobian');
disp(jacobian);
disp('determinant of jacobian');
disp(det(jacobian));

% take the inverse of Jp
inv_Jp = inv(jacobian);
disp('inverse jacobian')
disp(inv_Jp);

% calculate the joint velocities
q_dot = inv_Jp * p_dot;

end

