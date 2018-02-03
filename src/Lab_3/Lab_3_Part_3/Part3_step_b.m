f = figure; % create figure
axes;
hold on;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
axis([0 4 -180 180]);
title('Plotting triangle path');
xlabel('Time [s]'); ylabel('Position [degrees]');
% This is the giant csv file read in.
M = dlmread('moveToPoints.csv');

% The reformatted data from the .csv file.
importedFromCSV = zeros(300,4);

% Counter for counting the rows in the l for loop
i = 1;

% Iterate through for time
for q=1:300
    if q <= 150    
    importedFromCSV(q,1) = M(q,1);
    elseif q > 150
    importedFromCSV(q,1) = M(q,1) + M(150,1);
    end
end

%iterate through each axis
for m= 2:4
    % iterate through the columns for the data from each axis
    for l=1:300
        importedFromCSV(l,m) = M(l,(m*3)-4);        
    end
end
disp(importedFromCSV);
% Fill in the respective column vectors.
J1s(1:300,1) = importedFromCSV(1:300,1);
J1s(1:300,2) = importedFromCSV(1:300,2)./11.4;

vJ1s = importedFromCSV(:,1);
for k = 1:149
    vJ1s(k,2) = (J1s((k+1),2)-J1s(k,2))/(J1s(k+1,1)-J1s(k,1));
end

J2s(1:300,1) = importedFromCSV(1:300,1);
J2s(1:300,2) = importedFromCSV(1:300,3)./11.4;

vJ2s = importedFromCSV(:,1);
for w = 1:149
    vJ2s(w,2) = (J2s((w+1),2)-J2s(w,2))/(J2s(w+1,1)-J2s(w,1));
    
end

J3s(1:300,1) = importedFromCSV(1:300,1);
J3s(1:300,2) = importedFromCSV(1:300,4)./11.4;

vJ3s = importedFromCSV(:,1);
for p = 1:149
    vJ3s(p,2) = (J3s((p+1),2)-J3s(p,2))/(J3s(p+1,1)-J3s(p,1));
end

times = importedFromCSV(:,1);

plot(J1s(1:300,1),J1s(1:300,2),J2s(1:300,1),J2s(1:300,2),...
    J3s(1:300,1),J3s(1:300,2));
legend('Joint 1 Position','Joint 2 Position','Joint 3 Position')



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