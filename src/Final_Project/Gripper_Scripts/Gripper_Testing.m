%% Test Sending commands to the gripper

clear java; clc; clear all; close all;

javaaddpath('../RBE3001_Matlab_Team_C18_01/lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

%%%%%%%%%%%%%%% Communication Initialization %%%%%%%%%%%%%%%%%%%%%%-

% Set up communication with the arm
GRIP_ID = 13;
STATUS_ID = 42;
TORQUE_ID = 25;
PID_ID = 37;
pp = PacketProcessor(7);
pidpacket = zeros(15,'single');
statuspacket = zeros(15,'single');
torquepacket = zeros(15,'single');
grippacket = zeros(15,'single');

%%%%%%%%%% Test Setting and sending the gripper commands %%%%%%%%%%%%

% set the gripper packet to open.
grippacket(1,1) = 0;

% Send the open packet
returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);

% Wait
pause(4);

% set the gripper packet to closed.
grippacket(1,1) = 1;

% Send the closed packet
returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);

pause(2);

% set the gripper packet to the open position.
grippacket(1,1) = 0;

% Send the open packet
returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);


% Clear up memory upon termination
pp.shutdown()
clear java;