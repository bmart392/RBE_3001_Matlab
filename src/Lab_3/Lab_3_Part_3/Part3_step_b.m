%% Part 3: Plots from moveToPoints.csv
 % the two plots created are of the joint angles
 % and the x, y, and z coordinates of the end effector

clc; clear all; close all;

%% create the figure to plot joint angles
f = figure; % create figure
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
axis([0 3.5 -180 180]);
title('Angular Position of Joints');
xlabel('Time [s]'); ylabel('Position [degrees]');
% This is the giant csv file read in.
M = dlmread('moveToPoints.csv');

numsamples_point1 = 150;
numsamples_point2 = 151;
totalsamples = 301;

% The reformatted data from the .csv file.
importedFromCSV = zeros(totalsamples,4);

% Counter for counting the rows in the l for loop
i = 1;

% Iterate through for time
for q=1:totalsamples
    if q <= numsamples_point1    
    importedFromCSV(q,1) = M(q,1);
    elseif q > numsamples_point1
    importedFromCSV(q,1) = M(q,1) + M(numsamples_point1,1);
    end
end

% iterate through each axis
for m= 2:4
    % iterate through the columns for the data from each axis
    for l=1:totalsamples
        importedFromCSV(l,m) = M(l,(m*3)-4);        
    end
end

% Fill in the respective column vectors.
J1s(1:totalsamples,1) = importedFromCSV(1:totalsamples,1);
J1s(1:totalsamples,2) = importedFromCSV(1:totalsamples,2)./11.44;

J2s(1:totalsamples,1) = importedFromCSV(1:totalsamples,1);
J2s(1:totalsamples,2) = importedFromCSV(1:totalsamples,3)./11.44;

J3s(1:totalsamples,1) = importedFromCSV(1:totalsamples,1); % This is time
J3s(1:totalsamples,2) = importedFromCSV(1:totalsamples,4)./11.44;

% Stores the result of kinematics in the for loop.
temp3 = zeros(4,3);

TheRobot = [0 0 0];

for LP=1:totalsamples-1
temp3 = kinematics([J1s(LP,2) J2s(LP,2) J3s(LP,2)]');
% A row is a point, 4x3
TheRobot = cat(1, TheRobot, temp3(4,:));
end

TheTimes = J1s(2:end,1);
Xes = TheRobot(2:end,1);
Yes = TheRobot(2:end,2);
Zes = TheRobot(2:end,3);

plot(J1s(1:totalsamples,1),J1s(1:totalsamples,2),J2s(1:totalsamples,1),...
    J2s(1:totalsamples,2), J3s(1:totalsamples,1),J3s(1:totalsamples,2),...
    'LineWidth', 2);

legend('Joint 1 Position','Joint 2 Position','Joint 3 Position')

%% Create the figure to plot x, y, and z coordinates of the end effector
g = figure;
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(g, 'Position', fig_pos);
% axis([0 3.5 -30 300]);
title('X, Y, Z Positions of Joints');
% xlabel('Time [s]'); ylabel('Velocity [degrees/s]');
xlabel('Time [s]'); ylabel('Linear Position [mm]');

plot(TheTimes,Xes,TheTimes,Yes,TheTimes,Zes,'LineWidth', 2);

legend('End Effect X','End Effect Y','End Effect Z')