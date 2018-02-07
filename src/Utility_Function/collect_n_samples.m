%COLLECT_N_SAMPLES This function collects the requested number of position
%   samples from the robot by using status packets
%   INPUT:  numsamples = the number of samples to collect
%           STATUS_ID = the ID number of the status server
%           pp = an initialized packet server object
%   
%   OUTPUT: samples = a 3 x n array of samples where a cooumn is a point
function samples = collect_n_samples( numsamples, STATUS_ID, pp )

% Create the array to hold the values sampled from the robot
samples = zeros(3,numsamples);

% Take numsamples number of position samples
% and store them in the return matrix
for i = 1:numsamples
    % read position
    returnstatuspacket = pp.command(STATUS_ID, statuspacket);
    
    % Iterate through the returnstatuspacket to find the joint angles and
    % put them in the columns of samples
    for j = 1:3
        samples(j,i) = returnstatuspacket((3*j)-2);
    end
end
end

