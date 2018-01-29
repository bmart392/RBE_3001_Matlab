%% Lab 2 part 2

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7);

try
    SERV_ID = 37;            % controls the robot
    STATUS_ID = 42;          % reads robot position
    DEBUG   = true;          % enables/disables debug prints
    
    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    statuspacket = zeros(15, 1, 'single');

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
    
    for k = 1:6
        
        % Send packet to the server and get the response
        if (mod(k,2) == 0) 
        returnPacket = pp.command(STATUS_ID, statuspacket);
        
        disp('Encoder ticks read:');
        disp(returnPacket(1));
        disp(returnPacket(2));
        disp(returnPacket(3));
        
        % Fill robotAngles matrix with encoder ticks read from packet  
        robotAngles(1,1) = returnPacket(1);
        robotAngles(2,1) = returnPacket(4);
        robotAngles(3,1) = returnPacket(7);
        
        % Plot the robot transformations given.
        RobotPlotter(Robot, robotAngles);
        drawnow;
        
        end
        
        pause(0.1);
    end
    
    csvwrite('baseplot.csv', posmatrix);
catch
     disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
