function T = plotArm3(q)

% 3x1 joint angle matrix

% q(1,1) is theta1
% q(2,1) is theta2
% q(3,1) is theta3

% Link Lengths in meters
L1 = 0.135;
L2 = 0.175;
L3 = 0.16928;

% The alpha gets the z-axis aligned about the x
% The theta gets the x-axis aligned about the z

% parameter table

%          d     theta     a    alpha
%      ---------------------------------
%  1   |   L1    theta1    0     pi/2
%  2   |   L2    theta2    0      0
%  3   |   L3    theta3  -pi/2    0

% tdh(d, theta, a, alpha)

% Create our transformation matrices
T0 = [0 0 0]'; % Create the vertical matrix.

% d_h_params.tdh(0,0,0,0);
% T1 = d_h_params.tdh(L1,(q(1,1)*pi/180),0,pi/2);
T1 = tdh(L1,(q(1,1)*pi/180),0,pi/2);
T2 = tdh(0,(q(2,1)*pi/180),L2,0);
T3 = tdh(0,(q(3,1)*pi/180),L3,0);

% Here we have some code for the graph.
f = figure;

% These 3 commands work AFTER plot3()
axis on, grid on, hold on; axis equal;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
    0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
title('Plot Angles (Deg) -30, 50 -20');
xlabel('X Axis[m]');
ylabel('Y Axis[m]');
zlabel('Z Axis[m]');

% We redefine these 2 trasformations so that they start from the previous
% transformation.
T2 = T1*T2;
T3 = T2*T3;

% Now we extract the x, y, and z components of our links, and add them to a
% matrix of coordinates.
RobotArm = [0 0 0]';
RobotArm = cat(2, RobotArm, T1(1:3,4));
RobotArm = cat(2, RobotArm, T2(1:3,4));
RobotArm = cat(2, RobotArm, T3(1:3,4));

% Now we get the x, y, and z coordinates and create an x and y and z column
% vectors.
X1 = RobotArm(1,:)';
Y1 = RobotArm(2,:)';
Z1 = RobotArm(3,:)';

% Our plotting code here
plot3(X1, Y1, Z1, 'LineWidth', 5);

T = T1*T2*T3;


end