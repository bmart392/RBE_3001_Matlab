% INPUT: Joint angles in radians.
function T = forward_kinematics_rad(q1)

% lengths in meters
L1 = 0.135;
L2 = 0.175;
L3 = 0.16928;

% convert encoder ticks to radians
q1(1,1) = q1(1,1)*(-1);
q1(2,1) = q1(2,1);
q1(3,1) = q1(3,1);

% The alpha gets the z-axis aligned about the x
% The theta gets the x-axis aligned about the z

% parameter table

%          d     theta          a    alpha
%      -------------------------------------
%  1   |   L1    theta1         0     -pi/2
%  2   |   0     theta2         L2      0
%  3   |   0     theta3+pi/2    L3      0

% tdh(d, theta, a, alpha)

% Create transformation matrices
T1 = tdh(L1, q1(1,1) , 0, -pi/2);
T2 = tdh(0, q1(2,1), L2, 0);
T3 = tdh(0, q1(3,1)+(pi/2), L3, 0);

% Redefine these 2 trasformations so they start from
% the previous transformation.
T2 = T1*T2;
T3 = T2*T3;

% Extract the x, y, and z components of links, and
% add them to a matrix of coordinates.
RobotArm = [0 0 0]';

% The coordinates (x,y,z) parts, are in columns right now.
RobotArm = cat(2, RobotArm, T1(1:3,4));
RobotArm = cat(2, RobotArm, T2(1:3,4));
RobotArm = cat(2, RobotArm, T3(1:3,4));

% Now a row is point, with that transpose, which means 4x3
T = RobotArm';

% The code below demonstrates how to display the robot.
% DO NOT TOUCH!!!!!!!!!!!!!!!!!
% Now we get the x, y, and z coordinates and create an x and y and
% z column vectors.
% X1 = RobotArm(1,:)';
% Y1 = RobotArm(2,:)';
% Z1 = RobotArm(3,:)';

% Our plotting code here
% plot3(X1, Y1, Z1, 'LineWidth', 5);

% T = T1*T2*T3;
end