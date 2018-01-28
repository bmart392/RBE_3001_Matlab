
javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); % !FIXME why is the deviceID == 7?
  


% Zero the arm
    
    % The angle that we want is 0 degrees.
    % pidpacket(1) = 0; 
    % pidpacket(2) = 0;
    % pidpacket(3) = 0;
    % returnPacket = pp.command(SERV_ID, pidpacket);
    
    % Wait so that the arm can zero out.
    % pause(3);
  


    % Now we want to make the robot rotate 30 degrees right (robot pov),
    % then rotate the shoulder up 40 degrees, then rotate elbow down 20
    % degrees. Remember, the waist is inverted (in some way).
    pidpacket(1) = -30*angconv;
    pidpacket(2) = 40*angconv;
    pidpacket(3) = -20*angconv;
    returnPacket = pp.command(SERV_ID, pidpacket);
    
    % Make sure robot got there.
    pause(3);

  
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
    
    % The angle that we want is 0 degrees.
    pidpacket(1) = 0;
    pidpacket(2) = 0;
    pidpacket(3) = 0;
    returnPacket = pp.command(SERV_ID, pidpacket);
    