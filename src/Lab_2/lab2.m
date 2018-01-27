%%
% RBE3001 - Laboratory 1 
% 
% Instructions
% ------------
% Welcome again! This MATLAB script is your starting point for Lab
% 1 of RBE3001. The sample code below demonstrates how to establish
% communication between this script and the Nucleo firmware, send
% setpoint commands and receive sensor data.
% 
% IMPORTANT - understanding the code below requires being familiar
% with the Nucleo firmware. Read that code first.

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;


% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); % !FIXME why is the deviceID == 7?

try
    
    
    
    % 11.44 ticks per degree
    angconv = -11.44;

    SERV_ID = 37;            % we will be talking to server ID 37 on
                             % the Nucleo
    STATUS_ID = 42;          % For when we want to read all data.

    DEBUG   = true;          % enables/disables debug prints

    % Instantiate a packet - the following instruction allocates 64
    % bytes for this purpose. Recall that the HID interface supports
    % packet sizes up to 64 bytes.
    packet = zeros(15, 1, 'single');

    pidpacket = zeros(15, 1, 'single');

    % The following code generates a sinusoidal trajectory to be
    % executed on joint 1 of the arm and iteratively sends the list of
    % setpoints to the Nucleo firmware. 
    viaPts = [0, -400, 400, -400, 400, 0];
  
    
    % The angle that we want is 0 degrees.
    pidpacket(1) = 0; 
    pidpacket(2) = 0;
    pidpacket(3) = 0;
    returnPacket = pp.command(SERV_ID, pidpacket);
    
    pause(2);
  
    % The angle that we want is 30 degrees.
    pidpacket(1) = 30*angconv;
    pidpacket(2) = 30*angconv;
    pidpacket(3) = 10*angconv;
    returnPacket = pp.command(SERV_ID, pidpacket);

  
    % Variables to hold the angle fo each link
    waistangle = 0;
    elbowangle = 0;
    wristangle = 0;
    
    posmatrix = [1,4];  % matrix to hold base position and time
    i = 1;   %row of matrix
    
    % Link Lengths in meters
    L1length = 0.135;
    L2length = 0.175;
    L3length = 0.16928;
    
    %Intialize figure for the plot of the arm
    figure;

    
    %Begin time tracking
    tic

    for n = 0:80
        % Send packet to the server and get the response
        returnPacket = pp.command(STATUS_ID, packet);
        
        % Capture time of sample
        time = toc;
        
        %Read the encoder values from the packet and convert them
        waistangle = angtodeg(returnPacket(1));
        elbowangle = angtodeg(returnPacket(2));
        wristangle = angtodeg(returnPacket(3));
            
        %Save the values to a matrix for logging
        posmatrix(i,1) = time;
        posmatrix(i,2) = waistangle;
        posmatrix(i,3) = elbowangle;
        posmatrix(i,4) = wristangle;
        
        %plot link 1
        % plot3([0,0,0], [0,0,L1length], 'LineWidth',5);
        %plot link1
        % plot3([0,0,L1length], [L2length*cos(elbowangle) + L1length], ...
        %     L2length*sin(waistangle), L2length*sin(elbowangle)], ...
        %    'LineWidth',5);
        
        %plot link2
        % plot3([L2length*cos(elbowangle + L1length), L2length*sin(waistangle), L2length*sin(elbowangle)], ...
        %    (L2length*cos(elbowangle + L1length), L2length*sin(waistangle), L2length*sin(elbowangle)], ...
        %    'LineWidth',5);
        drawnow;
        i = i + 1;
        pause(0.1);
    end



  
  
    % The angle that we want is 0 degrees.
    pidpacket(1) = 0;
    pidpacket(2) = 0;
    pidpacket(3) = 0;
    returnPacket = pp.command(SERV_ID, pidpacket);




csvwrite('baseplot.csv', posmatrix);

catch
    disp('Exited on error, clean shutdown');
end


% Clear up memory upon termination
pp.shutdown()
clear java;

toc