% This function initializes several commonly used variables
% INPUTS:   none
% OUTPUTS:  none
function init_vars_coms()

global pp;                  % create the packetprocessor variable
pp = PacketProcessor(7);    % initialize the value

global PID_ID;              % create the PID_ID constant
PID_ID = 37;                % initialize the value

global STATUS_ID;           % create the STATUS_ID constant
STATUS_ID = 42;             % initialize the value

global statuspacket;        % create the statuspacket
statuspacket = zeros(15,... % fill the packet with variables
    1,'single');

global pidpacket;           % create the pidpacket
pidpacket = zeros(15,1,...  % fill the packet with variables
    'single');

global angconv;             % create the angconv constant
angconv = 11.44;            % initialize the value

end

