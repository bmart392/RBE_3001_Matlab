% Lab 2 part 2

clear all; close all; clc; 

% try 
    % Here we create the robotplotter object.
    lengths = [ 0.135; 0.175; 0.16928;];
    
    plotme = RobotPlotter(lengths);
    
    setAngles(plotme, [0; 0; 0]);
    disp('tryme');
    % This method setAngles is breaking my code.
    % plotme.setAngles([0 0 0]');
    
    % Read in angles.
    robotAngles = [0; 0; 0];
    disp('Start robot angles');
    disp(robotAngles);
    
    % Degrees to radians
    degtorad = pi/180;
    
    %% Here we have plotting code.
    
    % Here we have some code for the graph.
    f = figure;
    % figure;

    % These 3 commands work AFTER plot3()
    axis on, grid on, axis equal;  hold on;

    % center the figure on screen and resize it
    fig_size = get(0, 'Screensize');
    fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
    set(f, 'Position', fig_pos);
    title('Stick figure plot');
    xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');

    % These variables hold the plotting code.
    TheArm = zeros(3,4);
    
    % These are the respective i, j, k component column vectors.
    X1 = zeros(4,1);
    Y1 = zeros(4,1);
    Z1 = zeros(4,1);
    
    % loop for 1 seconds or so.
    for k = 0:10
        
        % Now we take in the angles and convert to degrees. The waist I
        % believe is inverted, hence the -1.
        robotAngles(1,1)  = 0; % -1*degtorad * 0;
        robotAngles(2,1)  =    degtorad * 10;
        robotAngles(3,1)  =    degtorad * (k+2);
        disp('These are the robot angles');
        disp(robotAngles);
        
        disp('About to enter RobotPlotter to set angles');
        % Now we set the robot object angles.
        plotme.setAngles(robotAngles);
        disp(robotAngles);
        
        % Get the x, y, and z values given the robot transformations given.
        TheArm = plotArm3d(plotme);
        disp('This is the Arm');
        disp(TheArm);
        
        % Get the respective components we want.
        X1 = TheArm(1,:)';
        Y1 = TheArm(2,:)';
        Z1 = TheArm(3,:)';
        
        % Now we have to use a handle so that we only UPDATE a single plot.
        refreshdata(f);
        
        plot3(X1, Y1, Z1, 'LineWidth', 5);  
        
        % h = plot3(X1, Y1, Z1);  
        
        % drawnow;
        
        pause(0.1);
        
    end
    
    % csvwrite('baseplot.csv', posmatrix);
% catch
    % disp('Exited on error, clean shutdown');
% end