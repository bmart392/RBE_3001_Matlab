%% Lab 2 part 2


%% This code does not work yet!!!!!  --Andrew S

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
    
    angconv = 11.44;         % 11.44 ticks per degree
    SERV_ID = 37;            % controls the robot
    STATUS_ID = 42;          % reads robot position
    DEBUG   = true;          % enables/disables debug prints
    
    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    statuspacket = zeros(15, 1, 'single');
    %pidpacket = zeros(15, 1, 'single');
    
    % Here we create the robotplotter object.
    lengths = [ 0.135; 0.175; 0.16928;];
    
    % Here we create the robotplotter object.
    plotme = RobotPlotter(lengths);
    
    % Read in angles.
    robotAngles = [0 0 0]';
    
    % Degrees to radians
    degtorad = pi/180;
    
    %% Plotting code.
    
    % Code for the graph.
    f = figure;
    

    % These 3 commands work AFTER plot3()
    axis on, grid on, axis equal;  hold on;

    % center the figure on screen and resize it
    fig_size = get(0, 'Screensize');
    fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
    0.9*fig_size(3), 0.8*fig_size(4)];
    set(f, 'Position', fig_pos);
    title('Stick figure plot');
    xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');

    % These variables hold the plotting code.
    TheArm = zeros(3,4);
    
    % These are the respective i, j, k component column vectors.
    X1 = zeros(4,1);
    Y1 = zeros(4,1);
    Z1 = zeros(4,1);
    
    % loop for 1 second or so.
    for k = 1:20
        
        % Send packet to the server and get the response
        returnPacket = pp.command(STATUS_ID, statuspacket);
        disp(returnPacket);
        
        % Now we take in the angles and convert to degrees. 
        robotAngles(1,1)  = -1*degtorad*returnPacket(1)*angconv;
        robotAngles(2,1)  =    degtorad*returnPacket(2)*angconv;
        robotAngles(3,1)  =    degtorad*returnPacket(3)*angconv;
%         robotAngles(1,1)  = -1*degtorad * 0;
%         robotAngles(2,1)  =    degtorad * 10;
%         robotAngles(3,1)  =    degtorad * (k+5);
        
        % Now we set the robot object angles.
        plotme.setAngles(robotAngles);
        disp(robotAngles);
        
        % Get the x, y, and z values given the robot transformations given.
        disp("here");
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
        
        drawnow;
        
        pause(0.25);
        
    end
    
    % csvwrite('baseplot.csv', posmatrix);
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
