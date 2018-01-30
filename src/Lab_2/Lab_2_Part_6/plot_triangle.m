
f = figure; % create figure
axes;
hold on;
%axis equal;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
axis([0 7 -20 80]);
title('Plotting triangle path');
xlabel('Time [s]'); ylabel('Position [degrees]');



% This is the giant csv file read in.
M = dlmread('triangle_joints.csv');

% X Coordinates
Xs = [];

% Y Coordinates
Ys = [];

% The reformatted data from the .csv file.
importedFromCSV = [];

% Counter for counting the rows in the l for loop
i = 1;
%iterate through each axis
for n=1:4
    % iterate through the columns for the data from each axis
    for m=1:3
        
        % iterate through the rows of the csv
        for l=1:10
        importedFromCSV(i,n) = M(l,(m*4)-(4-n));
        i=i+1;
        end
    end
    % We reset the counter because we start at the top again.
    i = 1;
end

% Fill in the respective column vectors.
J1s(:,1) = importedFromCSV(:,1);
J1s(:,2) = importedFromCSV(:,2)./11.4;

J2s(:,1) = importedFromCSV(:,1);
J2s(:,2) = importedFromCSV(:,3)./11.4;

J3s(:,1) = importedFromCSV(:,1);
J3s(:,2) = importedFromCSV(:,4)./11.4;

times = importedFromCSV(:,1);
J = J1s(:,2) + J2s(:,2) + J3s(:,2); 

plot(J1s(:,1),J1s(:,2),J2s(:,1),J2s(:,2),...
    J3s(:,1),J3s(:,2));
legend('Joint 1 Position','Joint 2 Position','Joint 3 Position')

