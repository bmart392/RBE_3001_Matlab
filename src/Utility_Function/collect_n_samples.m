%COLLECT_N_SAMPLES This function collects the requested number of position
%   samples from the robot by using status packets and notes the time
%   INPUT:  numsamples = the number of samples to collect
%           STATUS_ID = the ID number of the status server
%           pp = an initialized packet server object
%           statuspacket = the packet used for sending statuses
%   
%   OUTPUT: samples = a 4 x n array of samples where a column 
%                       is a point in degrees and the first row is time
%                       
function samples = collect_n_samples( numsamples, STATUS_ID, pp,statuspacket )

angconv = 11.44; % ticks per degree
% Create the array to hold the values sampled from the robot
samples = zeros(4,numsamples);

% Take numsamples number of position samples
% and store them in the return matrix
for i = 1:numsamples
    % read position
    returnstatuspacket = pp.command(STATUS_ID, statuspacket);
    
    % Collect the time each sample was taken
    samples(1,i) = toc;
    
    % Iterate through the returnstatuspacket to find the joint angles and
    % put them in the columns of samples
    for j = 1:3
        samples(j+1,i) = returnstatuspacket((3*j)-2);
    end
end
samples = cat(1,samples(1,:),(samples(2:4,:) ./ angconv));
end

