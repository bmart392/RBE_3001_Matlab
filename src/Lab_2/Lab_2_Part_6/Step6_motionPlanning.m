%% Step 6: Move robot to 3 points in x-z plane

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear; close all;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7);

try
    
    CAPTURE = 1;
    WOCAPTURE = 1;
    
    % Creating the robot structure.
    Robot.l1 = 0.135;
    Robot.l2 = 0.175;
    Robot.l3  = 0.16928;
    
    % y0 is the initial conditions.
    y0 = kinematics([0; 0; 0]);
    
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
    title('Stick figure plot');
    xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');
    
    % Setting the "handle" field in "Robot" structure to be the handle of
    % the arm plot.
    Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
        'color', [0 0.4 0.7], 'LineWidth', 5);
    
    
    PIDID  = 37;            % This controls the robot
    STATUSID = 42;           % This gives the status of the robot
    
    DEBUG    = true;          % enables/disables debug prints
    
    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    statuspacket= zeros(15, 1, 'single');
    pidpacket= zeros(15, 1, 'single');
    
    
    
    
    
    
    jointmatrix = [10,12];  % matrix to hold joint angles and time
    
    time = 0;            % make sure time starts at 0
    
    
    
    
    
    readings = zeros(3,1);
    
    % if capture points for the triangle, replace "WOCAPTURE" with
    % "CAPTURE"
    % if capturing, remember to set desiredpos to new set points
    
    if WOCAPTURE == 1
        desiredpos = capturepoints(STATUSID, statuspacket, pp);
        
    else
        desiredpos = [ 0 26.0 -150.5; 0 -41.25 476.5; ...
            0 756.0 -129.75; ];
    end
    pause(5);
    
    tic                  % Begin time tracking
    
    for m = 1:3
        
        
        %% -------------move joint to desired locaion-------------
        % fill a packet with the proper data for each the mth location
        for j=0:2
            pidpacket((j*3)+1) = desiredpos(m,j+1);
        end
        
        
        % send the packet with data for the mth location
        returnpidpacket = pp.command(PIDID, pidpacket);
        
        
        
        %% -track the location of the arm getting to the mth location --
        % track the status of the arm while moving to each position
        for i = 1:10
            % save time
            time = toc;
            % check status
            returnstatuspacket = pp.command(STATUSID, statuspacket);
            readings(1,1) = returnstatuspacket(1);
            readings(2,1) = returnstatuspacket(4);
            readings(3,1) = returnstatuspacket(7);
            
            % Plot the robot transformations given.
            RobotPlotter(Robot, readings);
            drawnow;
            
            % put in matrix
            jointmatrix(i, (4*m)-3) = time;
            jointmatrix(i, (4*m)-2) = readings(1,1);
            jointmatrix(i, (4*m)-1) = readings(2,1);
            jointmatrix(i, 4*m) = readings(3,1);
        end
        
        
        
    end
    
    % move back to home position
    for d=0:2
        pidpacket((d*3)+1) = 1;
    end
    
    returnpidpacket = pp.command(PIDID, pidpacket);
    
    pause(2);
    
    % save to csv
    csvwrite('triangle_joints.csv', jointmatrix);
    
catch
    disp('Exited on error, clean shutdown');
end


% Clear up memory upon termination
pp.shutdown()
clear java;
