%% Step 4: Testing Forward differential kinematics.
% You pass a setpoint to the arm and then starts polling the 
% status packet of the joint angles so that this Matlab 
% script can create the velocities. 
% This script uses the forward diff jacobian thing
% to calculate the end effector velocities.

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

global pp;                  % create the packetprocessor variable
pp = PacketProcessor(7);    % initialize the value

try
    global PID_ID;              % create the PID_ID constant
    PID_ID = 37;                % initialize the value
    
    global STATUS_ID;           % create the STATUS_ID constant
    STATUS_ID = 42;             % initialize the value
    
    global statuspacket;        % create the statuspacket
    statuspacket = zeros(15,... % fill the packet with variables
        1,'single');
    
    global pidpacket;           % create the pidpacket
    pidpacket = zeros(15,1,...  % fill the packet with variables
        'single');
    
    global angconv;             % create the angconv constant
    angconv = 11.44;            % initialize the value
    
    row_counter = 1;

    readings = zeros(600,4);
    jointmatrix = zeros(360,4);
    
    % vector qs holds angles (in deg) of base, elbow, and wrist joints
    % Column is the point
    qs = angconv.*cat(2, [30; 30; 30], [-10; 60; 20], [15; 25; -10]);
    
    % matrix to hold the 3 vertices in task space
    % calculates the end effector positions (x,y,z)
    vertices = [0 0 0; 0 0 0; 0 0 0];
    for h = [1 2 3]
        Matrix = kinematics(qs(:,h));
        vertices(h,1:3) = Matrix(4,:);
    end
    
    % Transpose the matrix to work with inverse_kinematics
    % becomes 3x3 matrix. A column is a point.
    vertices = vertices';
    
    % make sure the robot is at vertex 1
    desiredang(1:3,1) = inverse_kinematics(vertices(:,1));
    
    % fill a packet with the proper data for each the mth location
    for j=0:2
        pidpacket((j*3)+1) = (angconv*(desiredang(j+1,1)));
    end
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    pause(2);   % make sure it has time to get there
    
    % Each path is a 3x27 matrix of end effector positions
    % Each column is an x,y,z end effector location
    
    path_xyz_1to2 = gentraj_fullrobot_quintic(...
        [0 2 vertices(1,1) vertices(1,2) 0 0 0 0], ...
        [0 2 vertices(2,1) vertices(2,2) 0 0 0 0],...
        [0 2 vertices(3,1) vertices( 3,2) 0 0 0 0], 10);
    
    path_xyz_2to3 = gentraj_fullrobot_quintic(...
        [0 2 vertices(1,2) vertices(1,3) 0 0 0 0], ...
        [0 2 vertices(2,2) vertices(2,3) 0 0 0 0],...
        [0 2 vertices(3,2) vertices(3,3) 0 0 0 0], 10);
    
    path_xyz_3to1 = gentraj_fullrobot_quintic(...
        [0 2 vertices(1,3) vertices(1,1) 0 0 0 0], ...
        [0 2 vertices(2,3) vertices(2,1) 0 0 0 0],...
        [0 2 vertices(3,3) vertices(3,1) 0 0 0 0], 10);
    
    % Each path is a 3x27 matrix of joint angles
    % Each column is a j0, j1, j2 vector
    path_1to2 = inversekinematics_path_quintic(path_xyz_1to2');
    path_2to3 = inversekinematics_path_quintic(path_xyz_2to3');
    path_3to1 = inversekinematics_path_quintic(path_xyz_3to1');
    
    % Append the individual paths into a continuous path
    % full_path is still joint angles
    full_path = cat(2,path_1to2,path_2to3,path_3to1);
    
    tic     % start time tracking
    
    % Here we read the first packet so that we can start the for
    % loop at 2 instead of 1 so that we don't calculate the 
    % velocities incorrectly. 

    % check status
    returnstatuspacket = pp.command(STATUS_ID, statuspacket);

    for V=1:3
        readings(V, 1) = returnstatuspacket(V*3-2);
    end
    
    time = toc;
    
    % put in matrix
    jointmatrix(row_counter, 1) = time;

    jointmatrix(row_counter, 2:end) = readings';
    
    row_counter = row_counter + 1;

    % Iterate through the columns
    for w = 1:30
        % fill a packet with the proper data for each the wth locations
        for j=0:2
            pidpacket((j*3)+1) = (angconv*(full_path(j+1,w)));
        end
        
        % move to position
        returnpidpacket = pp.command(PID_ID, pidpacket);
        
        % track the status of the robot while moving to positions
        for i = 1:10
            % save time
            time = toc;
            
            % check status
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            for V=1:3
                readings(V,1) = returnstatuspacket(V*3-2);
            end
            
            % put in matrix
            jointmatrix(row_counter, 1) = time;
            for k=2:4
                jointmatrix(row_counter, k) = (readings(k-1,1));
            end
            row_counter = row_counter +1;
        end
        
    end
    
    pause(1);
    
    % save to csv
    csvwrite('quinticed_positions_and_velocities.csv', jointmatrix(1:300,:));
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;