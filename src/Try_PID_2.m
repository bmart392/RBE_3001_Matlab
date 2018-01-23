%live plot

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

% 11.44 ticks per degree
angconv = -11.44;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); % !FIXME why is the deviceID == 7?
STATUSID = 42;            % we will be talking to server ID 42 on
                         % the Nucleo
PIDID = 37;              % This server controls the robot
                         
DEBUG   = true;          % enables/disables debug prints

% Instantiate a statuspacket- the following instruction allocates 64
% bytes for this purpose. Recall that the HID interface supports
% statuspacket sizes up to 64 bytes.
statuspacket= zeros(15, 1, 'single');
pidpacket= zeros(15, 1, 'single');

% this is a giant matrix that stores the result of polling the status
% server.
giant = zeros(27,2);
% This is the row of the csv file we are writing to.
csvrow = 1; 

figure;
a1 = axes;
hold(a1, 'on');
axis(a1, [0 100 -500 500]);
box(a1, 'on');
grid(a1, 'on');

time = 0;

% Iterate through a sine wave for joint values
% The angle that we want is 30 degrees.
pidpacket(1) = 30*angconv;

totSamples = 200;
orangelineY = zeros( 1,100);
orangelineX = zeros( 1,100);


% x = 0:pi/10:2*pi;
t = 0:100;
y = -1*pidpacket(1)*heaviside(t);
plot(t,y);
drawnow;

tic 

% Send pidpacket to the server and get the response
returnpidpacket = pp.command(PIDID, pidpacket);

toc

for k=0:100
    
    returnstatuspacket = pp.command(STATUSID, pidpacket);
    % plot(a1,0,0,toc,pidpacket(1),100,pidpacket(1)); %, 'LineWidth',5);
    plot(t,returnstatuspacket(1));
    drawnow;
    % plot(a1,orangelineX, orangeLinY);
    pause(0.025);
end

% Clear up memory upon termination
pp.shutdown()
clear java;