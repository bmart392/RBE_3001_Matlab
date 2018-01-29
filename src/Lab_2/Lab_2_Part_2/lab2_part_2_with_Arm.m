%% Lab 2 part 2

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clear all; close all; clc; 

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
    
    robotAngles = [0 0 0]';     % matrix to hold angles

    
    %% Plotting code.
    
    f = figure; % create figure
 
    % center the figure on screen and resize it
    fig_size = get(0, 'Screensize');
    fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
    0.9*fig_size(3), 0.8*fig_size(4)];
    set(f, 'Position', fig_pos);
    title('Stick figure plot');
    xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');
    
    % These are the respective i, j, k component column vectors.
    X1 = zeros(4,1);
    Y1 = zeros(4,1);
    Z1 = zeros(4,1);
    
    for k = 1:10
        
        % Send packet to the server and get the response
        returnPacket = pp.command(STATUS_ID, statuspacket);
        disp('Encoder ticks read:');
        disp(returnPacket(1));
        disp(returnPacket(2));
        disp(returnPacket(3));
        
        % Fill robotAngles matrix with encoder ticks read from packet  
        robotAngles(1,1) = returnPacket(1);
        robotAngles(2,1) = returnPacket(2);
        robotAngles(3,1) = returnPacket(3);
        
        % Get the x, y, and z values given the robot transformations given.
        TheArm = RobotPlotter(robotAngles);
        disp('This is the Arm:');
        disp(TheArm);
        
        % Get the respective x, y, zcomponents
        X1 = TheArm(1,:)';
        Y1 = TheArm(2,:)';
        Z1 = TheArm(3,:)';
        
        % Now we have to use a handle so that we only UPDATE a single plot.
        refreshdata(f);
        
        plot3(X1, Y1, Z1, 'LineWidth', 5);  
        
        % These 3 commands work AFTER plot3()
        axis on, grid on, axis equal;  hold on;
    
        drawnow;
        
        pause(0.5);
        
    end
    
    % csvwrite('baseplot.csv', posmatrix);
 catch
     disp('Exited on error, clean shutdown');
 end

% Clear up memory upon termination
pp.shutdown()
clear java;
