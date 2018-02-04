%% Part4b: Plot the corresponding x, y, z tip locations

clc; clear all; close all;

%% Create Figure
f2 = figure; % create figure
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f2, 'Position', fig_pos);
%axis([0 7.5 -20 80]);   % may need to be changed
title('Corresponding x, y, and z tip locations');
xlabel('Time [s]'); ylabel('Position [mm]');

%% Fill matrices to plot

% Matrices for 3D plot end effector
endXs = [];        % X Coordinates
endYs = [];        % Y Coordinates
endZs = [];        % Z Coordinates

% read from csv file and store in a Matrix
Positions = dlmread('positions.csv');

% add the time stamp to the matrices
endXs(:,1) = Positions(:,1);
endYs(:,1) = Positions(:,1);
endZs(:,1) = Positions(:,1);

% fill x positions
endXs(:,2) = Positions(:,2);

% fill y positions
endYs(:,2) = Positions(:,3);

% fill z positions
endZs(:,2) = Positions(:,4);

plot(endXs(:,1),endXs(:,2), endYs(:,1), endYs(:,2),...
    endZs(:,1),endZs(:,2), 'LineWidth', 3);
legend('X Coordinates','Y Coordinates','Z Coordinates')