% test joint movement

javaaddpath('.../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear; close all;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7);

% try

% Creating the robot structure.
Robot.l1 = 0.135;
Robot.l2 = 0.175;
Robot.l3  = 0.16928;

% y0 is the initial conditions.
y0 = kinematics([0; 0; 0]);

%% Plotting code.

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

% Setting the "handle" field in "Robot" structure to be the handle of
% the arm plot.
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);


PIDID  = 37;            % This controls the robot
STATUSID = 42;           % This gives the status of the robot

DEBUG    = true;          % enables/disables debug prints

% Instantiate a packet - the following instruction allocates 64
% bytes for this purpose. Recall that the HID interface supports
% packet sizes up to 64 bytes.
statuspacket= zeros(15, 1, 'single');
pidpacket= zeros(15, 1, 'single');

% The following code generates a sinusoidal trajectory to be
% executed on joint 1 of the arm and iteratively sends the list of
% setpoints to the Nucleo firmware.
% viaPts = [0, -400, 400, -400, 400, 0];

% 11.44 ticks per degree
angconv = 11.44;

j = 1;               % joint 1 = base, 2 = elbow, 3 = wrist
jointmatrix = [10,2];  % matrix to hold joint angles and time
i = 1;               % row of matrix
time = 0;            % make sure time starts at 0

%endeffectLocation = zeros(5,3);

%theseones = [1 4 7];

readings = zeros(3,1);

pos = [ 0 26.0 -150.5; 0 -41.25 476.5; ...
    0 756.0 -129.75; ];
numinterpolations = 10;



desiredpos(:,:) = threepointtraj(pos(1,:),...
    pos(2,:),pos(3,:),numinterpolations);
disp(desiredpos);
tic
for k = 1:30
    for u = 0:2
        pidpacket((3*u)+1) = desiredpos(k,u+1);
    end
    
    % send the packet with data for the mth location
    returnpidpacket = pp.command(PIDID, pidpacket);
    
    %-track the location of the arm getting to the mth location --
    % track the status of the arm while moving to each position
    
        for i = 1:2
            % save time
            time = toc;
            % check status
            returnstatuspacket = pp.command(STATUSID, statuspacket);
            readings(1,1) = returnstatuspacket(1);
            readings(2,1) = returnstatuspacket(4);
            readings(3,1) = returnstatuspacket(7);
            
            % Plot the robot transformations given.
            %RobotPlotter(Robot, readings);
            %drawnow;
            
            %answer = kinematics(readings);
            % put in matrix
            jointmatrix(((2*(k-1))+i), 1) = time;
            jointmatrix(((2*(k-1))+i), 2) = readings(1,1);
            jointmatrix(((2*(k-1))+i), 3) = readings(2,1);
            jointmatrix(((2*(k-1))+i), 4) = readings(3,1);
        end
    
    
    %pause(1);
    
end

% move back to home position
for d=0:2
    pidpacket((d*3)+1) = 1;
end

returnpidpacket = pp.command(PIDID, pidpacket);

pause(2);

% save to csv
csvwrite('interpolationjoints.csv', jointmatrix);

% catch
% disp('Exited on error, clean shutdown');
% end


% Clear up memory upon termination
pp.shutdown()
clear java;
