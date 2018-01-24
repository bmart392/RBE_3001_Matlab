%live plot

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

% 11.44 ticks per degree
angconv = 11.44;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); % !FIXME why is the deviceID == 7?
STATUSID = 42;           % we will be talking to server ID 42 on the Nucleo
PIDID = 37;              % This server controls the robot

                      
DEBUG   = true;          % enables/disables debug prints

% Instantiate a statuspacket- the following instruction allocates 64
% bytes for this purpose. Recall that the HID interface supports
% statuspacket sizes up to 64 bytes.
statuspacket= zeros(15, 1, 'single');
pidpacket= zeros(15, 1, 'single');

% Iterate through a sine wave for joint values
% The angle that we want is 60 degrees.
pidpacket(1) = 60*angconv;
 
% Send pidpacket to the server and get the response
returnpidpacket = pp.command(PIDID, pidpacket);

pause(3);

% Iterate through a sine wave for joint values
% The angle that we want is 60 degrees.
pidpacket(1) = -60*angconv;

% the array to hold position readings
readarray = [1,52];
veritcalarray = [52,1];

dlmwrite('dosAngles.csv',0);

% Send pidpacket to the server and get the response
returnpidpacket = pp.command(PIDID, pidpacket);

for k=1:50
    returnstatuspacket = pp.command(STATUSID, statuspacket);
    readarray(k) = returnstatuspacket(1); 
end

for l=1:50
verticalarray(l,1) = readarray(1,l);
end
dlmwrite('dosAngles.csv',verticalarray);

figure;
a1 = axes;
hold(a1, 'on');
axis(a1, [-10 60 -750 500]);
box(a1, 'on');
grid(a1, 'on'); 

plot(readarray);
drawnow;

pidpacket(1) = 0;
returnpidpacket = pp.command(PIDID, pidpacket);



% Clear up memory upon termination
pp.shutdown()
clear java;