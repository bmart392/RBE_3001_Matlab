% move all the joints at the same time
% moves base to 30 degrees, elbow to 60 degrees, and wrist to 45 degrees
% saves to csv file

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;


% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); 

try
  SERV_ID = 37;            % This controls the robot
  STATUSID = 42;           % This gives the status of the robot

  DEBUG   = true;          % enables/disables debug prints

  % Instantiate a packet - the following instruction allocates 64
  % bytes for this purpose. Recall that the HID interface supports
  % packet sizes up to 64 bytes.
  statuspacket= zeros(15, 1, 'single');
  pidpacket= zeros(15, 1, 'single');
  
  angconv = -11.44;         % 11.44 ticks per degree
  baseAngle = 30;
  elbowAngle = 60;
  wristAngle = 45;
  
  jointmatrix = [1,4];  % matrix to hold joint angles and time
  i = 1;                % row of matrix
  time = 0;             % make sure time starts at 0
  
  tic % start time
  
  % move all joints to some angle
  pidpacket(1) = baseAngle * angconv;
  pidpacket(2) = elbowAngle * angconv;
  pidpacket(3) = wristAngle * angconv;
  returnpidpacket = pp.command(PIDID, pidpacket);
  
  pause(2)
  
  % move all joints back to home position
  pidpacket(1) = 0;
  pidpacket(2) = 0;
  pidpacket(3) = 0;
  returnpidpacket = pp.command(PIDID, pidpacket);
  
  % get time stamp
  time = toc;   
  % check status
  returnstatusacket = pp.command(SERV_ID, statuspacket);
      
  % put in matrix
  jointmatrix(1,1) = time;
  jointmatrix(1,2) = returnstatuspacket(1);
  jointmatrix(1,2) = returnstatuspacket(2);
  jointmatrix(1,2) = returnstatuspacket(3);
  
  
  % save to csv
  csvwrite('jointangles.csv', jointmatrix);
  
  
catch
  disp('Exited on error, clean shutdown');
end


% Clear up memory upon termination
pp.shutdown()
clear java;