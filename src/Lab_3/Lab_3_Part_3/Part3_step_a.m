
% This is the Matlab Main file that runs plotting 2 random task space
% locations and arm joints. This file then plots the robots links in that
% position, not the path MOVING TO THE POSITION.

%% Part 1: Optimize Communication Speed


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
    time = 0;           % initalize time equal to zero
    numsamples = 30;    % Decide how many times to sample the arm position
    userinput = '';
    
    points(numpoints,3);
    
    % Create a matrix to store the results in
    samples = zeros((2*numsamples)+2,15);
    
    i = 1;              % Variable to track the row of "samples"
                        % data is stored in
    
    POINT1 = 1;         % Set constant for determining answer of user input
    POINT2 = 2;         % Set constant for determining answer of user input
    EXIT = 0;           % Set constant for determining answer of user input
    
    YES = 1;         % Set constant for determining answer of user input
    NO = 0;          % Set constant for determining answer of user input
    
    
    % make sure the robot is in the home position
    pidpacket(1) = 0;
    pidpacket(4) = 0;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_ID, pidpacket);
   
    %% These are the initalizations for using the inverse kinematics.
    
    % These hold the locations in the task space, with units in meters.
    pos1x = 0.1;  pos1y = 0.1;  pos1z = 0.1;
    pos2x = 0.05; pos2y = -0.1; pos2z = 0.05;
    
    % We want to enter in 2 task-space locations. This means the x, y, and
    % z position of the end effector. We then need to figure out what joint
    % angles are required to get there.
    Posisions = [ 0 0 0 ]';
    
    % We will be passing in column vectors as the task-space input.
    Positions = cat(2, Positions, [pos1x pos1y pos1z]');
    Positions = cat(2, Positions, [0 0 0]');
    Positions = cat(2, Positions, [pos2x pos2y pos2z]');
    Positions = cat(2, Positions, [0 0 0]');
    
    % This is the matrix that holds all the joint angles.
    Angles = inverse_kinematics(Posisions(:,1));
    for L=2:sizeof(Positions, 2) % How many columns are there?
       Angles = cat(2, Angles, inverse_kinematics(Posisions(:,L)));
    end
 
    % Convert all angles to ticks.
    Angles = angconv.*Angles;
    
    % This is the end of the code that determines the angles required for
    % the arm to go to.    
    
    
    userinput = dialog_box_truefalse('Would you like to set the points?','');
    if userinput == YES
        points = capture_npoints(STATUSID,statuspacket,pp,2);
        
        % Check if the user quit "capture_npoints" prematurely
        if points(1,1) == 999
            userinput = EXIT;
        end
    end
    
    % Ensure that the user did not want to exit
    if userinput ~=EXIT
        % Ask the user what they want to do
        userinput = dialog_box_3option('Would you like to go to a point?','','Point 1', 'Point 2','Exit the script');
    end
    
    %Determine if the script will run
    if(userinput ~= EXIT)
        
        % Determine if the arm will go to Point 1
        if(userinput == POINT1)
            disp('Go to point 1');
            tic     % start time tracking
            
            % Move the arm to point 1
            pidpacket(1) = Angles(1,2);
            pidpacket(4) = Angles(2,2)
            pidpacket(7) = Angles(3,2);
            returnpidpacket = pp.command(PID_ID, pidpacket);
            
            for i = i:numsamples
                % read position
                returnstatuspacket = pp.command(STATUS_ID, statuspacket);
                
                time = toc; % Read the time of the sample
                
                % Record the status packet of the arm
                samples(i,:) = returnstatuspacket;
            end
            % Here we are plotting the first position.
            pos1 = plotArm3(samples(i,1), samples(i,4), samples(i,7));
            
            i = i + 1;
            samples(i,:) = 0;

            % Else the arm will go to Point 2
        else
            disp('go to point 2');
            disp('Go to point 1');
            tic     % start time tracking
            
            % Move the arm to point 1
            pidpacket(1) = Angles(1,4);
            pidpacket(4) = Angles(2,4);
            pidpacket(7) = Angles(3,4);
            % pidpacket(1) = points(2,1);
            % pidpacket(4) = points(2,2);
            % pidpacket(7) = points(2,3);
            returnpidpacket = pp.command(PID_ID, pidpacket);
            
            for i = i:numsamples
                % read position
                returnstatuspacket = pp.command(STATUS_ID, statuspacket);
                
                time = toc; % Read the time of the sample
                
                % Record the status packet of the arm
                samples(i,:) = returnstatuspacket;
            end
            % Here we are plotting the first position.
            pos2 = plotArm3(samples(i,1), samples(i,4), samples(i,7));
            
            i = i + 1;
            samples(i,:) = 0;
        end
        % send it to the csv
        % plot stuff
        csvwrite("moveToPoints.csv", samples);
        
    end  
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
