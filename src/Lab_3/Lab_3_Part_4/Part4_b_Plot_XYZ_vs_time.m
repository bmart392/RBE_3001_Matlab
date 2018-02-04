%% Part4b: Plot the corresponding x, y, z tip locations


% Fill in the time stamp - only for 2d
TimeStamps = Positions(:,1);


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
endXs(:,1) = importedFromCSV(:,1);
endYs(:,1) = importedFromCSV(:,1);
endZs(:,1) = importedFromCSV(:,1);

plot(endXs(:,1),endXs(1,:), endYs(:,1), endYs(1,:),...
    endZs(:,1),endZs(1,:));
legend('X Coordinates','Y Coordinates','Z Coordinates')