
% This is the Matlab Main file that runs plotting 2 random task space
% locations and arm joints. This file then plots the robots links in that
% position, not the path MOVING TO THE POSITION.

%% Part 1: Optimize Communication Speed
%
% calculate the average time it takes to send
% and receive packets

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
    
    % make sure the robot is in the home position
    pidpacket(1) = 0;
    pidpacket(4) = 0;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    tic     % start time tracking
    
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
