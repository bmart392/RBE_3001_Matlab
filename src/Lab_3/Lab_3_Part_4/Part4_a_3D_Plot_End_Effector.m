%% Part 4a: Plot end effector path (3D)
 % create a 3D plot of the end effector in the task space 

clc ; clear all; close all;
%% Create the Figure
f1 = figure; 
axes;
hold on;
axis equal;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0, 0.9*fig_size(3), 0.8*fig_size(4)];
set(f1, 'Position', fig_pos);
title('3D plot of the End Effector Path');
xlabel('X Axis [mm]'); ylabel('Y Axis [mm]'); zlabel('Z Axis [mm]');

%% Fill matrices to plot

allrows = 800;          % Number of rows in the csv file
angconv = 4096/360;     % number of ticks per degrees 

% Matrices for 3D plot end effector
endXs = [];        % X Coordinates
endYs = [];        % Y Coordinates
endZs = [];        % Z Coordinates

% read from csv file and store in a Matrix
Positions = dlmread('positions.csv');

importedFromCSV = [];       % Put the csv file into a matrix
endeffectLoc = [];          % The joint angle matrix

% Create a temporary array 4x3 for reading in the encoder ticks and
% converting into x,y,z end effector locations in the second for loop below
temp1 = [];

for i=1:allrows
    for n=2:4 % all columns
        % Positions holds the time and encoder ticks
        % divide by angconv converts the encoder ticks to degrees.
        importedFromCSV(i,n-1) = (Positions(i,n))/angconv;
    end
end

% Convert all of the joint angles into x,y, and z using
% forward kinematics and then store the values into an array.
for L=1:allrows
    temp1 = kinematics([importedFromCSV(L,1); ...
        importedFromCSV(L,2); importedFromCSV(L,3)]);
    endeffectLoc(L,1:3) = temp1(4,1:3);
end

% Fill in the respective column vectors.
endXs = 1000.*endeffectLoc(:,1);
endYs = 1000.*endeffectLoc(:,2);
endZs = 1000.*endeffectLoc(:,3);

% Plot the end-effector coordinates.
plot3(endXs, endYs, endZs, 'LineWidth', 3);
drawnow;