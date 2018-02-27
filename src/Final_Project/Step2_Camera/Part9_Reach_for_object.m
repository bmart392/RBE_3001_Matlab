%% Automated_sorting.m
% This is the final script for the sorting process of the final project
% Last Edit: 2/22/17 - Ben - Added Some Intializations

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
STATUS_ID = 42;
TORQUE_ID = 25;
PID_ID = 37;
GRIP_ID = 13;
pp = PacketProcessor(7);
pidpacket = zeros(15,'single');
statuspacket = zeros(15,'single');
torquepacket = zeros(15,'single');
grippacket = zeros(15,'single');

% -------------- Image Processing Initializations -------------------

% Instantiate hardware (turn on camera)
if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

while(1)
    
% -------  move arm out of the way-------------------- --

send_point(PID_ID,pp, pidpacket, [0; pi/2; 0]);

% send the gripper to open.
grippacket(1,1) = 0;
returnpacket = pp.command(GRIP_ID, grippacket);

pause(3);

% --------------- Capture Centroid from Image ----------------------
% Preview what the camera sees
%preview(cam)

% Next we take a snapshot from the camera
img = snapshot(cam);
%imshow(img);

% Calculate the centroid and color of the object from the picture
img_stats = identify_centroid_color(img);

% Calculate the position of the centroid in the task space
taskspace_position_camera = (choose_mn2xy(img_stats.Centroid(1),img_stats.Centroid(2)))./100;

taskspace_position = cat(2,taskspace_position_camera,-0.00)';

taskspace_position_end = cat(2,taskspace_position_camera,-0.02)';

% ----------- Find Current Position of the Arm -----------------------

ONLY_POSITION = 7;
num_samples = 1;

% Sample for the current position
current_pos_radians = collect_n_samples(ONLY_POSITION,num_samples,...
    STATUS_ID,pp,statuspacket);

% Calculate the current XYZ position of the arm
current_pos_xyz_full = forward_kinematics_rad(current_pos_radians);
current_pos_xyz = current_pos_xyz_full(4,:);

% ---------- Calculate the Joint Angles for the Centroid -------------

% Inverse Kinematics of Jacobian, we should decide
object_position_angles = inverse_kinematics(taskspace_position);
object_position_angles_end = inverse_kinematics(taskspace_position_end);

% ------ Calculate the Trajectory Required to Reach the Object -------

time_to_object = 9.25; % seconds
num_steps = 50;

trajectory = full_trajgen_cubic(1,[  current_pos_radians ...
    object_position_angles ], time_to_object, num_steps);

% ----------------- Move the robot to the object ---------------------

% send the gripper to open.
grippacket(1,1) = 0;
returnpacket = pp.command(GRIP_ID, grippacket);

tic;
for i= 1:size(trajectory,2)
     send_point(PID_ID,pp,pidpacket,trajectory(:,i));
end
disp(toc);

send_point(PID_ID,pp,pidpacket,object_position_angles_end);
pause(0.5);

grippacket(1,1) = 1;
returnpacket = pp.command(GRIP_ID, grippacket);


end

% --------------- Clear up memory upon termination ------------------
pp.shutdown()
clear java;