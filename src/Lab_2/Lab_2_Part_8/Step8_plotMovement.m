%% Step 8: Plot Robot Motion

f = figure; % create figure
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
axis([0 18 -20 80]);
title('Plotting triangle path');
xlabel('Time [s]'); ylabel('Position [degrees]');

% This is the giant csv file read in.
M = dlmread('interpolationjoints.csv');

% X Coordinates
Xs = [];

% Y Coordinates
Ys = [];

% The reformatted data from the .csv file.
importedFromCSV = zeros(60,4);

% Counter for counting the rows in the l for loop
i = 1;

%iterate through each axis
for m=1:4
    % iterate through the columns for the data from each axis
    
    
    % iterate through the rows of the csv
    for l=1:60
        importedFromCSV(l,m) = M(l,m);
        
    end
    
    
    
end

% Fill in the respective column vectors.
J1s(:,1) = importedFromCSV(:,1);
J1s(:,2) = importedFromCSV(:,2)./11.4;

vJ1s = importedFromCSV(:,1);
for k = 1:29
    vJ1s(k,2) = (J1s((k+1),2)-J1s(k,2))/(J1s(k+1,1)-J1s(k,1));
end

J2s(:,1) = importedFromCSV(:,1);
J2s(:,2) = importedFromCSV(:,3)./11.4;

vJ2s = importedFromCSV(:,1);
for w = 1:29
    vJ2s(w,2) = (J2s((w+1),2)-J2s(w,2))/(J2s(w+1,1)-J2s(w,1));
    
end

J3s(:,1) = importedFromCSV(:,1);
J3s(:,2) = importedFromCSV(:,4)./11.4;

vJ3s = importedFromCSV(:,1);
for p = 1:29
    vJ3s(p,2) = (J3s((p+1),2)-J3s(p,2))/(J3s(p+1,1)-J3s(p,1));
end

times = importedFromCSV(:,1);

plot(J1s(:,1),J1s(:,2),J2s(:,1),J2s(:,2),...
    J3s(:,1),J3s(:,2));
legend('Joint 1 Position','Joint 2 Position','Joint 3 Position')

disp(vJ1s);

g = figure; % create figure
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(g, 'Position', fig_pos);
axis([0 9 -25 25]);
title('Plotting triangle path velocity');
xlabel('Time [s]'); ylabel('Velocity [degrees/s]');
plot(vJ1s(:,1),vJ1s(:,2),vJ2s(:,1),vJ2s(:,2), ...
    vJ3s(:,1),vJ3s(:,2));

legend('Joint 1 Velocity','Joint 2 Velocity','Joint 3 Velocity')