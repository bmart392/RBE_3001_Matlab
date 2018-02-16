%COLLECT_N_SAMPLES This function collects the requested number of position
%   samples from the robot by using status packets and notes the time. 
%   The time is always returned as the first row
%   The default mode for this function is to return just the position
%   INPUT:  version = determine which data to capture
%                       (postion,velocity,troque)
%           numsamples = the number of samples to collect
%           STATUS_ID = the ID number of the status server
%           pp = an initialized packet server object
%           statuspacket = the packet used for sending statuses
%
%   OUTPUT: samples = a 10 x n array of samples where a column
%                       holds all of the data collected for a 
%                       given point in time
%   Output of this is in radians
function samples = collect_n_samples(version,numsamples, STATUS_ID, pp,statuspacket )

angconv = ((360/4096)*(pi/180)); % degrees per tick * radians per degree

% Create the array to hold the values sampled from the robot
samples = zeros(10,numsamples);

% All of the following collect time
POS = 1; % Sample only position
VEL = 2; % Sample only velocity
TOR = 3; % Sample only torque
POSVEL = 4; % Sample position and velocity
POSTOR = 5; % Sample position and torque
POSVELTOR = 6; % Sample position, velocity, and torque

% The following do not collect time
POS_NOTIME = 7; % Sample only position
VEL_NOTIME = 8; % Sample only velocity
TOR_NOTIME = 9; % Sample only torque
POSVEL_NOTIME = 10; % Sample position and velocity
POSTOR_NOTIME = 11; % Sample position and torque
POSVELTOR_NOTIME = 12; % Sample position, velocity, and torque

switch version
    case POS
        % Take numsamples number of position samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
        end
        samples = cat(1,samples(1,:),(samples(2:4,:) .* angconv));
        
    case VEL
        % Take numsamples number of velocity samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint velocities and
            % put them in the columns of samples
            for j = 1:3
                samples(j+4,i) = returnstatuspacket((3*j)-1);
            end
        end
        samples = cat(1,samples(1,:),(samples(6:8,:) .* angconv));
        
    case TOR
        % Take numsamples number of torque samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint torques and
            % put them in the columns of samples
            for j = 1:3
                samples(j+7,i) = returnstatuspacket((3*j));
            end
        end
        samples = cat(1,samples(1,:),samples(8:10,:));
        
    case POSVEL
        % Take numsamples number of position and velocity samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
            % Iterate through the returnstatuspacket to find the joint velocities and
            % put them in the columns of samples
            for j = 1:3
                samples(j+4,i) = returnstatuspacket((3*j)-1);
            end
            
        end
        samples = cat(1,samples(1,:),(samples(2:4,:) .* angconv),...
            (samples(6:8,:) .* angconv));
        
    case POSTOR
        % Take numsamples number of position and torque samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
            
            % Iterate through the returnstatuspacket to find the joint torques and
            % put them in the columns of samples
            for j = 1:3
                samples(j+7,i) = returnstatuspacket((3*j));
            end
        end
        
        samples = cat(1,samples(1,:),samples(8:10,:));
        
    case POSVELTOR
        % Take numsamples number of position, velocity, and torque samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
            
            % Iterate through the returnstatuspacket to find the joint velocities and
            % put them in the columns of samples
            for j = 1:3
                samples(j+4,i) = returnstatuspacket((3*j)-1);
            end
            
            % Iterate through the returnstatuspacket to find the joint torques and
            % put them in the columns of samples
            for j = 1:3
                samples(j+7,i) = returnstatuspacket((3*j));
            end
            
        end
        samples = cat(1,samples(1,:),(samples(2:4,:) .* angconv),...
            (samples(6:8,:) .* angconv),samples(8:10,:));
        
        case POS_NOTIME
        % Take numsamples number of position samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j,i) = returnstatuspacket((3*j)-2);
            end
        end
        samples = (samples(1:3,:) .* angconv);
        
        case VEL_NOTIME
        % Take numsamples number of velocity samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
                        
            % Iterate through the returnstatuspacket to find the joint velocities and
            % put them in the columns of samples
            for j = 1:3
                samples(j+3,i) = returnstatuspacket((3*j)-1);
            end
        end
        samples = (samples(4:6) .* angconv);
        
    case TOR_NOTIME
        % Take numsamples number of torque samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Iterate through the returnstatuspacket to find the joint torques and
            % put them in the columns of samples
            for j = 1:3
                samples(j,i) = returnstatuspacket((3*j));
            end
        end
        samples = samples(1:3,:);
        
    case POSVEL_NOTIME
        % Take numsamples number of position and velocity samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
            % Iterate through the returnstatuspacket to find the joint velocities and
            % put them in the columns of samples
            for j = 1:3
                samples(j+4,i) = returnstatuspacket((3*j)-1);
            end
            
        end
        samples = cat(1,samples(1,:),(samples(2:4,:) .* angconv),...
            (samples(6:8,:) .* angconv));
        
    case POSTOR_NOTIME
        % Take numsamples number of position and torque samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
            
            % Iterate through the returnstatuspacket to find the joint torques and
            % put them in the columns of samples
            for j = 1:3
                samples(j+7,i) = returnstatuspacket((3*j));
            end
        end
        
        samples = cat(1,samples(1,:),samples(8:10,:));
        
    case POSVELTOR_NOTIME
        % Take numsamples number of position, velocity, and torque samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
            
            % Iterate through the returnstatuspacket to find the joint velocities and
            % put them in the columns of samples
            for j = 1:3
                samples(j+4,i) = returnstatuspacket((3*j)-1);
            end
            
            % Iterate through the returnstatuspacket to find the joint torques and
            % put them in the columns of samples
            for j = 1:3
                samples(j+7,i) = returnstatuspacket((3*j));
            end
            
        end
        samples = cat(1,samples(1,:),(samples(2:4,:) .* angconv),...
            (samples(6:8,:) .* angconv),samples(8:10,:));
        
    otherwise
        % Take numsamples number of position samples
        % and store them in the return matrix
        for i = 1:numsamples
            % read the status packet
            returnstatuspacket = pp.command(STATUS_ID, statuspacket);
            
            % Collect the time each sample was taken
            samples(1,i) = toc;
            
            % Iterate through the returnstatuspacket to find the joint angles and
            % put them in the columns of samples
            for j = 1:3
                samples(j+1,i) = returnstatuspacket((3*j)-2);
            end
        end
        samples = cat(1,samples(1,:),(samples(2:4,:) .* angconv));
end

