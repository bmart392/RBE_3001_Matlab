%% Lab 2 part 2


%% This code does not work yet!!!!!  --Andrew S


clear all; close all; clc; 

try 
    % 11.44 ticks per degree
    angconv = 11.44;
    SERV_ID = 37;            % we will be talking to server ID 37 on
                             % the Nucleo
    STATUS_ID = 42;          % For when we want to read all data.
    DEBUG   = true;          % enables/disables debug prints

    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    % packet = zeros(15, 1, 'single');
    % pidpacket = zeros(15, 1, 'single');
    
    % The returned packet
    returnPacket = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]';
    
    % Here we create the robotplotter object.
    plotme = RobotPlotter();
    
    % Read in angles.
    robotAngles = [0 0 0]';
    
    % Degrees to radians
    degtorad = pi/180;
    
    %% Here we have plotting code.
    
    % Here we have some code for the graph.
    % f = figure;
    figure;

    % These 3 commands work AFTER plot3()
    axis on, grid on, axis equal;  hold on;

    % center the figure on screen and resize it
    fig_size = get(0, 'Screensize');
    fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
    0.9*fig_size(3), 0.8*fig_size(4)];
    set(f, 'Position', fig_pos);
    title('Stick figure plot');
    xlabel('X Axis'); ylabel('Y Axis'); zlabel('Z Axis');

    % These variables hold the plotting code.
    TheArm = zeros(3,4);
    
    % These are the respective i, j, k component column vectors.
    X1 = zeros(3,1);
    Y1 = zeros(3,1);
    Z1 = zeros(3,1);
    
    % loop for 1 seconds or so.
    for k = 1:10
        
        % Send packet to the server and get the response
        % returnPacket = pp.command(STATUS_ID, packet);
        
        % Now we take in the angles and convert to degrees. The waist I
        % believe is inverted, hence the -1.
        % robotAngles(1,1)  = -1*degtorad*returnPacket(1)*angconv;
        % robotAngles(2,1)  =    degtorad*returnPacket(2)*angconv;
        % robotAngles(3,1)  =    degtorad*returnPacket(3)*angconv;
        robotAngles(1,1)  = -1*degtorad * 0;
        robotAngles(2,1)  =    degtorad * 10;
        robotAngles(3,1)  =    degtorad * (k+5);
        
        % Now we set the robot object angles.
        plotme.setangles(robotAngles);
        
        % Get the x, y, and z values given the robot transformations given.
        TheArm = plotArm3d(plotme);
        disp(TheArm);
        
        % Get the respective components we want.
        X1 = TheArm(1,:)';
        Y1 = TheArm(2,:)';
        Z1 = TheArm(3,:)';
        
        % Now we have to use a handle so that we only UPDATE a single plot.
        refreshdata(f);
        
        plot3(X1, Y1, Z1);  
        
        % h = plot3(X1, Y1, Z1);  
        
        drawnow;
        
        pause(0.1);
        
    end
    
    % csvwrite('baseplot.csv', posmatrix);
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
% pp.shutdown()
clear java;
