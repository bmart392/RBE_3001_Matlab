% Step 4: Tune PID of all joints

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear; close all;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7);

PID_CONFIG_ID = 65;  % pid config server
PID_ID = 37;     % controls robot
STATUS_ID = 42;      % returns status of the robot
angconv = 11.44;     % 11.44 ticks per degree

COLLECT_POS = 1;    % Tell collect_n_samples to collect
%try
% create packets for each server
pidconfigpacket = zeros(15,1,'single');
pidpacket = zeros(15,1,'single');
statuspacket = zeros(15,1,'single');


%% Plotting code.

f = init_positionplot();


% move the home the joints
send_home(PID_ID,pidpacket,pp);
pause(1);

%% tune PID of Link 0

% send the new pid constants, p i d
pidconfigpacket(1) = 0.00150;
pidconfigpacket(2) = 0.0001;
pidconfigpacket(3) = 0.01;
pidconfigpacket(4) = 0.0025;
pidconfigpacket(5) = 0.0000;
pidconfigpacket(6) = 0.00;
pidconfigpacket(7) = 0.005;
pidconfigpacket(8) = 0.0000;
pidconfigpacket(9) = 0.00;
returnpidconfigpacket = pp.command(PID_CONFIG_ID, pidconfigpacket);


% move the base joint 60 degrees
point = [45; 0; 0];
send_point(PID_ID,pp,pidpacket,point);

tic;

% check status
Link0readings = collect_n_samples(1,300,STATUS_ID,pp,statuspacket);

disp(Link0readings);

baseline = zeros(2,300);
baseline(1,1:7) = 0;
baseline(1,7:end) = 45;
baseline(2,:) = 0:0.01:2.99;
% Plot the robot transformations given.
plot(baseline(2,:),baseline(1,:),Link0readings(1,:),Link0readings(2,:));
drawnow;

if 1 == 0
    %% tune PID of Link 1
    
    % send the new pid constants, p i d
    pidconfigpacket(1) = 0.0015;
    pidconfigpacket(2) = 0.0001;
    pidconfigpacket(3) = 0.01;
    pidconfigpacket(4) = 0.0015;
    pidconfigpacket(5) = 0.0003;
    pidconfigpacket(6) = 0.05;
    pidconfigpacket(7) = 0.005;
    pidconfigpacket(8) = 0.0000;
    pidconfigpacket(9) = 0.00;
    returnpidconfigpacket = pp.command(PID_CONFIG_ID, pidconfigpacket);
    
    pause(1);
    
    % move the elbow joint 60 degrees
    pidpacket(1) = 0;
    pidpacket(4) = 60 * angconv;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    % check status
    for i = 1:40
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        Link1readings(i,1) = returnstatuspacket(4);
    end
    
    % Plot the robot transformations given.
    plot(Link1readings);
    drawnow;
    pause(3);
    %% tune PID of Link 2
    
    % send the new pid constants, p i d
    pidconfigpacket(1) = 0.0015;
    pidconfigpacket(2) = 0.0001;
    pidconfigpacket(3) = 0.01;
    pidconfigpacket(4) = 0.0015;
    pidconfigpacket(5) = 0.0003;
    pidconfigpacket(6) = 0.05;
    pidconfigpacket(7) = 0.0015;
    pidconfigpacket(8) = 0.0003;
    pidconfigpacket(9) = 0.05;
    returnpidconfigpacket = pp.command(PID_CONFIG_ID, pidconfigpacket);
    
    pause(1);
    
    % move the wrist joint 60 degrees
    pidpacket(1) = 0;
    pidpacket(4) = 0;
    pidpacket(7) = 60 * angconv;
    returnpidpacket = pp.command(PID_ID, pidpacket);
    
    % check status
    for i = 1:40
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        Link2readings(i,1) = returnstatuspacket(7);
    end
    
    % Plot the robot transformations given.
    plot(Link2readings);
    drawnow;
    
    % catch
    %     disp('Exited on error, clean shutdown');
    % end
end
% Clear up memory upon termination
pp.shutdown()
clear java;

