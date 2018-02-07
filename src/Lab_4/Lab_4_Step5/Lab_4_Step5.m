%% Step 5: Live plot of the task-space velocity vector
%
% calculate the task-space velocity vector and live-plot it
% on the graph

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7);

PID_ID = 37;            % controls the robot
STATUS_ID = 42;         % reads robot position
DEBUG   = true;         % enables/disables debug prints

% initialize packets to send and read positions
statuspacket = zeros(15,1,'single');
pidpacket = zeros(15,1,'single');

angconv = 11.44;    % 11.44 ticks per degree
time = 0;           % initalize time equal to zero


% Initialize Live plot of robot
% Intialize live plot of vector

try
        
    % Select Points: [[10; 20; 30] [20; 30 ;40] [30; 40; 50;]]
    vertices_xyz = [[0.2894; -0.0509; 0.0854] ...
        [0.2919; -0.1059 ;400.1636] [0.2632; -0.1513; 0.2462;]];
    
    % find inverse kinematics of the points
    vertices_angles = inversekinematics_general(vertices_xyz);
    
    % Send the robot to the first vertex
    send_point(PID_ID, pidpacket, vertices_angles(:,1));
    
    % create cubic trajectory 
    ELAPSED_TIME = 2;   % Total time for the robot to travel 
                        % fromone vertex to the next
    NUM_STEPS = 10;     % number of steps between vertices
    
    trajecotry = gentraj_fullrobot_cubic_versioned...
        (1,Vertices,ELAPSED_TIME,NUM_STEPS);
    
    % start time tracking
    tic  
    
    % In a loop
    %   Move the robot to a postion
    %   sampel the position x times
    %   calculate the velocity
    %   update the live plot with the position
    %   update the live plot with the velocity
    for i = 1:size(trajectory)
        % Move 
        send_point(PID_ID,pidpacket,trajectory(:,i));
        
        arm_samples = collect_n_samples(NUMSAMPLES,STATUS_ID,pp);
    end
    
    % move a joint 50 times
    % will be 100 samples (send and receive time)
    for i = 1:24
        % move link 2 (elbow) 10 degrees
        pidpacket(4) = 10 * angconv;
        returnpidpacket = pp.command(PID_ID, pidpacket);
        
        % read position
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        
        % move link 2 back to home position
        pidpacket(4) = 0;
        returnpidpacket = pp.command(PID_ID, pidpacket);
    end
    
    time = toc;             % save total time
    avgtime = time/100;     % calculate avg time
    disp(avgtime);
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
