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

try
    
    PID_CONFIG_ID = 65;  % pid config server
    PID_SERVER = 37;     % controls robot
    STATUS_ID = 42;      % returns status of the robot
    angconv = 11.44;     % 11.44 ticks per degree
    
    DEBUG    = true;     % enables/disables debug prints
    
    % create packets for each server
    pidconfigpacket = zeros(15,1);
    pidpacket = zeros(15,1);
    statuspacket = zeros(15,1);
    
    
    %% Plotting code.
    
    f = figure; % create figure
    axes;
    hold on;
    box on;
    grid on;
    title('PID Tuning Link 2');
    xlabel('Index'); ylabel('Position');
    
    
    % move the home the joints
    pidpacket(1) = 0;
    pidpacket(4) = 0;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_SERVER, pidpacket);
    
    pause(1);
    
    %% tune PID of Link 0
    
    % send the new pid constants, p i d
    pidconfigpacket(1) = 0.0015;
    pidconfigpacket(2) = 0.0001;
    pidconfigpacket(3) = 0.01;
    pidconfigpacket(4) = 0.005;
    pidconfigpacket(5) = 0.0000;
    pidconfigpacket(6) = 0.00;
    pidconfigpacket(7) = 0.005;
    pidconfigpacket(8) = 0.0000;
    pidconfigpacket(9) = 0.00;
    returnpidconfigpacket = pp.command(PID_CONFIG_ID, pidconfigpacket);
    
    pause(1);
    
    % move the base joint 60 degrees
    pidpacket(1) = 60 * angconv;
    pidpacket(4) = 0 * angconv;
    pidpacket(7) = 0;
    returnpidpacket = pp.command(PID_SERVER, pidpacket);
    
    % check status
    for i = 1:40
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        Link0readings(i,1) = returnstatuspacket(1);
    end
    
    % Plot the robot transformations given.
    plot(Link0readings);
    drawnow;
    
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
    returnpidpacket = pp.command(PID_SERVER, pidpacket);
    
    % check status
    for i = 1:40
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        Link1readings(i,1) = returnstatuspacket(4);
    end
    
    % Plot the robot transformations given.
    plot(Link1readings);
    drawnow;
    
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
    returnpidpacket = pp.command(PID_SERVER, pidpacket);
    
    % check status
    for i = 1:40
        returnstatuspacket = pp.command(STATUS_ID, statuspacket);
        Link2readings(i,1) = returnstatuspacket(7);
    end
    
    % Plot the robot transformations given.
    plot(Link2readings);
    drawnow;
    
catch
    disp('Exited on error, clean shutdown');
end

% Clear up memory upon termination
pp.shutdown()
clear java;
