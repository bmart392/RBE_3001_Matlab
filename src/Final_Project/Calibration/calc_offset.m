%% Finds the Offset values (y0)
 % y = kx + y0
 % where y is the ADC count value, k = 178.5, x = torque (Nm), and y0 is the
 % initial offset calculated in the calibration step

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% -------------- Communication Initialization -----------------

pp = PacketProcessor(7);    % initialize the value
PID_ID = 37;                % initialize the value
STATUS_ID = 42;             % initialize the value

% Create a variable to hold the statuspacket, including a digit
% determining if the force was going to be sampled
statuspacket = zeros(16,1,'single');

% Create a variable to hold the statuspacket
pidpacket = zeros(15,1,'single');

% --------------- Calibration of the offset curve -------------

% Set variables for each possible responses
YES = 1;

user_input = dialog_box_truefalse(...
    'Would you like to set the y0 offset for each torque sensor?'...
    ,'Sensor Calibration');

if(user_input == YES)
    
    % Set the position for the arm to travel
    % vertical over the base joint
    vertical_position = [ 0; pi/2; pi/2 ];
    
    % Send the arm to the vertical position
    send_point(PID_ID,pp,pidpacket,vertical_position);
    
    Collect_PositionandTorque_Only = 9;    % Determine what was to be sampled
    num_samples = 1;            % The number of samples to take
    statuspacket(16) = 1;       % Set the status packet to tell the
    %  nucleo to sample torque
    
    % Sample the the arm to read the torque sensors
    sampled_torque = collect_n_samples(Collect_PositionandTorque_Only,num_samples,...
        STATUS_ID,pp, statuspacket);
    
    % Display the sample
    for i = 1:3
        disp("The sampled torque for Joint " + i + " is " + sampled_torque(i));
    end
end