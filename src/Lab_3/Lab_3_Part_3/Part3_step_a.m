
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
            pidpacket(1) = points(1,1);
            pidpacket(4) = points(1,2);
            pidpacket(7) = points(1,3);
            returnpidpacket = pp.command(PID_ID, pidpacket);
            
            for i = i:numsamples
                % read position
                returnstatuspacket = pp.command(STATUS_ID, statuspacket);
                
                time = toc; % Read the time of the sample
                
                % Record the status packet of the arm
                samples(i,:) = returnstatuspacket;
            end
            i = i + 1;
            samples(i,:) = 0;
            
            % Else the arm will go to Point 2
        else
            disp('go to point 2');
            disp('Go to point 1');
            tic     % start time tracking
            
            % Move the arm to point 1
            pidpacket(1) = points(2,1);
            pidpacket(4) = points(2,2);
            pidpacket(7) = points(2,3);
            returnpidpacket = pp.command(PID_ID, pidpacket);
            
            for i = i:numsamples
                % read position
                returnstatuspacket = pp.command(STATUS_ID, statuspacket);
                
                time = toc; % Read the time of the sample
                
                % Record the status packet of the arm
                samples(i,:) = returnstatuspacket;
            end
            i = i + 1;
            samples(i,:) = 0;
        end
        % send it to the csv
        % plot stuff
        
    end
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
