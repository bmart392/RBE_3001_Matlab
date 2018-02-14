clc; clear all; close all;
% Creating the robot structure.
Robot.l1 = 0.135;
Robot.l2 = 0.175;
Robot.l3  = 0.16928;

% y0 is the initial condition.
y0 = forward_kinematics([0; 0; 0]);

% The click offset
clickoffset = y0(4,:);

% The read in click position
readclick = []; % zeros(3,1);

% From clicking on the graph
%wantedEndEffectorPosition = zeros(3,1);

% This is the read in click location
%clickhere = [0 0 0];

%% Plotting code.

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

% Setting the "handle" field in "Robot" structure to be the handle of
% the arm plot.
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);

    clickhere = ginput3d(1);
    disp("Click here");
    disp(clickhere);
    disp("End of click here");
    
    % We need to remember that the 0 on the graph is actually y0.
    % readclick(1,1) = clickhere(1,1) - clickoffset(1,1);
    % readclick(1,2) = clickhere(1,2) - clickoffset(2,1);
    % readclick(1,3) = clickhere(1,3) - clickoffset(3,1);
    
    % Now this read in position is the wanted end effector position.
    wantedEndEffectorPosition = clickhere'; % readclick;
    
    disp(wantedEndEffectorPosition);
    disp(kinematics_general([0;0;0]));
    
% Start pos angles
q0 = zeros(3,1);

% iterating/current angles
qi = zeros(3,1);
% The iterator.
qi_xyz = zeros(3,1);

threshold = [0.01; 0; 0.01];

% Now this read in position is the wanted end effector position.
%wantedEndEffectorPosition = [0.1; 0; 0.1]; % pd;

case1 = (wantedEndEffectorPosition(1)-qi_xyz(1)) >= threshold(1) ...
    || (wantedEndEffectorPosition(1)-qi_xyz(1)) <= -threshold(1);
case3 = (wantedEndEffectorPosition(3)-qi_xyz(3)) >= threshold(3) ...
    || (wantedEndEffectorPosition(3)-qi_xyz(3)) <= -threshold(3);

%disp((abs((wantedEndEffectorPosition-qi_xyz)) >= threshold));
while (case1 || case3)
    qi = inverse_kin_jacobs2(wantedEndEffectorPosition, ...
        q0, qi, [case1; 0; case3]);
    % Make sure to add the difference back in.
    %qi = qi + deltaq(:,1);
    temp1 =  forward_kinematics_rad(qi);
    qi_xyz = temp1(4,:)';
    
    %disp('qi_xyz magnitude: ');
    %disp((((qi_xyz(1,1) - 0.2) ^2) + ...
     %   (qi_xyz(2,1)^2) + ((qi_xyz(3,1)- 0.2)^2) )^.5 );
    
    case1 = (wantedEndEffectorPosition(1)-qi_xyz(1)) >= threshold(1) ...
        || (wantedEndEffectorPosition(1)-qi_xyz(1)) <= -threshold(1);
    case3 = (wantedEndEffectorPosition(3)-qi_xyz(3)) >= threshold(3) ...
        || (wantedEndEffectorPosition(3)-qi_xyz(3)) <= -threshold(3);
    
    disp('case1');
    disp(case1);
    disp('case3');
    disp(wantedEndEffectorPosition(3)-qi_xyz(3));
    disp(threshold(3));
    disp(case3); 
    
    RobotPlotter2(Robot,qi);
    
    pause(0.25);
    
end
% q0 = qi;