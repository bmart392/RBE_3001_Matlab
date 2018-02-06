%% Part 5: Interpolation
% create a triangle in 3D task space
% interpolate 10 evenly spaced points in between each vertex

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

global pp;                  % create the packetprocessor variable
pp = PacketProcessor(7);    % initialize the value

%try
global PID_ID;              % create the PID_ID constant
PID_ID = 37;                % initialize the value

global STATUS_ID;           % create the STATUS_ID constant
STATUS_ID = 42;             % initialize the value

global statuspacket;        % create the statuspacket
statuspacket = zeros(15,... % fill the packet with variables
    1,'single');

global pidpacket;           % create the pidpacket
pidpacket = zeros(15,1,...  % fill the packet with variables
    'single');

global angconv;             % create the angconv constant
angconv = 11.44;            % initialize the value


row_counter = 1;
readings = zeros(600,4);
jointmatrix = zeros(360,4);

% vector qs holds angles (in deg) of base, elbow, and wrist joints
% Column is the point
qs = angconv.*cat(2, [30; 30; 30], [-10; 60; 20], [15; 25; -10]);

% matrix to hold the 3 vertices in task space
% calculates the end effector positions (x,y,z)
vertices = [0 0 0; 0 0 0; 0 0 0; 0 0 0];
for h = [1 2 3]
        Matrix = kinematics(qs(:,h));
        vertices(h,1:3) = Matrix(4,:);
end

% Transpose the matrix to work with inverse_kinematics
% becomes 3x4 matrix
vertices = vertices';

% make sure the robot is at vertex 1
desiredang(1:3,1) = inverse_kinematics(vertices(:,1));

% fill a packet with the proper data for each the mth location
for j=0:2
    pidpacket((j*3)+1) = (angconv*(desiredang(j+1,1)));
end
returnpidpacket = pp.command(PID_ID, pidpacket);

pause(2);   % make sure it has time to get there

% Each path is a 3x27 matrix of end effector positions
% Each column is an x,y,z end effector location
path_xyz_1to2 = interpolation(vertices(:,1),vertices(:,2),10);
path_xyz_2to3 = interpolation(vertices(:,2),vertices(:,3),10);
path_xyz_3to1 = interpolation(vertices(:,3),vertices(:,1),10);

% Each path is a 3x27 matrix of joint angles
% Each column is a j0, j1, j2 vector
path_1to2 = inversekinematics_path(path_xyz_1to2);
path_2to3 = inversekinematics_path(path_xyz_2to3);
path_3to1 = inversekinematics_path(path_xyz_3to1);

% Append the individual paths into a continuous path
% full_path is still joint angles
full_path = cat(2,path_1to2,path_2to3,path_3to1);

tic     % start time tracking
disp(size(full_path));
% We iterate through the columns
for w = 1:36
    % fill a packet with the proper data for each the wth location
    for j=0:2
        pidpacket((j*3)+1) = (angconv*(full_path(j+1,w)));
    end
    
    % move to position
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    % track the status of the robot while moving to positions
    for i = 1:10
        % save time
        time = toc;
        % check status
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        for V=1:3
            readings(V,1) = returnstatuspacket(V*3-2);
        end
        % put in matrix
        jointmatrix(row_counter, 1) = time;
        for k=2:4
            jointmatrix(row_counter, k) = (readings(k-1,1));
        end
        row_counter = row_counter +1;
    end
    
end

pause(1);

% save to csv
csvwrite('interpolated_positions.csv', jointmatrix);

% catch
%     disp('Exited on error, clean shutdown');
% end

% Clear up memory upon termination
pp.shutdown()
clear java;