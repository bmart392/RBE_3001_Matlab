%% Finds the Offset values (y0)
% y = kx + y0
% where y is the ADC count value, k = 178.5, x = torque (Nm), and y0 is the
% initial offset calculated in the calibration step

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
%STATUS_ID = 42;
TORQUE_ID = 25;
PID_ID = 37;
pp = PacketProcessor(7);
pidpacket = zeros(15,'single');
statuspacket = zeros(15,'single');
torquepacket = zeros(15,'single');

% --------------- Calibration of the offset curve -------------

% Set variables for each possible responses
% YES = 1;
%
% user_input = dialog_box_truefalse(...
%     'Would you like to set the y0 offset for each torque sensor?'...
%     ,'Sensor Calibration');
%
% if(user_input == YES)

% Set the position for the arm to travel
% vertical over the base joint
position1 = [ 0; pi/2; 0 ];
position2 = [ 0; pi/2; pi/2 ];

send_home(PID_ID,pidpacket,pp);

% Send the arm to the vertical position
send_point(PID_ID,pp,pidpacket,position1);

pause(1);

send_point(PID_ID,pp,pidpacket,position2);

pause(2);
%
% % YES = 1;
% %
% % user_input = dialog_box_truefalse(...
% %     'Would you like to set the y0 offset for each torque sensor?'...
% %     ,'Sensor Calibration');
% %
% % if(user_input == YES)
%
Collect_PositionandTorque_Only = 9;    % Determine what was to be sampled
num_samples = 1;            % The number of samples to take

% Sample the the arm to read the torque sensors
sampled_torque = collect_n_samples(Collect_PositionandTorque_Only,num_samples,...
    TORQUE_ID,pp, torquepacket);

% Display the sample
for i = 1:3
    disp("The sampled torque for Joint " + i + " is " + sampled_torque(i,1));
end

% Clear up memory upon termination
pp.shutdown()
clear java;