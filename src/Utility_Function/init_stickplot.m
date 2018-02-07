% This function initializes the figure used for creating the 3D plot fo the
% arm and initializes the global 'Robot' variable
% INPUTS:   none
%
% OUTPUTS: f = the figure
function f = init_stickplot()

global Robot;   % Initialize the global robot variable

% Create the values for the robot arm lengths
Robot.l1 = 0.135;       % Link 1
Robot.l2 = 0.175;       % Link 2
Robot.l3  = 0.16928;    % Link 3

% Calculate the initial home position of the arm for plotting
y0 = kinematics([0; 0; 0]);


f = figure; % create figure
axes;       % set the axes
hold on;    % hold the plots
axis equal; % set the axis scales to be equal
box on;     %
grid on;    % turn on the grid

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);

% Set the axis lengths [x_min x_max y_min y_max z_min z_max]
axis((Robot.l2 + Robot.l3) * [-1 1 -1 1 -0.5 1.5]);

title('Stick figure plot'); % Set the title of the graph
xlabel('X Axis [m]');       % Set the x-axis label
ylabel('Y Axis [m]');       % Set the y-axis label
zlabel('Z Axis [m]');       % Set the z-axis label

% set the handle of the robot to be the plot function initially plotting
% the home position
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);
end

