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
title('End Effector Path');
xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');

% Columns 1, 5, 9, 13, 17, (n*4)-3 are the timestamp, n=1:5
% Columns 2, 6, 10, 14, 18 (n*4)-2 are the Xs. n = 1:5

% Keeps track of the row.
i = 1;

% Read in the csv file.
M = dlmread('joints.csv');

importedFromCSV = [];

% We have a 10x4 for each translation/points
% n = x, y or z components
% m = 
% l =
for n=1:3
    for m=1:5
        for l=1:10
        importedFromCSV(i,n) = M(l,(m*4)-(n-1));
        i=i+1;
        end
    end
end
plot3(M(:,1), M(:,2), M(:,3));