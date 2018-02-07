% Generate a trajectory for each link between two given points and the associated
% time, velocity, and acceleration characteristics of the given end points.
% Each input should be in the form of a 1x8 matrix
% INPUTS:   joint1_pointcharacteristics = the characteristics of joint 1
%           joint2_pointcharacteristics = the characteristics of joint 2
%           joint3_pointcharacteristics = the characteristics of joint 3
%           numsteps = the number of steps interpolated in each trajectory
%
% OUTPUT:   a 3 x n matrix where each column holds all of the values for one
%           link and each row holds the joint values for one point

% [startpoints,endpoints,time_elapsed,numsteps] abbreviaed version
%


function trajectory = gentraj_versioned_fullrobot_quintic(...
    version,start_points,end_points,time_elapsed,abbreviated_numsteps,joint1_pointcharacteristics,joint2_pointcharacteristics,...
    joint3_pointcharacteristics,numsteps)

WITHSTANDARDASSUMPTIONS = 1;
 NOASSUMPTIONS = 1;

switch version
    case WITHSTANDARDASSUMPTIONS
        
        % Define Standard Assumptions
        ASSUMED_START_TIME = 0; % seconds
        
        ASSUMED_INITIAL_VELOCITY = 0; % m/s
        ASSUMED_FINAL_VELOCTIY = 0; % m/s
        
        ASSUMED_INITIAL_ACCELEREATION = 0; % m/s^2
        ASSUMED_FINAL_ACCELERATION = 0; % m/s^2
            
        FIRST_JOINT = 1;
        SECOND_JOINT = 2;
        THIRD_JOINT = 3;
        
        % Calculate the trajectory of the first joint using the given and
        % assumed characteristics.
        trajectory(:,1) = gentraj_interpolation_quintic(ASSUMED_START_TIME,...
            time_elapsed, start_points(FIRST_JOINT), end_points(FIRST_JOINT), ...
            ASSUMED_INITIAL_VELOCITY, ASSUMED_FINAL_VELOCTIY, ...
            ASSUMED_INITIAL_ACCELEREATION, ASSUMED_FINAL_ACCELERATION,...
            abbreviated_numsteps);
        
        % Calculate the trajectory of the second joint using the given
        %  and assumed characteristics.
        trajectory(:,2) = gentraj_interpolation_quintic(ASSUMED_START_TIME,...
            time_elapsed, start_points(SECOND_JOINT), end_points(SECOND_JOINT), ...
            ASSUMED_INITIAL_VELOCITY, ASSUMED_FINAL_VELOCTIY, ...
            ASSUMED_INITIAL_ACCELEREATION, ASSUMED_FINAL_ACCELERATION,...
            abbreviated_numsteps);
        
        % Calculate the trajectory of the third joint using the given
        % and assumed characteristics.
        trajectory(:,3) = gentraj_interpolation_quintic(ASSUMED_START_TIME,...
            time_elapsed, start_points(THIRD_JOINT), end_points(THIRD_JOINT), ...
            ASSUMED_INITIAL_VELOCITY, ASSUMED_FINAL_VELOCTIY, ...
            ASSUMED_INITIAL_ACCELEREATION, ASSUMED_FINAL_ACCELERATION,...
            abbreviated_numsteps);

        % Transpose the matrix 
        trajectory = trajectory';
        
        
    case NOASSUMPTIONS
        % Calculate the trajectory of the first joint using the given
        % characteristics.
        trajectory(:,1) = gentraj_interpolation_quintic(joint1_pointcharacteristics(1),...
            joint1_pointcharacteristics(2), joint1_pointcharacteristics(3), ...
            joint1_pointcharacteristics(4),joint1_pointcharacteristics(5), ...
            joint1_pointcharacteristics(6), joint1_pointcharacteristics(7), ...
            joint1_pointcharacteristics(8), numsteps);
        
        % Calculate the trajectory of the second joint using the given
        % characteristics.
        trajectory(:,2) = gentraj_interpolation_quintic(joint2_pointcharacteristics(1),...
            joint2_pointcharacteristics(2), joint2_pointcharacteristics(3), ...
            joint2_pointcharacteristics(4),joint2_pointcharacteristics(5), ...
            joint2_pointcharacteristics(6), joint2_pointcharacteristics(7), ...
            joint2_pointcharacteristics(8), numsteps);
        
        % Calculate the trajectory of the third joint using the given
        % characteristics.
        trajectory(:,3) = gentraj_interpolation_quintic(joint3_pointcharacteristics(1), ...
            joint3_pointcharacteristics(2), joint3_pointcharacteristics(3), ...
            joint3_pointcharacteristics(4),joint3_pointcharacteristics(5), ...
            joint3_pointcharacteristics(6), joint3_pointcharacteristics(7), ...
            joint3_pointcharacteristics(8), numsteps);
        
        trajectory = trajectory';
end

end

