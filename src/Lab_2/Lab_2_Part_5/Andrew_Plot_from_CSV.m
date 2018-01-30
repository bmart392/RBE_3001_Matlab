%% Plotting code.

clc; clear all; close all;

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
% axis((Robot.l2 + Robot.l3) * [-1 1 -1 1 -0.5 1.5]);
title('Stick figure plot');
xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');

% Columns 1, 5, 9, 13, 17, (n*4)-3 are the timestamp, n=1:5
% Columns 2, 6, 10, 14, 18 (n*4)-2 are the Xs. n = 1:5

% This is the row we are on.
i = 1;

% This is the giant csv file read in.
M = dlmread('joints.csv');

% X Coordinates
Xs = [];

% Y Coordinates
Ys = [];

% Z Coordinates
Zs = [];

% The reformatted data from the .csv file.
importedFromCSV = [];

for n=1:3
    for m=1:5
        for l=1:10
        importedFromCSV(i,n) = M(l,(m*4)-(3-n));
        i=i+1;
        end
    end
    % We reset the counter because we start at the top again.
    i = 1;
end

% Fill in the respective column vectors.
Xs = importedFromCSV(:,1);
Ys = importedFromCSV(:,2);
Zs = importedFromCSV(:,3);

% Plot the end-effector coordinates.
plot3(Xs, Ys, Zs, 'LineWidth', 5);
drawnow;
