%live plot

javaaddpath('../lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

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

%packet(1,1) =1;

figure;
a1 = axes;
hold(a1, 'on');
title('Position vs. Time')
xlabel('Time in Seconds')
ylabel('Position')

tic

for n = 0:25
   % Send packet to the server and get the response
    returnPacket = pp.command(SERV_ID, packet);
    %disp(returnPacket);
    time = toc;
    basepos = returnPacket(1);
    posmatrix(i,1) = time;
    posmatrix(i,2) = basepos;
    plot(time,basepos,'-o',...
    'LineWidth',5,...
    'MarkerSize',10,'MarkerEdgeColor','b', 'MarkerFaceColor',[0.5,0.5,0.5]);
    drawnow;
    i = i +1;
    pause(0.5);
end

csvwrite('baseplot.csv', posmatrix);

% Clear up memory upon termination
pp.shutdown()
clear java;
