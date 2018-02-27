%% Am I heavy or naw??
% grab an object, pick it up
% display force vector

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

% -------  move arm out of the way-------------------- --

send_point(PID_ID,pp, pidpacket, [0; pi/2; 0]);


% -------------- Image Processing Initializations -------------------

% Instantiate hardware (turn on camera)
if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

% --------------- Capture Centroid from Image ----------------------
% Preview what the camera sees
%preview(cam)



% Next we take a snapshot from the camera
img = snapshot(cam);
imshow(img);

% Calculate the centroid and color of the object from the picture
img_stats = identify_centroid_color(img);

% Calculate the position of the centroid in the task space
% taskspace_position_camera = (mn2xy(img_stats.Centroid(1),img_stats.Centroid(2)))./100;
taskspace_position_camera = (mn2xy(img_stats.Centroid(1),img_stats.Centroid(2)))./100;
taskspace_position = cat(2,taskspace_position_camera,-0.02)';

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
oject_position_angles = object_position_angles;

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
    %    disp(trajectory(:,i));
    %pause(.01);
end
disp(toc);

% close the gripper
grippacket(1,1) = 1;
returnpacket = pp.command(GRIP_ID, grippacket);

% ------------------ pick up object----------------------------------
vertex3 = [ 0; 1.0472; 0 ];

% Send the arm to Vertex 3
send_point(PID_ID,pp,pidpacket,vertex3);

% read torque values for each joint
Collect_PositionandTorque_Only = 9;
num_samples = 1;            % The number of samples to take
pause(1);

torque_load = collect_n_samples(...
    Collect_PositionandTorque_Only,num_samples,...
    TORQUE_ID,pp, torquepacket);
torque_load = torque_load.*1000;
disp('load torque: ');
disp(torque_load);

% calculate end effector xyz force components
endeffector_force_xyz = endeffectorforce(torque_load, vertex3);
disp(endeffector_force_xyz);
disp("Dot multiplied");
disp(endeffector_force_xyz.*[ 1; 1; -1 ]);

pause(2);

% ----------------put the object down --------------------------
time_to_object = 9.25; % seconds
num_steps = 25;

home = [0; 0; 0];

trajectory = full_trajgen_cubic(1,[  vertex3 ...
    home ], time_to_object, num_steps);

tic;
for i= 1:size(trajectory,2)
     send_point(PID_ID,pp,pidpacket,trajectory(:,i));
end
%disp(toc);
pause(1);

% open gripper
grippacket(1,1) = 0;
returnpacket = pp.command(GRIP_ID, grippacket);
pause(1);

% lift arm again
send_point(PID_ID,pp, pidpacket, [0; pi/2; 0]);

% --------------- Clear up memory upon termination ------------------
pp.shutdown()
clear java;