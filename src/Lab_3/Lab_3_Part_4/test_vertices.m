%% Test program to see where each vertex is

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

vertex1 = [343.2; 343.2; 343.2];
vertex2 = [-114.4; 686.4; 228.8];
vertex3 = [171.6; 286.0; -114.4];
vertices = cat(2, vertex1, vertex2, vertex3);

for m=[1 2 3 1]
    for j=0:2
        pidpacket((j*3)+1) = vertices(j+1,m);
    end
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    pause(5);
end

% Clear up memory upon termination
pp.shutdown()
clear java;