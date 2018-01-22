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

var1 = 0;
                         
DEBUG   = true;          % enables/disables debug prints

% Instantiate a statuspacket- the following instruction allocates 64
% bytes for this purpose. Recall that the HID interface supports
% statuspacket sizes up to 64 bytes.
statuspacket= zeros(15, 1, 'single');
pidpacket= zeros(15, 1, 'single');

% The following code generates a sinusoidal trajectory to be
% executed on joint 1 of the arm and iteratively sends the list of
% setpoints to the Nucleo firmware. 

% The position matrix
viaPts = [0, -400, 400, -400, 400, 0];
% This is the element that we are reading to the arm
viaPts2 = [1];

% this is a giant matrix that stores the result of polling the status
% server.
giant = zeros(1,2);
% This is the row of the csv file we are writing to.
csvrow = 1; 
% have we sent the pidpacket?
sendpid = false;


figure;
a1 = axes;
hold(a1, 'on');
axis(a1, [0 100 -400 400]);
box(a1, 'on');
grid(a1, 'on');

time = 0;

% Iterate through a sine wave for joint values
% The angle that we want is 30 degrees.
pidpacket(1) = 30*angconv;
tic 
% Send pidpacket to the server and get the response
%returnpidpacket = pp.command(PIDID, pidpacket);

t = 0:100;
y = -1*pidpacket(1)*heaviside(t);
% plot(t,y);


%plot(a1,0,0,toc,pidpacket(1),100,pidpacket(1), 'LineWidth',5);
%drawnow;

for k=1:25
    toc
    returnstatuspacket = pp.command(STATUSID, statuspacket);
    time = toc;
    giant(k,1) = time;
    giant(k,2) = returnstatuspacket(1);
    
    plot(giant(:));
    drawnow;
    pause(0.01);

end

plot(giant(:));
drawnow;

% returnpidpacket = pp.command(PIDID, pidpacket);

csvwrite('waistreadactual.csv', giant);
disp(giant);

% Clear up memory upon termination
pp.shutdown()
clear java;