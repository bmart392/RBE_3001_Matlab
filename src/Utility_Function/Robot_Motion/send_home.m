% This funciton automatically sends the robot to the home position
% INPUTS:   PID_ID = the global variable declaring the PID ID
%           pidpacket = the global variable assigned to the pidpacket
% 
% OUTPUTS:  none
function returnpidpacket = send_home(PID_ID, pidpacket,pp)
% Assign the pidpacket zerro values
pidpacket(1) = 0;
pidpacket(4) = 0;
pidpacket(7) = 0;

% Send the pidpacket
returnpidpacket = pp.command(PID_ID, pidpacket);
end

