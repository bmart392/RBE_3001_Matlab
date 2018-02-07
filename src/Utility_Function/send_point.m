% This funciton automatically sends the robot to the given position
% INPUTS:   PID_ID = the global variable declaring the PID ID
%           pidpacket = the global variable assigned to the pidpacket
%           position = a 3 x 1 column matrix holding the desired joint
%           angles
% 
% OUTPUTS:  none
function returnpidpacket = send_point(PID_ID, pidpacket,point)
% Assign the pidpacket the joint angles
pidpacket(1) = point(1);
pidpacket(4) = point(2);
pidpacket(7) = point(3);

% Send the pidpacket
returnpidpacket = pp.command(PID_ID, pidpacket);
end

