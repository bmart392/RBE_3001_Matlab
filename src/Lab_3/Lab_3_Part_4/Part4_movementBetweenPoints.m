%% Step 4: Movement between task space points
% moves the arm to 3 points in the task space
% to create an arbitrary triangle.
%
% Robot will move from given vertex 1 to vertex 2
% to vertex 3 then back to vertex 1
%
% solves the IK of the next point before moving
% to that point
%
% save the task space points at each time step
% create a 3D plot of the task space plot
%
% create a plot with three lines corresponding to the x, y, and z values
% of the tip location in mm vs time

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
    PID_ID = 37;            % controls the robot
    STATUS_ID = 42;         % reads robot position
    DEBUG   = true;         % enables/disables debug prints
    
    % initialize packets to send and read positions
    statuspacket = zeros(15,1,'single');
    pidpacket = zeros(15,1,'single');
    
    angconv = 11.44;    % 11.44 ticks per degree
    time = 0;
    
    % y0 is the initial conditions.
    y0 = kinematics([0; 0; 0]);
    
    % Matrices for 3D plot end effector
    endXs = [];        % X Coordinates
    endYs = [];        % Y Coordinates
    endZs = [];        % Z Coordinates
    
    % make sure the robot is in the home position
    pidpacket(1) = 0;
    pidpacket(4) = 0;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    
    %% Fill vertices using kinematics
    % ***check to make sure these are in the workspace
    q1 = [30; 30; 30];
    q2 = [90; 45; 100];
    q3 = [-15; 25; 10];
    
    % matrix to hold the 3 vertices in task space
    vertices = [0 0 0; 0 0 0; 0 0 0];
    vertices(1,:)= kinematics(q1);
    vertices(2,:) = kinematics(q2);
    vertices(3,:) = kinematics(q3);
    
    %% solve for IK of each vertex before moving to point
    
    tic % start time tracking
    
    for m = 1:3 % I don't think this will go back to the first vertex
        % solve for position one in joint space
        desiredpos = inverse_kinematics(vertex(1,:));
        
        % fill a packet with the proper data for each the mth location
        for j=0:2
            pidpacket((j*3)+1) = desiredpos(m,j+1);
        end
        
        % move to position one
        returnpidpacket = pp.command(PID_ID, pidpacket);
        
        % track the status of the robot while moving to positions
        for i = 1:10
            % save time
            time = toc;
            % check status
            returnstatuspacket = pp.command(STATUSID, statuspacket);
            readings(1,1) = returnstatuspacket(1);
            readings(2,1) = returnstatuspacket(4);
            readings(3,1) = returnstatuspacket(7);
            
            % put in matrix
            jointmatrix(i, (4*m)-3) = time;
            jointmatrix(i, (4*m)-2) = readings(1,1);
            jointmatrix(i, (4*m)-1) = readings(2,1);
            jointmatrix(i, 4*m) = readings(3,1);
        end
    end
    % save to csv
    csvwrite('positions.csv', jointmatrix);
    
    %% 3D plot of the task space points
    f2 = figure; % create figure
    axes;
    hold on;
    axis equal;
    box on;
    grid on;
    
    % center the figure on screen and resize it
    fig_size = get(0, 'Screensize');
    fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
        0.9*fig_size(3), 0.8*fig_size(4)];
    set(f2, 'Position', fig_pos);
    % axis((Robot.l2 + Robot.l3) * [-1 1 -1 1 -0.5 1.5]);
    title('3D plot of the End Effector Path');
    xlabel('X Axis [mm]'); ylabel('Y Axis [mm]'); zlabel('Z Axis [mm]');
    
    % read from csv file and store in a Matrix
    Positions = dlmread('positions.csv');
    
    % The reformatted data from the .csv file.
    importedFromCSV = [];
    for n=1:3
        for m=1:5 % these will change depending on size of csv
            for l=1:10 % these will change depending on size of csv
                importedFromCSV(i,n) = M(l,(m*4)-(3-n));
                i=i+1;
            end
        end
        % Reset the counter
        i = 1;
    end
    
    % Fill in the respective column vectors.
    endXs = importedFromCSV(:,1);
    endYs = importedFromCSV(:,2);
    endZs = importedFromCSV(:,3);
    
    % Plot the end-effector coordinates.
    plot3(endXs, endYs, endZs, 'LineWidth', 3);
    drawnow;
    
    %% Plot the corresponding x, y, z tip locations
    f1 = figure; % create figure
    axes;
    hold on;
    box on;
    grid on;
    
    % center the figure on screen and resize it
    fig_size = get(0, 'Screensize');
    fig_pos = [0,0,0.9*fig_size(3), 0.8*fig_size(4)];
    set(f1, 'Position', fig_pos);
    axis([0 7.5 -20 80]);   % may need to be changed
    title('Corresponding x, y, and z tip locations');
    xlabel('Time [s]'); ylabel('Position [mm]');
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;