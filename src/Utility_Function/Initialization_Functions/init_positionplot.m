% This function initializes the figure used for plotting line graphs
% INPUTS:   none
%
% OUTPUTS: f = the figure
function f = init_positionplot()

f = figure;     % create figure
axes;           % set the axes
hold on;        % Hold the plots
box on;         % 
grid on;        % Turn on the grid

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);

% Set the axis lengths [x_min x_max y_min y_max]
axis([0 3.5 0 75]);

title('Angular Position of Joints');    % Set the title of the graph
xlabel('Time [s]');                     % Set the x-axis label
ylabel('Position [degrees]');           % Set the y-axis label
end

