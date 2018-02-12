%% Step 7: Test inverse jacobian taylor
% 
% First, we set an arbitray position with y = 0.
% Second, we rotate the plot so that we only see the X-Z plane.
% 
% Third, we use ginput() to sample somewhere in the graph of the task-space
% of the robot arm and then let the arm move to that position. Instead of
% having to use a pause function, the deltaQ term is what makes the arm
% move in intervals.

clc; clear all; close all;

 
% The code for plotting I copied from lab 2.

% Creating the robot structure.
Robot.l1 = 0.135;
Robot.l2 = 0.175;
Robot.l3  = 0.16928;

% y0 is the initial condition.
y0 = forward_kinematics([0; 0; 0]);

% disp(y0);

% The click offset
clickoffset = y0(4,:);

% The read in click position
readclick = zeros(3,1);

% From clicking on the graph
wantedJointAngles = zeros(3,1);

% From clicking on the graph
currentJointAngles = zeros(3,1);

% From iterating through the deltaq while loop.
q0 = zeros(3,1);

% No more error
zero = zeros(3,1);

% This is the deltaQ that will be passed into the RobotPlotter2
deltaq = [ 0; 0; 0 ];

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

% Without code after here, the robot will be plotted in the start
% position.

% This is where things get tricky. We need to update the angles by
% adding deltaQ to qi, the current angles.
% The current angles are initialized to the 0 position, and then deltaQ
% is iteratively added to qi until a the difference between the final
% position and the forward kinematics reaches a certain threshold.

% We are going to assume that this is an infinite loop.
while (true)
    
    % First, we grab the x,y,z data ONCE from the graph.
    [x,y,z] = ginput(1);
    
    % We need to remember that the 0 on the graph is actually y0.
    
    readclick(1,1) = x - clickoffset(1,1);
    readclick(2,1) = 0 - clickoffset(2,1);
    readclick(3,1) = z - clickoffset(3,1);
    
    wantedJointAngles = inverse_kinematics(readclick);
    
    % Here we initialize the deltaq so that we can have somewhere to go
    % in the following for loop. In the start of this function, this
    % should be zero.
    deltaq = inversejacobtaylor(wantedJointAngles, q0, [0
        
    % Start navigating to the clicked position on the graph when the
    % error is non-zero.
    while (deltaq ~= zero)
    % Figure out the deltaq given the wanted angles and the current
    % angles, aka deltaq.
    deltaq = inversejacobtaylor(wantedJointAngles, q0, [0 0 0]);
    
    % Then we pass in the joint angles aka deltaq
    RobotPlotter2(Robot, 4);
    
    % Make sure to add the difference back in.
    q0 = q0 + deltaq;
    end
end