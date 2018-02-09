% Generate a trajectory for 'd' dimensions between 'p' points using the
% assumed time, velocity, and acceleration characteristics or the inputed
% characteristics. This function is designed to generate a path of either
% cartesian coordinates or joint angles.
%
% OUTPUT NOTE: This function will generate a trajectory with points =
% (((number of steps between points+1)*(number of vertices-1)) + 1)
%
% This function has two versions:
%       VERSION 1: Assumes the starting time, start velocity, end velocity,
%       start acceleration, and end acceleration to be 0.
%
%       VERSION 2: Assumes nothing. Requires start time, end time, start
%       velocity, end veocity, acceleration, and end acceleration to be
%       specified.
%
%
% ----- VERSION 1 -----
%   FUNCTION CALL: full_trajgen_quintic(version, vertices, ...
%                       time_elapsed, abbreviated_numsteps);
%   INPUTS: version = specifies the version of the code to use. {1 = switch
%                           statement 1 is executed; 2 = switch statement
%                           2 is executed}
%           vertices = a n x m matrix that holds each vertex in a
%                       column. Must be a least 1 x 1.
%           time_elapsed = a 1 x m matrix that holds the amount of time
%                           in which each part of the trajectory a leg is
%                           to be executed.
%           abbreviated_numsteps = the number of points to generate for
%                                   each part of the trajectory
%   OUTPUT: trajectory = a n x m matrix of points that are the trajectory
%                           of the robot. Each column of the matrix
%                           represents point
%
% ----- VERSION 2 -----
%   FUNCTION CALL:
%       full_trajgen_quintic(2,0,0,0, joint1_pointcharacteristics,...
%               joint2_pointcharacteristics,joint3_pointcharacteristics,
%               numsteps);
%
% INPUTS:The characteristics of each point are defined in the
%           gentraj_interpolation_quintic function
%
%           joint1_pointcharacteristics = the characteristics of joint 1
%           joint2_pointcharacteristics = the characteristics of joint 2
%           joint3_pointcharacteristics = the characteristics of joint 3
%           numsteps = the number of steps interpolated in each trajectory
%
% OUTPUT:   a 3 x n matrix where each column holds all of the values for
%           one link and each row holds the joint values for one point
function trajectory = full_trajgen_quintic(version, vertices, ...
    time_elapsed, abbreviated_numsteps, ...
    joint1_pointcharacteristics, joint2_pointcharacteristics, ...
    joint3_pointcharacteristics,numsteps)

% Intialize cases for the switch statement
WITHSTANDARDASSUMPTIONS = 1;    % Version 1
NOASSUMPTIONS = 1;              % Version 2


DONTCALCENDPOINT = 0;
CALCENDPOINT = 1;

switch version
    
    % Version 1
    case WITHSTANDARDASSUMPTIONS
        
        
        % Define Standard Assumptions
        ASSUMED_START_TIME = 0; % seconds
        
        ASSUMED_INITIAL_VELOCITY = 0; % m/s
        ASSUMED_FINAL_VELOCTIY = 0; % m/s
        
        ASSUMED_INITIAL_ACCELEREATION = 0; % m/s^2
        ASSUMED_FINAL_ACCELERATION = 0; % m/s^2
        
        % Determine the size of the input matrices
        COLUMNS = 2;
        ROWS = 1;
        num_vertices = size(vertices,COLUMNS);
        num_dimensions = size(vertices,ROWS);
        
        % Check that the number of vertexes is greater than 1
        if(num_dimensions < 1 || num_vertices < 1)
            error('The matrix of points inputed is too small.');
        end
        
        % Check that the number of time steps is the right amount for the
        % number of vertexes inputted
        if(size(time_elapsed,COLUMNS) ~= (num_vertices - 1))
            error('Incorrect number of input arguements for time_elapsed');
        end
        
        % Initialize the indeer for the final trajectory matrix
        i = 1;
        
        % Initialize a matrix to hold the trajectory generated
        trajectory = zeros(num_dimensions,(num_vertices-1)*...
            abbreviated_numsteps);
        
        
        % Use a for loop to iterate through each dimension of a given point
        for j = 1:num_dimensions
            % Use a for loop to iterate through the number of vertices in
            % each dimension
            for k = 1:num_vertices-1
                % Determine if the trajectory being calculated is NOT the
                % last one in the series of points
                if(k ~= num_vertices-1)
                    % Calculate the trajectory between vertices k and k+1
                    positions = gentraj_interpolation_quintic(ASSUMED_START_TIME,...
                        time_elapsed(k), vertices(j,k), vertices(j,k+1), ...
                        ASSUMED_INITIAL_VELOCITY, ASSUMED_FINAL_VELOCTIY, ...
                        ASSUMED_INITIAL_ACCELEREATION, ASSUMED_FINAL_ACCELERATION,...
                        abbreviated_numsteps,DONTCALCENDPOINT);
                    % Transfer those values to the return matrix
                    for w = 1:abbreviated_numsteps+1
                        trajectory(j,i+w-1) = positions(w);
                    end
                    
                    % Increment the index for the return matrix
                    i = i + abbreviated_numsteps +1;
                    
                end
                
                % Determine if the trajectory being calculated is the
                % last one in the series of points
                if(k == num_vertices-1)
                    % Calculate the trajectory between vertices k and k+1
                    positions = gentraj_interpolation_quintic(ASSUMED_START_TIME,...
                        time_elapsed(k), vertices(j,k), vertices(j,k+1), ...
                        ASSUMED_INITIAL_VELOCITY, ASSUMED_FINAL_VELOCTIY, ...
                        ASSUMED_INITIAL_ACCELEREATION, ASSUMED_FINAL_ACCELERATION,...
                        abbreviated_numsteps,CALCENDPOINT);
                    
                    % Transfer those values to the return matrix
                    for w = 1:abbreviated_numsteps+2
                        trajectory(j,i+w-1) = positions(w);
                    end 
                end
            end
            % Reset the index for the return matrix
            i = 1;
        end
        
        
        
        
    case NOASSUMPTIONS
        % Calculate the trajectory of the first joint using the given
        % characteristics.
        trajectory(:,1) = gentraj_interpolation_quintic(joint1_pointcharacteristics(1),...
            joint1_pointcharacteristics(2), joint1_pointcharacteristics(3), ...
            joint1_pointcharacteristics(4),joint1_pointcharacteristics(5), ...
            joint1_pointcharacteristics(6), joint1_pointcharacteristics(7), ...
            joint1_pointcharacteristics(8), numsteps, DONTCALCENDPOINT);
        
        % Calculate the trajectory of the second joint using the given
        % characteristics.
        trajectory(:,2) = gentraj_interpolation_quintic(joint2_pointcharacteristics(1),...
            joint2_pointcharacteristics(2), joint2_pointcharacteristics(3), ...
            joint2_pointcharacteristics(4),joint2_pointcharacteristics(5), ...
            joint2_pointcharacteristics(6), joint2_pointcharacteristics(7), ...
            joint2_pointcharacteristics(8), numsteps, DONTCALCENDPOINT);
        
        % Calculate the trajectory of the third joint using the given
        % characteristics.
        trajectory(:,3) = gentraj_interpolation_quintic(joint3_pointcharacteristics(1), ...
            joint3_pointcharacteristics(2), joint3_pointcharacteristics(3), ...
            joint3_pointcharacteristics(4),joint3_pointcharacteristics(5), ...
            joint3_pointcharacteristics(6), joint3_pointcharacteristics(7), ...
            joint3_pointcharacteristics(8), numsteps, CALCENDPOINT);
end

end

