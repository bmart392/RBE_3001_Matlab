%live plot

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

% 11.44 ticks per degree
CONST = 11.44;

% Create a PacketProcessor object to send data to the nucleo firmware
pp = PacketProcessor(7); % !FIXME why is the deviceID == 7?
SERV_ID = 42;            % we will be talking to server ID 37 on
                         % the Nucleo
                         
DEBUG   = true;          % enables/disables debug prints

% Instantiate a packet - the following instruction allocates 64
% bytes for this purpose. Recall that the HID interface supports
% packet sizes up to 64 bytes.
packet = zeros(15, 1, 'single');
viaPts4 = [1, 2, 3, 4, 5];

basepos = 0;
posmatrix = [1,2];  % matrix to hold base position and time
i = 1;   %row of matrix

armlength = 10;

%packet(1,1) =1;

figure;

angleread = 1;

tic

for n = 0:25
   % Send packet to the server and get the response
    returnPacket = pp.command(SERV_ID, packet);
    %disp(returnPacket);
    time = toc;
    basepos = returnPacket(1);
    posmatrix(i,1) = time;
    posmatrix(i,2) = basepos;
    disp(posmatrix(i,2));
    angleread = (basepos / CONST)*pi/180;
    disp(angleread);
    % plot(0,0);
    % plot([0,2*cos(angleread)], [0,2*sin(angleread)]);
    % plot(time,basepos,'-o','LineWidth',5,'MarkerSize',10,'MarkerEdgeColor','b',
    % 'MarkerFaceColor',[0.5,0.5,0.5]);
    % axis(a1,'equal'); axis(a1, 2*1.2*[-1 1 -1 1]); box(a1, 'on'); grid(a1, 'on');
    polarplot([angleread, 0], [armlength, 0], 'LineWidth',5);
    drawnow;
    i = i + 1;
    pause(0.5);
end

csvwrite('baseplot.csv', posmatrix);

% Clear up memory upon termination
pp.shutdown()
clear java;
