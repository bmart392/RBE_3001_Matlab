%% Automated_sorting.m
% This is the final script for the sorting process of the final project
% Last Edit: 2/22/17 - Ben - Added Some Intializations

clear java;

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

%clc; clear all; close all;

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

% --------------- Positions to place each Type of Object -------------

% Calculate the position of the storage for heavy blue objects
blue_heavy_storage_position_xyz = [ 0.0750; 0.2; 0 ];
blue_heavy_storage_position_angle = inverse_kinematics...
    (blue_heavy_storage_position_xyz);

% Calculate the position of the storage for light blue objects
blue_light_storage_position_xyz = [ 0.0750; -0.2; 0 ];
blue_light_storage_position_angle = inverse_kinematics...
    (blue_light_storage_position_xyz);

% Calculate the position of the storage for heavy green objects
green_heavy_storage_position_xyz = [ 0.15; 0.2; 0 ];
green_heavy_storage_position_angle = inverse_kinematics...
    (green_heavy_storage_position_xyz);
% Calculate the position of the storage for light green objects
green_light_storage_position_xyz = [ 0.15; -0.2; 0 ];
green_light_storage_position_angle = inverse_kinematics...
    (green_light_storage_position_xyz);

% Calculate the position of the storage for heavy yellow objects
yellow_heavy_storage_position_xyz = [ 0.20; 0.2; 0 ];
yellow_heavy_storage_position_angle = inverse_kinematics...
    (yellow_heavy_storage_position_xyz);

% Calculate the position of the storage light yellow objects
yellow_light_storage_position_xyz = [ 0.20; -0.2; 0 ];
yellow_light_storage_position_angle = inverse_kinematics...
    (yellow_light_storage_position_xyz);

% -------------- Image Processing Initializations -------------------

% Instantiate hardware (turn on camera)
if ~exist('cam', 'var') % connect to webcam iff not connected
    cam = webcam();
    pause(1); % give the camera time to adjust to lighting
end

% ||||||||||||||||| Start of Automation Code |||||||||||||||||||||||||

% send the gripper to open.
grippacket(1,1) = 0;
returnpacket = pp.command(GRIP_ID, grippacket);

while 1
    
    

    % --------------- weigh robot---------------------
    weighing_position = [ 0; pi/2; 0 ];
    
    % Send the arm to the weighing position
    send_point(PID_ID,pp,pidpacket,weighing_position);
    
    % read no torque values for each joint
    Collect_PositionandTorque_Only = 9;
    num_samples = 1;            % The number of samples to take
    
    
    pause(3);
    
    
        no_torque_load = collect_n_samples(...
        Collect_PositionandTorque_Only,num_samples,...
        TORQUE_ID,pp, torquepacket);
    
    % Set the value sampled from joint 1 to be 0
    no_torque_load(1,:) = 0;
    no_torque_load(2,:) = 0;
    
    average_no_torque_load = no_torque_load;%(no_torque_load(:,1) + no_torque_load(:,2))/2;
    
    no_torque_load = average_no_torque_load;%.*1000;
    
    
    % -------  move arm out of the way-------------------- --
    
    send_point(PID_ID,pp, pidpacket, [0; pi/2; 0]);
    
    pause(0.25);
    
    % --------------- Capture Centroid from Image ----------------------
    
    % Next we take a snapshot from the camera
    img = snapshot(cam);
    
    % Calculate the centroid and color of the object from the picture
    img_stats = identify_centroid_color(img);
    
    % Check for errors in the object identification phase
    if img_stats.Error
        
        disp("Board is empty");
        break;
    end
    
    
    disp("Color of Object");
    disp(img_stats.Color);
    
    % Calculate the position of the centroid in the task space
    taskspace_position_camera = (choose_mn2xy(img_stats.Centroid(1),img_stats.Centroid(2)))./100;
    taskspace_position = cat(2,taskspace_position_camera,-0.00)';
    taskspace_position_end = cat(2,taskspace_position_camera,-0.02)';
    
    
    % ----------------------0.000001- pick up the object ---------------------
    
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
    
    % Calculate the inverse kinematics of the robot
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
    
    for i= 1:size(trajectory,2)
        send_point(PID_ID,pp,pidpacket,trajectory(:,i));
    end
    
    send_point(PID_ID,pp,pidpacket,object_position_angles_end);
    pause(0.25);
    
    grippacket(1,1) = 1;
    returnpacket = pp.command(GRIP_ID, grippacket);
    
    
    % ----------------- Weigh the object -------------------------------
    
    % ------------------ pick up object----------------------------------
    
    % Send the arm to an intermediary position
    send_point(PID_ID,pp,pidpacket,trajectory(:,i) + [ 0; pi/3; 0]);
    
    % Send the arm to the weighing position
    send_point(PID_ID,pp,pidpacket,weighing_position);
    
    % read torque values for each joint
    Collect_PositionandTorque_Only = 9;
    num_samples = 1;            % The number of samples to take
    
    pause(3);
    
    torque_load = collect_n_samples(...
        Collect_PositionandTorque_Only,num_samples,...
        TORQUE_ID,pp, torquepacket);
    
    % Set the value sampled from joint 1 to be 0
    torque_load(1,:) = 0;
    torque_load(2,:) = 0;
    
    
    average_torque_load = torque_load;%(torque_load(:,1) + torque_load(:,2))/2;
    
    torque_load = average_torque_load;%.*1000;
    
    % calculate the actual torque
    
    actual_torque_load = torque_load - no_torque_load;
    disp(actual_torque_load);
    
    % calculate end effector xyz force components
    endeffector_force_xyz = endeffectorforce(actual_torque_load, weighing_position);
    
    disp(" End Effect Force");
    disp(endeffector_force_xyz);
    
    % calculate end effector force magnitude
    endeffector_force_magnitude = (abs(endeffector_force_xyz(3,1))*endeffector_force_xyz(3,1))*1000;
    
    disp('endeffector_force_magnitude');
    disp(endeffector_force_magnitude);
    
    if (endeffector_force_magnitude < -0.000100000000000000000000)
        disp("Object is heavy");
        img_stats.Weight = "heavy";
    else
        disp(" Object is slim ")
        img_stats.Weight = "light";
    end
    
    pause(1);
    
    % ----------------------- Sort the object ------------------------------
    
    color = img_stats.Color;
    
    time_to_storage = 9.25; % seconds
    num_steps = 50;
    
    switch color
        case "Blue"
            if img_stats.Weight == "heavy"
                
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    blue_heavy_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            else
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    blue_light_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            end
            
        case "Green"
            if img_stats.Weight == "heavy"
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    green_heavy_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            else
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    green_light_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            end
            
        case "Yellow"
            if img_stats.Weight == "heavy"
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    yellow_heavy_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            else
                
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    yellow_light_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            end
    end
    
    pause(0.5);
    
    % send the gripper to open.
    grippacket(1,1) = 0;
    returnpacket = pp.command(GRIP_ID, grippacket);
    
    
    
    % Send the arm out of the storage zone
    last_point = trajectory(:,i) .*  [ 1; 1; 0 ];
    point = last_point + [0; pi/6 ; 0];
    send_point(PID_ID,pp,pidpacket,point);
    
   
    
    % Clear all important variables
    trajectory = 0;
    img_stats.Color = "";
    img_stats.Centroid = [ 0 0 ] ;
    img_stats.Weight = "";
    
    
    
end

% Clear up memory upon termination
pp.shutdown()
clear java;