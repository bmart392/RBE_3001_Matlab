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
    PID_ID = 37;      % controls the robot
    STATUS_ID = 42;   % reads robot position
    DEBUG = true;     % enables/disables debug prints
    
    % initialize packets to send and read positions
    statuspacket = zeros(15,1,'single');
    pidpacket = zeros(15,1,'single');
    
    angconv = 11.44;    % 11.44 ticks per degree
    time = 0;           % make sure time starts at zero
    row_counter = 1;    % row counter for the csv file
    
    %% Fill vertices using kinematics
    
    % Vector q holds angles (in deg) of base, elbow, and wrist joints
    % Each column holds the angle for each vertex
    % Kinematics takes encoder ticks so need to convert from degrees to
    % ticks
    qs = angconv.*cat(2, [30; 30; 30], [-10; 60; 20], [15; 25; -10]);
    
    % Matrix to hold the 3 vertices in task space
    vertices = [0 0 0; 0 0 0; 0 0 0; 0 0 0];
    
    % Calculates the end effector positions (x,y,z) using forward kinematics
    for h = 1:4
        if h == 4
            Matrix = kinematics(qs(:,1));
            vertices(h,1:3) = Matrix(4,:);  % only want the last row of the
                                            % matrix kinematics returns
        else
            Matrix = kinematics(qs(:,h));
            vertices(h,1:3) = Matrix(4,:);
        end
    end
    
    % Transpose the matrix to work with inverse_kinematics
    % becomes 3x4 matrix
    vertices = vertices';
    
    % make sure the robot is at vertex 1
    desiredang(1:3,1) = inverse_kinematics(vertices(:,1));
    
    % fill a packet with the proper data for the first vertex
    for j=0:2
        pidpacket((j*3)+1) = (angconv*(desiredang(j+1,1)));
    end
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    pause(2);   % make sure it has time to get there
    
    %% solve for IK of each vertex before moving to each point
    
    % calculate the angles using inverse_kinematics given the x,y,z positions
    for P=1:4
        desiredang(:,P) = inverse_kinematics(vertices(:,P));
    end
    
    tic % start time tracking
    
    for m = [1 2 3 1]
        % fill a packet with the proper data for each the mth location
        for j=0:2
            pidpacket((j*3)+1) = (angconv*(desiredang(j+1,m)));
        end
        
        % move to position
        returnpidpacket = pp.command(PID_ID, pidpacket);
        
        % track the status of the robot while moving to positions
        for i = 1:200
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
    csvwrite('positions.csv', jointmatrix);
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;