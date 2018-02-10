%% Step 5: Live plot of the task-space velocity vector
%
% calculate the task-space velocity vector and live-plot it
% on the graph
clear java;

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

global Robot;
Robot.name = '3001 Arm';

% Create the values for the robot arm lengths
Robot.l1 = 0.135;       % Link 1
Robot.l2 = 0.175;       % Link 2
Robot.l3  = 0.16928;    % Link 3

% Calculate the initial home position of the arm for plotting
y0 = kinematics([0; 0; 0]);



% Initialize Live plot of robot
f = init_stickplot(Robot);

% set the handle of the robot to be the plot function initially plotting
% the home position
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);


% Intialize live plot of vector



%try
        
    % Select Points: [[10; 20; 30] [20; 30 ;40] [30; 40; 50;]]
    vertices_xyz = [[0.2582; -0.1491; 0.1379] ...
        [0.2503; +0.0041 ; 0.2572] [0.1955; -0.0524; 0.454;]];
    
 % create cubic trajectory 
    ELAPSED_TIME = 2;   % Total time for the robot to travel 
                        % fromone vertex to the next
    NUM_STEPS = 3;     % number of steps between vertices
    
    trajectory_xyz = full_trajgen_cubic...
        (1,vertices_xyz,[ELAPSED_TIME,ELAPSED_TIME],NUM_STEPS);
    
    % find inverse kinematics of the points
    trajectory_angles = inversekinematics_general(trajectory_xyz);
    
    % Send the robot to the first vertex
    send_point(PID_ID, pp, pidpacket, trajectory_angles(:,1));
    
   
    
    
    
    velocity = zeros(3,1);
    
   
    
    % Determine the number of samples to take for each point along the
    % trajectory
    NUM_SAMPLES = 3;
    
    % Initialize a matrix to hold the values sampled from the robot
    arm_samples = zeros(4,3*(NUM_STEPS+2)*NUM_SAMPLES);
    
    % Intitialize an index to track the index of the samples matrix
    arm_samples_index = 1;
    
    % start time tracking
    tic  
    
    % In a loop
    %   Move the robot to a postion
    %   sampel the position x times
    %   calculate the velocity
    %   update the live plot with the position
    %   update the live plot with the velocity
    disp(size(trajectory_angles,2));
    for i = 1:size(trajectory_angles,2)
        % Move te robot to the the next point in the trajectory
        disp(trajectory_angles(:,i));
        send_point(PID_ID,pp,pidpacket,trajectory_angles(:,i));
                
        % Collect NUM_SAMPLES number of samples for each trajectory point
        collected_samples = collect_n_samples(...
            NUM_SAMPLES,STATUS_ID,pp,statuspacket);
        
        matrix_merge(collected_samples, arm_samples(1:4,arm_samples_index:arm_samples_index+NUM_SAMPLES-1));
        
        velocity = calc_velocity(arm_samples(:,arm_samples_index+NUM_SAMPLES));
        
        for k = arm_samples_index:arm_samples_index+NUM_SAMPLES
            arm_samples(5:7,k) = velocity(1:3,1);
        end
        
        RobotPlotter(Robot,(arm_samples(2:4,k).*angconv));
        
        % Increment the index of the samples array 
        arm_samples_index = arm_samples_index + NUM_SAMPLES + 1;
        pause(1);
       
    end
%catch
%    disp('Exited on error, clean shutdown');
%end

% Clear up memory upon termination
pp.shutdown()
clear java;
