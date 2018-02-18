%% Calibrate the Constants for the Torque Equations
% This script will allow for the y0 offset for the joints to be calculated
% and the calibration curve to be set.

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

% -----------------------Set up Plot ----------------------------------
% Creating the robot structure.
% lengths of joints in meters
Robot.l1 = 0.135;
Robot.l2 = 0.175;
Robot.l3  = 0.16928;

% Set up the figure
f = figure; % create figure
axes;
hold on;
axis equal;
box on;
grid on;

% center the figure on screen and resize it
fig_size = get(0, 'Screensize');
fig_pos = [0,0,... %fig_size(3), fig_size(4), ...
    0.9*fig_size(3), 0.8*fig_size(4)];
set(f, 'Position', fig_pos);
axis((Robot.l2 + Robot.l3) * [-1 1 -1 1 -0.5 1.5]);
title('Stick figure plot');
xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');

% ------------------------- Test Force Sensing -------------------------

% y = kx + y0
% where y is the ADC count value, k = 178.5, x = torque (Nm), and y0 is the
% initial offset calculated in the calibration step
% x = (y - y0)/k

y0 = [0 ; 0; 0]; % offset calculated in calc_offset
k = 178.5;       % given scaling factor

% Set the vertices that the arm will travel to in radians
vertex1 = [ 0; 0; 1030];
vertex2 = [ 343; 343; 343];
vertex3 = [ 0; 686; 0 ];

while 1
    % User Interface to determine which point to go to
    user_input = dialog_box_3option('Which point would you like to go to?',...
        'Choose a Point','Point 1','Point 2','Point 3');
    
    % Possible user responses
    POINT1 = 1;
    POINT2 = 2;
    POINT3 = 3;
    
    % Inside a switch statement
    % Move the arm to the proper position
    % Sample the arm and the force on the arm
    % Plot the force vector on the arm
    switch user_input
        case POINT1
            
            % Send the arm to Vertex 1
            send_point(PID_ID,pp,pidpacket,vertex1);
            
            % Determine what is to be sampled
            Collect_PositionandTorque_Only = 9;    
            num_samples = 1;            % The number of samples to take
            statuspacket(16) = 1;       % Set the status packet to tell the
                                        %  nucleo to sample torque
                                        
            % Sample the the arm to read the position and the torque sensors
            sampled_torque = collect_n_samples(...
                Collect_PositionandTorque_Only,num_samples,...
                STATUS_ID,pp, statuspacket);
            % calculate torque in Nm
            torque_Nm = (sampled_torque - y0)/k;
            
            disp('Go to point 1');
            disp('torque: ' + torque_Nm);
            
            % plot the force vector
        case POINT2
            
            % Send the arm to Vertex 2
            send_point(PID_ID,pp,pidpacket,vertex2);
            
            % Determine what is to be sampled
            Collect_PositionandTorque_Only = 9;    
            num_samples = 1;            % The number of samples to take
            statuspacket(16) = 1;       % Set the status packet to tell the
                                        %  nucleo to sample torque
                                        
            % Sample the the arm to read the position and the torque sensors
            sampled_torque = collect_n_samples(...
                Collect_PositionandTorque_Only,num_samples,...
                STATUS_ID,pp, statuspacket);
            % calculate torque in Nm
            torque_Nm = (sampled_torque - y0)/k;
            
            disp('Go to point 2');
            disp('torque: ' + torque_Nm);
            
            % plot the force vector
        case POINT3
            
            % Send the arm to Vertex 3
            send_point(PID_ID,pp,pidpacket,vertex3);
            
            % Determine what is to be sampled
            Collect_PositionandTorque_Only = 9;    
            num_samples = 1;            % The number of samples to take
            statuspacket(16) = 1;       % Set the status packet to tell the
                                        %  nucleo to sample torque
                                        
            % Sample the the arm to read the position and the torque sensors
            sampled_torque = collect_n_samples(...
                Collect_PositionandTorque_Only,num_samples,...
                STATUS_ID,pp, statuspacket);
            % calculate torque in Nm
            torque_Nm = (sampled_torque - y0)/k;
            
            disp('Go to point 3');
            disp('torque: ' + torque_Nm);
            
            % plot force vector on the end effector
        otherwise
            break
    end

end



















