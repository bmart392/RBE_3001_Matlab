%% Part 5: Interpolation graph
 % graph the 3d task space 
 % graph the x,y,z end effector postions
 % graph the x,y,z end effector velocities
 % graph the x,y,z end effector accelerations

clc ; clear all; close all;
%% Create Figure for 3D Plot
f1 = figure; % create figure
axes;
hold on;
axis equal;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0, 0.9*fig_size(3), 0.8*fig_size(4)];
set(f1, 'Position', fig_pos);
title('3D plot of the End Effector Path After Interpolation');
xlabel('X Axis [mm]'); ylabel('Y Axis [mm]'); zlabel('Z Axis [mm]');

% Number of rows in the csv file
allrows = 360;

angconv = 11.44;

% Matrices for 3D plot end effector
endXs = [];        % X Coordinates
endYs = [];        % Y Coordinates
endZs = [];        % Z Coordinates

% read from csv file and store in a Matrix
Positions = dlmread('interpolated_positions.csv');

% The reformatted data from the .csv file.
importedFromCSV = [];

% The joint angle matrix
endeffectLoc = [];

% this is only a temporary array for reading in the encoder ticks and
% converting into end effector locations in the second for loop below.
temp1 = []; % This is a 4x3

for i=1:allrows
    for n=2:4 % all columns
        % Positions holds the time and encoder ticks
        % divide by angconv converts the encoder ticks to degrees.
        importedFromCSV(i,n-1) = (Positions(i,n))/angconv;
    end
end

% This for loop converts all of the joint angles into x,y, and z using
% forward kinematics and then stores the values into an array.
for L=1:allrows %size(importedFromCSV, 1) % For all rows
    temp1 = kinematics([importedFromCSV(L,1); ...
        importedFromCSV(L,2); importedFromCSV(L,3)]);
    endeffectLoc(L,1:3) = temp1(4,1:3);
end

% Fill in the respective column vectors.
endXs = 1000.*endeffectLoc(:,1);
endYs = 1000.*endeffectLoc(:,2);
endZs = 1000.*endeffectLoc(:,3);

% Plot the end-effector coordinates.
plot3(endXs, endYs, endZs, 'LineWidth', 2);
drawnow;

%% Create figure for x,y,z positions
f2 = figure;
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f2, 'Position', fig_pos);
axis([0 4.25 -200 700]);
title('Corresponding x, y, and z Tip Locations After Interpolation');
xlabel('Time [s]'); ylabel('Position [mm]');

% Matrices for plot end effector x, y, z
Xs = [];        % X Coordinates
Ys = [];        % Y Coordinates
Zs = [];        % Z Coordinates

% add the time stamp to the matrices
Xs(:,1) = Positions(:,1);
Ys(:,1) = Positions(:,1);
Zs(:,1) = Positions(:,1);

Xs(:,2) = Positions(:,2);   % fill x positions
Ys(:,2) = Positions(:,3);   % fill y positions
Zs(:,2) = Positions(:,4);   % fill z positions

plot(Xs(:,1), Xs(:,2), Ys(:,1), Ys(:,2),...
    Zs(:,1), Zs(:,2), 'LineWidth', 2);
legend('X Coordinates','Y Coordinates','Z Coordinates')

%% Create figure for x,y,z velocities

f3 = figure;
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f3, 'Position', fig_pos);
axis([0 4.25 -2000 1500]);
%  axis([0 4.25 -10000 8000]);
title('Corresponding x, y, and z Tip Velocities After Interpolation');
xlabel('Time [s]'); ylabel('Velocity [mm/sec]');

% Matrices for plot end effector x, y, z velocities
vXs = [];        % X Coordinate velocities
vYs = [];        % Y Coordinate velocities
vZs = [];        % Z Coordinate velocities

% add the time stamp to the matrices
vXs(:,1) = Positions(:,1);
vYs(:,1) = Positions(:,1);
vZs(:,1) = Positions(:,1);

% calculate the velocity for xs
for k = 1:allrows-1
    vXs(k,2) = (Xs((k+1),2)-Xs(k,2))/(Xs(k+1,1)-Xs(k,1));
end

% calculate the velocity for ys
for l = 1:allrows-1
    vYs(l,2) = (Ys((l+1),2)-Ys(l,2))/(Ys(l+1,1)-Ys(l,1));
end

% calculate the velocity for zs
for j = 1:allrows-1
    vZs(j,2) = (Zs((j+1),2)-Zs(j,2))/(Zs(j+1,1)-Zs(j,1));
end

plot(vXs(:,1),vXs(:,2),vYs(:,1),vYs(:,2), ...
    vZs(:,1),vZs(:,2),'LineWidth', 2);

legend('X Velocity','Y Velocity','Z Velocity')


%% Create figure for x,y,z accelerations

f4 = figure;
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f4, 'Position', fig_pos);
title('Corresponding x, y, and z Tip Accelerations After Interpolation');
xlabel('Time [s]'); ylabel('Acceleration [mm/sec^2]');

% Matrices for plot end effector x, y, z accelerations
aXs = [];        % X Coordinate accelerations
aYs = [];        % Y Coordinate accelerations
aZs = [];        % Z Coordinate accelerations

% add the time stamp to the matrices
aXs(:,1) = Positions(:,1);
aYs(:,1) = Positions(:,1);
aZs(:,1) = Positions(:,1);

% calculate the acceleration for xs
for a = 1:allrows-2
    aXs(a,2) = (vXs((a+1),2)-vXs(a,2))/(vXs(a+1,1)-vXs(a,1));
end

% calculate the acceleration for ys
for b = 1:allrows-2
    aYs(b,2) = (vYs((b+1),2)-vYs(b,2))/(vYs(b+1,1)-vYs(b,1));
end

% calculate the acceleration for xs
for c = 1:allrows-2
    aZs(c,2) = (vZs((c+1),2)-vZs(c,2))/(vZs(c+1,1)-vZs(c,1));
end

plot(aXs(:,1),aXs(:,2),aYs(:,1),aYs(:,2), ...
    aZs(:,1),aZs(:,2),'LineWidth', 2);

legend('X Acceleration','Y Acceleration','Z Acceleration')