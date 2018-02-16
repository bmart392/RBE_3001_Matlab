%% Step 6: Test inverse differential kinematics
% Move the manipulator to the overhead configuration (singular position)
% read in the joint angles
% use inverse_diff_kinematics to calculate the joint velocities given
% the joint angles read and an arbitrary 3x1 end effector velocity
% display the joint velocities


clc; clear all; close all;

javaaddpath('lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7);

try
    STATUS_ID = 42;         % reads robot position
    DEBUG   = true;         % enables/disables debug prints
    
    
    % initialize packet to read positions
    statuspacket = zeros(15,1,'single');
    
    % arbitrary end effector velocities
    p_dot = [0; 0; 0.01];
    
    q_joint_angles = zeros(3,1);
    
    % ***make sure the robot is in the upright position
    % read the position angles
    q_joint_angles = collect_n_samples(7,1,STATUS_ID,pp,statuspacket);
    
    % convert to radians
    q_joint_angles_rad = q_joint_angles .* (pi/180);
    
    % calculate the joint velocities
    %q_dot = inv_diff_kinematics( [0;pi/2;pi/2], p_dot);
    q_dot = inv_diff_kinematics( q_joint_angles_rad, p_dot);
    
    % display the joint velocities in degrees per second
    disp('joint velocities in degrees per second');
    disp(q_dot*(180/pi));
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;