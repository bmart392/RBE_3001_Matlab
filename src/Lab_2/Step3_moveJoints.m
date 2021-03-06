% Step 3: test joint movement

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
    PIDID  = 37;            % This controls the robot
    STATUSID = 42;           % This gives the status of the robot
    
    DEBUG    = true;          % enables/disables debug prints
    
    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    statuspacket= zeros(15, 1, 'single');
    pidpacket= zeros(15, 1, 'single');
    
    
    % 11.44 ticks per degree
    angconv = 11.44;
    
    j = 1;                % joint 1 = base, 2 = elbow, 3 = wrist
    jointmatrix = [10,2]; % matrix to hold joint angles and time
    i = 1;                % row of matrix
    time = 0;             % make sure time starts at 0
    
    tic                  % Begin time tracking
    
    for j = 0:2
        % move joint 30 degrees
        pidpacket((j*3)+1) = 30 * angconv;
        disp(pidpacket((j*3)+1));
        returnpidpacket = pp.command(PIDID, pidpacket);
        
        % save time
        time = toc;
        
        % check status
        returnstatuspacket = pp.command(STATUSID, statuspacket);
        
        % put in matrix
        jointmatrix(i,1) = time;
        jointmatrix(i,2) = returnstatuspacket((j*3)+1);
        
        i = i+1;
        
        % move back to home position
        pidpacket((j*3)+1) = 0;
        
        returnpidpacket = pp.command(PIDID, pidpacket);
        
        % save time
        time = toc;
        
        % check status
        returnstatuspacket = pp.command(STATUSID, statuspacket);
        
        % put in matrix
        jointmatrix(i,1) = time;
        jointmatrix(i,2) = returnstatuspacket((j*3)+1);
        
        i = i+1;
        
        pause(1);
        
    end
    
    % save to csv
    csvwrite('joints.csv', jointmatrix);
    
catch
    disp('Exited on error, clean shutdown');
end


% Clear up memory upon termination
pp.shutdown()
clear java;
