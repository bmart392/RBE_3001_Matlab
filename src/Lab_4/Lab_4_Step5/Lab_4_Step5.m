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

velocity = zeros(3,1);  % Intialize a matrix to hold the velocity

% Intitialize an index to track the index of the samples matrix
arm_samples_index = 1;

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

% set the second handle of the robot to be the quiver3 function initially 
% plotting a 0 vector
Robot.handle2 = quiver3(y0(4,1),y0(4,2),y0(4,3),0,0,0,'LineWidth',5);

try
    
    % Select Points: [[10; 20; 30] [20; 30 ;40] [30; 40; 50;]]
    vertices_xyz = [[0.1582; -0.1; 0.1079] ...
        [0.203; +0.0041 ; 0.189] [0.055; 0.1524; 0.054;]...
        [0.1582; 0.1; 0.1079]];
    
    % create cubic trajectory
    ELAPSED_TIME = 2;   % Total time for the robot to travel
    % from one vertex to the next
    
    NUM_STEPS = 25;    % Number of steps between vertices
    
    % Determine the number of samples to take for each point along the
    % trajectory
    NUM_SAMPLES = 30;
    
    % Calculate the trajectory in xyz coordinates
    trajectory_xyz = full_trajgen_cubic...
        (1,vertices_xyz,[ELAPSED_TIME,ELAPSED_TIME,ELAPSED_TIME],NUM_STEPS);
    
    % find inverse kinematics of the points in the trajectory
    trajectory_angles = inversekinematics_general(trajectory_xyz);
    
    % Initialize a matrix to hold the values sampled from the robot
    arm_samples = zeros(4,(size(trajectory_angles,2))*NUM_SAMPLES);
    
    % Send the robot to the first vertex
    send_point(PID_ID, pp, pidpacket, trajectory_angles(:,1));
    
    % Wait 5 seconds to set up graph on the screen
    pause(5);
    
    % start time tracking
    tic
    
    % Go to every point in the trajectory
    for i = 1:size(trajectory_angles,2)
        
        % Move te robot to the given point in the trajectory
        send_point(PID_ID,pp,pidpacket,trajectory_angles(:,i));
        
        % Collect NUM_SAMPLES number of samples for each trajectory point
        collected_samples = collect_n_samples(...
            NUM_SAMPLES,STATUS_ID,pp,statuspacket);
        
        % Save the samples to the samples matrix
        arm_samples(1:4 , ...
            arm_samples_index:arm_samples_index+NUM_SAMPLES-1)= ...
            matrix_merge(collected_samples, arm_samples(1:4 , ...
            arm_samples_index:arm_samples_index+NUM_SAMPLES-1));
        
        % Calculate the average velocity for the given samples
        velocity = calc_velocity(arm_samples(1:4,arm_samples_index:arm_samples_index+NUM_SAMPLES-1));
        
        % Place the calculated velocities in the samples matrix
        for k = arm_samples_index:arm_samples_index+NUM_SAMPLES
            arm_samples(5:7,k) = velocity(1:3,1);
        end
        
        % Plot the robot arm live
        RobotPlotter(Robot,(arm_samples(2:4,k-1) .* angconv));
        
        % Calculate the end position of the robot for the velocity vector
        end_position = kinematics_general(arm_samples(2:4,k-1));
        
        % Retrieve the velocity of the robot for the velocity vector
        end_velocity = arm_samples(5:7,k-1);
        
        % Plot the velocity vector of the end effector
        set(Robot.handle2,'XData',end_position(1),'YData',end_position(2),...
            'ZData',end_position(3),'UData',end_velocity(1),'VData',...
            end_velocity(2),'WData',end_velocity(3));
        
        % Increment the index of the samples array
        arm_samples_index = arm_samples_index + NUM_SAMPLES ;
        
        % Allow time for the plot to be rendered
        pause(0.015);
    end   
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
