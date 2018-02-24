%% Test Sending commands to the gripper

clear java;

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
pp = PacketProcessor(7);
grippacket = zeros(15,'single');

% send the gripper to the 0 position, aka closed.
grippacket(1,1) = 0;

returnpacket = pp.command(GRIP_ID, grippacket);
disp(returnpacket);

pause(2);

grippacket(1,1) = 1;

returnpacket = pp.command(GRIP_ID, pp, grippacket);
disp(returnpacket);

pause(2);

grippacket(1,1) = 0;

returnpacket = pp.command(GRIP_ID, pp, grippacket);
disp(returnpacket);



% Clear up memory upon termination
pp.shutdown()
clear java;