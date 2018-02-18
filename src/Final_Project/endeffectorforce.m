function endforce = endeffectorforce(torques, joint_angles)
% calculates the torque on the end effector using the equation
% T = Jp(q)'*Ftip
%   INPUTS: torques: column vector of torques in Nm
%           joint_angles: column vector in radians
%   OUTPUT: column vector of xyz torque components on the end effector

% solve for the jacobian of the given joint angles
jacobian = jacob0(joint_angles);

% solve for the xyz force components on the end effector
endforce = (jacobian')*torques;

end

