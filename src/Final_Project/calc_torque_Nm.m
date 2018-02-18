function joint_forces_Nm = calc_torque_Nm(joint_forces)
% Calculates the joint torques in Nm given the ADC values
% solves the equation x = (y - y0)/k
% where y is the ADC count value, k = 178.5, x = torque (Nm), and y0 is the
% initial offset calculated in the calibration step
%
%   INPUT: joint_forces: column vector of ADC values
%   OUTPUT: joint_forces_Nm: column vector of joint torques in Nm

y0 = [0 ; 0; 0]; % offset calculated in calc_offset
k = 178.5;       % given scaling factor

 joint_forces_Nm = (joint_forces - y0)/k;
end

