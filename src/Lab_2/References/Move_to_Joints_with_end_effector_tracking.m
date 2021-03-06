% test joint movement

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear; close all;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); 

% try
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
 
  endeffectLocation = zeros(5,3);
  
  % These are the desired angle ticks.
  desiredpos = [ 268 177 170;
                 19 268 567;
                 -250 623 610;
                 -528 -105 1118;
                 -695 -126 2314 ];
  
  theseones = [1 4 7];
      
  readings = zeros(3,1);
  
  tic                  % Begin time tracking
  
  for m = 1:5
      % -------------move joint to desired locaion-------------
      % fill a packet with the proper data for each the mth location
      for j=0:2
          pidpacket((j*3)+1) = desiredpos(m,j+1);
      end
      
      % send the packet with data for the mth location
      returnpidpacket = pp.command(PIDID, pidpacket);
            
      %-track the location of the arm getting to the mth location --
      % track the status of the arm while moving to each position
      for i = 1:10
        % save time
        time = toc;
        % check status
        returnstatuspacket = pp.command(STATUSID, statuspacket);
        readings(1,1) = returnstatuspacket(1);
        readings(2,1) = returnstatuspacket(4);
        readings(3,1) = returnstatuspacket(7);
        answer = kinematics(readings);
        % put in matrix
        jointmatrix(i, (4*m)-3) = time;
        jointmatrix(i, (4*m)-2)   = answer(4,1);
        jointmatrix(i, (4*m)-1) = answer(4,2);
        jointmatrix(i, 4*m) = answer(4,3);
      end
      
      pause(2);
    
  end
  
% move back to home position
for d=0:2
    pidpacket((d*3)+1) = 1;
end

returnpidpacket = pp.command(PIDID, pidpacket);

pause(2);

% save to csv
csvwrite('joints.csv', jointmatrix);

% catch
% disp('Exited on error, clean shutdown');
% end


% Clear up memory upon termination
pp.shutdown()
clear java;
