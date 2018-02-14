clear java;

javaaddpath('..lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% Creating the robot structure.
Robot.l1 = 0.135;
Robot.l2 = 0.175;
Robot.l3  = 0.16928;

% y0 is the initial condition.
y0 = forward_kinematics([0; 0; 0]);

% The click offset
clickoffset = y0(4,:);

% The read in click position
readclick = [];


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
% This orients the view to the proper angle as requested in the lab.
view([ 0 -90 0]);

% Setting the "handle" field in "Robot" structure to be the handle of
% the arm plot.
Robot.handle = plot3(y0(:,1),y0(:,2),y0(:,3),'-o', ...
    'color', [0 0.4 0.7], 'LineWidth', 5);




threshold = [0.001; 0; 0.001];
COLLECT_POS = 7;

num_samples = 1;

STATUS_ID = 42;
PID_ID = 37;


pp = PacketProcessor(7);

pidpacket = zeros(15,'single');
statuspacket = zeros(15,'single');

send_home(PID_ID,pidpacket,pp);

user_input = dialog_box_truefalse('Would you like to select a point?','');
YES = 1;
NO = -1;
EXIT = 2;

while 1
    


if(user_input == YES)
clickhere = ginput3d(1);
disp("Click here");
disp(clickhere);
disp("End of click here");

% Now this read in position is the wanted end effector position.
wantedEndEffectorPosition = clickhere'; 

current_pos = collect_n_samples(COLLECT_POS,num_samples,STATUS_ID,pp,statuspacket);
disp('starting position (deg)');
disp(current_pos ./11.4);

current_pos_rad = (current_pos./11.4)*(pi/180);
end_position_angles = taylor_approximation(current_pos_rad,wantedEndEffectorPosition,threshold);

disp('calculated taylor_approx (deg)');
disp(end_position_angles*180/pi);

RobotPlotter2(Robot,end_position_angles);

sent_position = end_position_angles.*(180/pi).*(11.4).*[0;1;1];

disp("position being sent (ticks)");
disp(sent_position./11.4);

send_point(PID_ID,pp,pidpacket,sent_position);

disp('difference in desired and sent');
disp((current_pos - sent_position)./11.4);

end 

if(user_input == NO)
break;
end

if(user_input == EXIT)
break;
end

pause(2);
user_input = dialog_box_truefalse('Would you like to select a point?','');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
