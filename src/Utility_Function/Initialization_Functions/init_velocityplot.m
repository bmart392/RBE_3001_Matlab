% This function initializes the figure used for plotting the velocity
% INPUTS:   none
%
% OUTPUTS: g = the figure
function g = init_velocityplot()

g = figure;     % create figure
axes;           % set the axes
hold on;        % Hold the plots
box on;         % 
grid on;        % Turn on the grid

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(g, 'Position', fig_pos);

% Set the axis lengths [x_min x_max y_min y_max]
axis([0 3.5 -300 300]); 

title('Angular Velocities of Joints');  % Set the title of the graph
xlabel('Time [s]');                     % Set the x-axis label
ylabel('Velocity [degrees/s]');         % Set the y-axis label

end

