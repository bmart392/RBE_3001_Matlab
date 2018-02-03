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
 
    % This column vector then gets passed into the pidpacket in the for
    % loop.
    for k=1:5
        % Move the arm to point 1
        pidpacket(1) = Positions(1:k)
        pidpacket(4) = Positions(2:k)
        pidpacket(7) = Positions(3:k)
        returnpidpacket = pp.command(PID_ID, pidpacket);
        pause(2);
        
        
        % Save to a matrix and then plot
    end    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
