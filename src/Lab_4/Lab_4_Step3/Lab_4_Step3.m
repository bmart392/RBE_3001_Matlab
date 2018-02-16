%% Step 3: Jacobian Validation
% move the robot so the end effector is directly
% over the base frame, all joints fully extended
% read the joint angles
% calculate the jacobian, then calculate the determinant of Jp
% determinant should be zero because robot
% is in a sigular configuration

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
    
    angleconv = 11.4;       % 11.4 ticks per degree
    
    % initialize packets to send and read positions
    statuspacket = zeros(15,1,'single');
    
    % column vector to hold joint angles
    jointangles = zeros(3,1); 
    
    % ***make sure the robot is in the upright position
    % jointangles = [0;90;90];
    % read the position angles degrees
     jointangles = collect_n_samples(7,1,STATUS_ID,pp,statuspacket);
    
    % convert to radians
    jointangles_rad = jointangles .* (pi/180);
    
    % use jacob0 to calculate the jacobian
    jacobian = jacob0(jointangles_rad);
    
    % take the determinant of the jacobian and display it
    % determinant should be zero
    det_jacob = det(jacobian);
    disp(det_jacob);
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
