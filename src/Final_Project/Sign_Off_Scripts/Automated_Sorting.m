%% Automated_sorting.m
% This is the final script for the sorting process of the final project

%%%%%%%%%%%%%%%%% Initializations and Setup %%%%%%%%%%%%%%%%%%%

% --------------------- Java Setup -------------------------
  
clear java;

javaaddpath('../lib/hid4java-0.5.1.jar');

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

% ------ Save Storage Positions for each Type of Object -------------

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

%%%%%%%%%%%%%%%%%%% Start of Automation Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% send the gripper to open.
grippacket(1,1) = 0;
returnpacket = pp.command(GRIP_ID, grippacket);

% Infinite loop that sorts until the task space is empty
while 1
    
    

    %%%%%%%%%%%%%% Weigh Arm in Weighing Position %%%%%%%%%%%%%%
    weighing_position = [ 0; pi/2; 0 ];
    
    % Send the arm to the weighing position
    send_point(PID_ID,pp,pidpacket,weighing_position);
    
    % Set inputs to collect_n_samples function
    Collect_PositionandTorque_Only = 9;
    num_samples = 1;                    
    
    % Wait for the arm to reach destination and stop shaking
    pause(3);
    
    % Read the torques from each joint
    no_torque_load = collect_n_samples(...
        Collect_PositionandTorque_Only,num_samples,...
        TORQUE_ID,pp, torquepacket);
    
    % Set the value sampled from joint 1 and joint 2 to be 0 to remove
    % possible noise
    no_torque_load(1,:) = 0;
    no_torque_load(2,:) = 0;    
    
    
    
    %%%%%%%%%%%%% Calculate the Position of the object %%%%%%%%%%%%%%%
    
    % -------- Move the arm out of the way of the Camera --------------
    
    send_point(PID_ID,pp, pidpacket, [0; pi/2; 0]);
    
    % Wait for the arm to arrive
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
    
    disp("");
    disp("Color of Object");
    disp(img_stats.Color);
    
    % Calculate the position of the centroid in the task space
    taskspace_position_camera = (choose_mn2xy(img_stats.Centroid(1),...
        img_stats.Centroid(2)))./100;
    
    % Create two points for the object. The first point is above the object
    % and the second point is the correct Z height. Enables the robot to
    % come directly down on the object.
    taskspace_position = cat(2,taskspace_position_camera,-0.00)';
    taskspace_position_end = cat(2,taskspace_position_camera,-0.02)';
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%% Pick up the object %%%%%%%%%%%%%%%%%%%%%
    
    % ----------- Find Current Position of the Arm -----------------------
    
    % Set the inputs to the collect_samples function
    ONLY_POSITION = 7;
    num_samples = 1;
    
    % Sample for the current position
    current_pos_radians = collect_n_samples(ONLY_POSITION,num_samples,...
        STATUS_ID,pp,statuspacket);
    
    % Calculate the current XYZ position of the arm
    current_pos_xyz_full = forward_kinematics_rad(current_pos_radians);
    current_pos_xyz = current_pos_xyz_full(4,:);
    
    % ---------- Calculate the Joint Angles for the Centroid -------------
    
    % Calculate the inverse kinematics of the two points for the object
    object_position_angles = inverse_kinematics(taskspace_position);
    object_position_angles_end = inverse_kinematics(taskspace_position_end);
    
    % ------ Calculate the Trajectory Required to Reach the Object -------
    
    time_to_object = 9.25; % seconds
    num_steps = 50;
    
    % Create the trajectory to go to the higher point
    trajectory = full_trajgen_cubic(1,[  current_pos_radians ...
        object_position_angles ], time_to_object, num_steps);
    
    % ----------------- Move the robot to the object ---------------------
    
    % Open the gripper.
    grippacket(1,1) = 0;
    returnpacket = pp.command(GRIP_ID, grippacket);
    
    % Send the robot to each point in the trajectory
    for i= 1:size(trajectory,2)
        send_point(PID_ID,pp,pidpacket,trajectory(:,i));
    end
    
    % Send the robot to the second (and correct Z height) positoin for the
    % object
    send_point(PID_ID,pp,pidpacket,object_position_angles_end);
    pause(0.25);
    
    % Close the gripper.
    grippacket(1,1) = 1;
    returnpacket = pp.command(GRIP_ID, grippacket);
    
    
    %%%%%%%%%%%%%%%%%%%%%% Weigh the object %%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    % --------------------- Pick up object----------------------------------
    
    % Send the arm to an intermediary position
    send_point(PID_ID,pp,pidpacket,object_position_angles_end + [ 0; pi/3; 0]);
    
    % Wait for the arm to move
    pause(0.5);
    
    % Send the arm to the weighing position
    send_point(PID_ID,pp,pidpacket,weighing_position);
    
    % Set the inputs for the collect_n_samples function
    Collect_PositionandTorque_Only = 9;
    num_samples = 1;            
    
    % Wait for the robot to arrive and stop moving
    pause(3);
    
    % Read the torque values from each joint
    torque_load = collect_n_samples(...
        Collect_PositionandTorque_Only,num_samples,...
        TORQUE_ID,pp, torquepacket);
    
    % Set the value sampled from joint 1 and joint 2 to be 0 to remove
    % possible noise
    torque_load(1,:) = 0;
    torque_load(2,:) = 0;
    
    
%     average_torque_load = torque_load;
%     
%     torque_load = average_torque_load;
    
    % Calculate the actual torque for the object
    actual_torque_load = torque_load - no_torque_load;
    
    % Calculate end effector XYZ force components
    endeffector_force_xyz = endeffectorforce(actual_torque_load,...
        weighing_position);
      
    % Calculate the signed magnitude of the end effector force
    endeffector_force_magnitude = (abs(endeffector_force_xyz(3,1)) * ...
        endeffector_force_xyz(3,1))*1000;
    
    % Check to see if the object is light or heavy
    if (endeffector_force_magnitude < -0.0001)
        disp("Object is heavy");
        img_stats.Weight = "heavy";
    else
        disp("Object is light ")
        img_stats.Weight = "light";
    end
    
    % Wait to display the weight before moving the object
    pause(0.25);
    
    %%%%%%%%%%%%%%%%%%% Sort the object %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Save the color of the object
    color = img_stats.Color;
    
    % Set the parameters for the trajectory
    time_to_storage = 9.25; % seconds
    num_steps = 50;
    
    % Use switch statement to determine where to place the object
    switch color
        case "Blue"
            
            % Determine if the object is blue
            if img_stats.Weight == "heavy"
                
                % Create a trajector to the heavy blue storage area
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    blue_heavy_storage_position_angle ], time_to_storage, num_steps);
                
                % Send the object to the storage position
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            else
                
                % Create a trajector to the light blue storage area
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    blue_light_storage_position_angle ], time_to_storage, num_steps);
                
                % Send the object to the storage position
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            end
            
        case "Green"
            
            % Determine if the object is heavy
            if img_stats.Weight == "heavy"
                
                % Create a trajector to the heavy green storage area
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    green_heavy_storage_position_angle ], time_to_storage, num_steps);
                
                % Send the object to the storage position
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            else
                
                % Create a trajector to the light green storage area
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    green_light_storage_position_angle ], time_to_storage, num_steps);
                
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            end
            
        case "Yellow"
            % Determine if the object is yellow
            if img_stats.Weight == "heavy"
                
                % Create a trajector to the light yellow storage area
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    yellow_heavy_storage_position_angle ], time_to_storage, num_steps);
                
                % Send the object to the storage position
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            else
                
                % Create a trajector to the light yellow storage area
                trajectory = full_trajgen_cubic(1,[  weighing_position ...
                    yellow_light_storage_position_angle ], time_to_storage, num_steps);
                
                % Send the object to the storage position
                for i= 1:size(trajectory,2)
                    send_point(PID_ID,pp,pidpacket,trajectory(:,i));
                end
                
            end
    end
    
    % Wait for the arm to arrive
    pause(0.5);
    
    % Open the gripper.
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
    
    % Clear the command window to make reading easier
    clc;
    
end

% Clear up memory upon termination
pp.shutdown()
clear java;