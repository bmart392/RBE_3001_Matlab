%% Step 4: Movement between task space points
% moves the arm to 3 points in the task space
% to create an arbitrary triangle.
%
% Robot will move from given vertex 1 to vertex 2
% to vertex 3 then back to vertex 1
%
% solves the IK of the next point before moving
% to that point

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
    
    % make sure the robot is in the home position
    pidpacket(1) = 0;
    pidpacket(4) = 0;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    
    %% Fill vertices using kinematics
    
    q1 = [30; 30; 30];
    q2 = [90; 45; 100];
    q3 = [-15; 25; 10];
    
    vertex1 = kinematics(q1);
    vertex2 = kinematics(q2);
    vertex3 = kinematics(q3);
    
    %% solve for IK of each vertex before moving to point
    
    % solve for position one
    pos1 = inverse_kinematics(vertex1);
    
    % move to position one
    pidpacket(1) = pos1(1,1);
    pidpacket(4) = pos1(2,1);
    pidpacket(7) = pos1(3,1);
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    % solve for positon two
    pos2 = inverse_kinematics(vertex2);
    
    % move to position two
    pidpacket(1) = pos2(1,1);
    pidpacket(4) = pos2(2,1);
    pidpacket(7) = pos2(3,1);
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    % solve for positon three
    pos3 = inverse_kinematics(vertex3);
    
    % move to position three
    pidpacket(1) = pos3(1,1);
    pidpacket(4) = pos3(2,1);
    pidpacket(7) = pos3(3,1);
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    % solve for position one
    pos1 = inverse_kinematics(vertex1);
    
    % move back to position one
    pidpacket(1) = pos1(1,1);
    pidpacket(4) = pos1(2,1);
    pidpacket(7) = pos1(3,1);
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;