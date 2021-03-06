% Generate a trajectory for each link between two given points and the associated
% time, velocity, and acceleration characteristics of the given end points.
% Each input should be in the form of a 1x8 matrix 
% INPUTS:   joint1_pointcharacteristics = the characteristics of joint 1
%           joint2_pointcharacteristics = the characteristics of joint 2
%           joint3_pointcharacteristics = the characteristics of joint 3
%           numsteps = the number of steps interpolated in each trajectory
% 
% OUTPUT:   a n x 3 matrix where each column holds all of the values for one
%           link and each row holds the joint values for one point
function trajectory = gentraj_fullrobot_quintic(...
    joint1_pointcharacteristics,joint2_pointcharacteristics,...
    joint3_pointcharacteristics,numsteps)

% Calculate the trajectory of the first joint using the given
% characteristics. 
trajectory(:,1) = gentraj_interpolation_quintic(joint1_pointcharacteristics(1),...
    joint1_pointcharacteristics(2), joint1_pointcharacteristics(3), ...
    joint1_pointcharacteristics(4),joint1_pointcharacteristics(5), ...
    joint1_pointcharacteristics(6), joint1_pointcharacteristics(7), ...
    joint1_pointcharacteristics(8), numsteps);

% Calculate the trajectory of the second joint using the given
% characteristics. 
trajectory(:,2) = gentraj_interpolation_quintic(joint2_pointcharacteristics(1),...
    joint2_pointcharacteristics(2), joint2_pointcharacteristics(3), ...
    joint2_pointcharacteristics(4),joint2_pointcharacteristics(5), ...
    joint2_pointcharacteristics(6), joint2_pointcharacteristics(7), ...
    joint2_pointcharacteristics(8), numsteps);

% Calculate the trajectory of the third joint using the given
% characteristics. 
trajectory(:,3) = gentraj_interpolation_quintic(joint3_pointcharacteristics(1), ...
    joint3_pointcharacteristics(2), joint3_pointcharacteristics(3), ...
    joint3_pointcharacteristics(4),joint3_pointcharacteristics(5), ...
    joint3_pointcharacteristics(6), joint3_pointcharacteristics(7), ...
    joint3_pointcharacteristics(8), numsteps);

end

