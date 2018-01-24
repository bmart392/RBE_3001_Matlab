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
<<<<<<< HEAD:src/Lab_1/lab1.m
SERV_ID = 42;            % we will be talking to server ID 37 on
                         % the Nucleo

var1 = 0;
                         
DEBUG   = true;          % enables/disables debug prints
=======
try
  SERV_ID = 37;            % we will be talking to server ID 37 on
                           % the Nucleo

  DEBUG   = true;          % enables/disables debug prints
>>>>>>> 5e739f26c2f222e7254fb8bfa0e9c73d2ea73f8b:src/lab1.m

  % Instantiate a packet - the following instruction allocates 64
  % bytes for this purpose. Recall that the HID interface supports
  % packet sizes up to 64 bytes.
  packet = zeros(15, 1, 'single');

<<<<<<< HEAD:src/Lab_1/lab1.m
% The following code generates a sinusoidal trajectory to be
% executed on joint 1 of the arm and iteratively sends the list of
% setpoints to the Nucleo firmware. 

% viaPts = [0, -400, 400, -400, 400, 0];
viaPts1 = [1, 2, 3, 4, 5];
viaPts2 = [1, 4, 7];

% this is a giant matrix that stores the result of polling the status
% server.
% giant = zeros(9,5);
% giant = zeros(9,6); % 6 for averaging rows 1,4, and 7
giant = zeros(9,8); % 6 for averaging rows 1,4, and 7

tic
    
% Iterate through a sine wave for joint values
for k = viaPts1
    %incremtal = (single(k) / sinWaveInc);

    packet(1) = k;

    % Send packet to the server and get the response
    returnPacket = pp.command(SERV_ID, packet);

    for var1 = 1:15
        giant(var1, k) = (abs(returnPacket(var1)) > 0.0001) * returnPacket(var1);
    end

    var1 = 1;

    toc
    
    if DEBUG
        disp('Sent Packet:');
        disp(packet);
        disp('Received Packet:');
        disp(returnPacket);
    end
    pause(0.5) %timeit(returnPacket) !FIXME why is this needed?
end

% This is for taking the averge of the positions so that we have nice
% values.
for k = viaPts2
    giant(k, 6) = ((giant(k,1)+giant(k,2)+giant(k,3)+giant(k,4)+giant(k,5))/5);
end


csvwrite('test.csv', giant);
    
=======
  % The following code generates a sinusoidal trajectory to be
  % executed on joint 1 of the arm and iteratively sends the list of
  % setpoints to the Nucleo firmware. 
  viaPts = [0, -400, 400, -400, 400, 0];

  tic

  % Iterate through a sine wave for joint values
  for k = viaPts
      %incremtal = (single(k) / sinWaveInc);

      packet(1) = k;


      % Send packet to the server and get the response
      returnPacket = pp.command(SERV_ID, packet);
      toc

      if DEBUG
          disp('Sent Packet:');
          disp(packet);
          disp('Received Packet:');
          disp(returnPacket);
      end

      pause(1) %timeit(returnPacket) !FIXME why is this needed?
  end
catch
    disp('Exited on error, clean shutdown');
end
>>>>>>> 5e739f26c2f222e7254fb8bfa0e9c73d2ea73f8b:src/lab1.m
% Clear up memory upon termination
pp.shutdown()
clear java;

toc
