%% Test Sending commands to the gripper

clear java; clc; clear all; close all;

javaaddpath('../RBE3001_Matlab_Team_C18_01/lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% -------------- Communication Initialization -----------------

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

% Start at home
send_home(PID_ID, pidpacket, pp);

pause(1);

% send the gripper to open.
grippacket(1,1) = 0;

% This is open
returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);

pause(4);

grippacket(1,1) = 1;

% This is closed
returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);

pause(2);

send_point(PID_ID,pp,pidpacket,[ 0; pi/4; 0 ]);

pause(2);

send_point(PID_ID,pp,pidpacket,[ 0; 0; 0 ]);

pause(2);

% send the gripper to the 0 position, aka open.
grippacket(1,1) = 0;

% This is open
returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);

pause(2);

send_point(PID_ID,pp,pidpacket,[ 0; pi/4; 0 ]);


% Clear up memory upon termination
pp.shutdown()
clear java;