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
    
    % initialize packets to send and read positions
    statuspacket = zeros(15,1,'single');
    pidpacket = zeros(15,1,'single');
    
    angconv = 11.44;          % 11.44 ticks per degree
    jointangles = zeros(3,1); % column vector to hold joint angles
    
    % ***make sure the robot is in the upright position
    % read the position angles
    returnstatuspacket = pp.command(STATUS_ID, statuspacket);
    
    for j = 1:3
        jointangles(j,1) = (returnstatuspacket((3*j)-2)./11.44);
    end
    
    % use jacob0 to calculate the jacobian
    jacobian = jacobrad2(jointangles.*(pi/180));
    
    % take the determinant of the jacobian and display it
    % determinant should be zero
    det_jacob = det(jacobian(1:3,1:3));
    disp(det_jacob);
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
