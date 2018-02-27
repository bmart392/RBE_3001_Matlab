%% Calibrate the Constants for the Torque Equations
% This script will allow for the y0 offset for the joints to be calculated
% and the calibration curve to be set.

javaaddpath('../RBE3001_Matlab_Team_C18_01/lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% -------------- Communication Initialization -----------------

pp = PacketProcessor(7);    % initialize the value
PID_ID = 37;                % moves the robot
%STATUS_ID = 42;             % reads position and velocity
TORQUE_ID = 25;

% Create a variable to hold the statuspacket, including a digit
% determining if the force was going to be sampled
statuspacket = zeros(15,1,'single');
torquepacket = zeros(15,1,'single');

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
axis((Robot.l2 + Robot.l3) * [-1.5 1.5 -1.5 1.5 -0.5 1.5]);
title('Stick figure plot');
xlabel('X Axis [m]'); ylabel('Y Axis [m]'); zlabel('Z Axis [m]');

% Set the graph to plot the home position of the robot
y0 = forward_kinematics_rad([0; 0; 0]);

% Setting the "handle" field in "Robot" structure to be the handle of
% the arm plot.
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);

% set the second handle of the robot to be the quiver3 function initially
% plotting a 0 vector
Robot.handle2 = quiver3(y0(4,1),y0(4,2),y0(4,3),0,0,0,'LineWidth',5);

% ------------------------- Test Force Sensing -------------------------

% Set the vertices that the arm will travel to in radians
vertex3 = [ 0; 1.0472; 0 ];

endposition3 = forward_kinematics_rad(vertex3);
endposition3 = endposition3(4,:)';

send_home(PID_ID, pidpacket, pp);

% For wating for person comment loop.
timeout = [];

% This is the pause to allow you to move the figure.
pause(6);

while 1
    % Send the arm to Vertex 3
    send_point(PID_ID,pp,pidpacket,vertex3);
    
    % Determine what is to be sampled
    Collect_PositionandTorque_Only = 9;
    num_samples = 1;            % The number of samples to take
    pause(1);
    
    % Sample the the arm to read the position and the torque sensors
    torque_noload = collect_n_samples(...
        Collect_PositionandTorque_Only,num_samples,...
        TORQUE_ID,pp, torquepacket);
    torque_noload = torque_noload.*1000;
    
    % Wait for somebody to push on the arm.
    for L=1:4
        pause(0.5);
        timeout = num2str((8-(L*2))/4);
        disp(" Reading forces in " + timeout + " Seconds" );
    end
    
    % Read in the samples
    torque_load = collect_n_samples(...
        Collect_PositionandTorque_Only,num_samples,...
        TORQUE_ID,pp, torquepacket);
    
    % Fix the magnitude
    torque_load = torque_load.*1000;
    
    % Subtract the no load torque.
    actual_torque = torque_load - torque_noload;
    
    % If the difference is smaller than 0.05, set to 0
    for i=1:3
        if(abs(actual_torque(i)) < 0.05)
            actual_torque(i) = 0;
        end
    end
    
    % calculate end effector xyz force components
    endeffector_force_xyz = endeffectorforce(actual_torque, vertex3); %.*[ 1 1 -1];
    
    disp("This is endeffector_force_xyz");
    disp(endeffector_force_xyz);
    
    % plot the force vector on end effector
    RobotPlotter2(Robot,vertex3);
    
    set(Robot.handle2,'XData',endposition3(1),'YData',endposition3(2),...
        'ZData',endposition3(3),'UData',endeffector_force_xyz(1,1),'VData',...
        endeffector_force_xyz(2,1),'WData',endeffector_force_xyz(3,1));
end

% Clear up memory upon termination
pp.shutdown();
clear java;