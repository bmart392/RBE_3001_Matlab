%% Step 7: Jacobian-based solution of the inverse kinematics problem
 % plots a stick model of the arm in the x-z plane
 % uses Taylor Series expansion and Jacobian pseudoinverse to
 % implement a numeric inverse kinematics algorithm
clc; clear all; close all;

%% Plotting code.
% Creating the robot structure.
Robot.l1 = 0.135;
Robot.l2 = 0.175;
Robot.l3  = 0.16928;

% Set up the figure
f = figure; % create figure
axes;
hold on;
axis equal;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
    0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
axis((Robot.l2 + Robot.l3) * [-1 1 -1 1 -0.5 1.5]);
title('Stick figure plot');
xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');
% This orients the view to the proper angle as requested in the lab.
view([ 0 -90 0]);

% Set the graph to plot the home position of the robot
y0 = forward_kinematics_rad([0; 0; 0]);

% Setting the "handle" field in "Robot" structure to be the handle of
% the arm plot.
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);

%% Click Code
% The click offset
clickoffset = y0(4,:);

% The read in click position
readclick = [];

clickhere = ginput3d(1);
disp("Click here");
disp(clickhere);
disp("End of click here");

% Set the desired position based on where the user clicked.
wantedEndEffectorPosition = clickhere'; 

%% Initialize Taylor Approximation
% Start pos angles
q0 = zeros(3,1);

% iterating/current angles
qi = zeros(3,1);

% The iterator.
qi_xyz_endeffector = zeros(3,1);

% Set the threshold
threshold = [0.001; 0; 0.001];

% Determine if the end position has been reached
case1 = (wantedEndEffectorPosition(1)-qi_xyz_endeffector(1)) >= threshold(1) ...
    || (wantedEndEffectorPosition(1)-qi_xyz_endeffector(1)) <= -threshold(1);

case3 = (wantedEndEffectorPosition(3)-qi_xyz_endeffector(3)) >= threshold(3) ...
    || (wantedEndEffectorPosition(3)-qi_xyz_endeffector(3)) <= -threshold(3);

% Approximate the end position of the robot
while (case1 || case3)
    
    qi = inverse_kin_jacobs2(wantedEndEffectorPosition, qi);
    
    qi_xyz =  forward_kinematics_rad(qi);
    qi_xyz_endeffector = qi_xyz(4,:)';
    
    case1 = (wantedEndEffectorPosition(1)-qi_xyz_endeffector(1)) >= threshold(1) ...
        || (wantedEndEffectorPosition(1)-qi_xyz_endeffector(1)) <= -threshold(1);
    case3 = (wantedEndEffectorPosition(3)-qi_xyz_endeffector(3)) >= threshold(3) ...
        || (wantedEndEffectorPosition(3)-qi_xyz_endeffector(3)) <= -threshold(3);
    
    RobotPlotter2(Robot,qi);
    
    pause(0.1);
    
end
disp(qi*180/pi);