% This function initializes the figure used for creating the 3D plot fo the
% arm and initializes the global 'Robot' variable
% INPUTS:   Robot = the robot object the graph is associated with
%
% OUTPUTS: f = the figure
function f = init_stickplot(Robot)



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



end

