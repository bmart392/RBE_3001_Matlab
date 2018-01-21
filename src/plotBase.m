function [] = plotBase(time,pos)
%This function will take the base position value from the packet and plot
%it in a graph

% This is our figure object.
base = figure('Position Graph');

plot(time,pos);
drawnow;

% Now we want to create a plot of position of the waist over time.
% We will 0.05 second intervals over 5 seconds. This is 100 samples.

end

