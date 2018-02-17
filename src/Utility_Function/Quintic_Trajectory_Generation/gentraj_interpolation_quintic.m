% Interpolate a series of point between two given points and the associated
% time, velocity, and acceleration characteristics of the given end points
% INPUTS:   t0 = the start time at position 1;
%           tf = the end time at position 2;
%           q0 = the value of position 1;
%           q1 = the value of position 2;
%           v0 = the velocity at position 1;
%           vf = the velocity at position 2;
%           a0 = the accelereation at position 1;
%           af = the acceleration at position 2
%           numpoints = the number of steps interpolated
%           addendpoint = a boolean value determining if an endpoint 
%                           should be added
% OUTPUT: a 1 X n matrix holding the trajectory of between the given points
function points = gentraj_interpolation_quintic(t0, tf, q0, qf, v0, ...
    vf, a0, af, numpoints, addendpoint)

% Adjust the numpoints to create numpoints after the starting point.
total_steps = numpoints+1;

% Initialize a matrix to hold the points produced
points = zeros(1, total_steps);

% Create the time step and fill an array with that time step
time = 0:(tf/(total_steps)):tf;

% Calculate the coefficients of the quintic polynomial equation
coeffs = gencoeff_quintic(t0, tf, q0, qf, v0, vf, a0, af);

% Calculate the position at every time value except the last value and
% then fill the points array with those values
for n = 1:total_steps
    points(1,n) = genpoints_quintic(coeffs,time(n));
end

if(addendpoint == 1)
    % Increment the n index to calculate the endpoint
    n = n+1;
    
    % Calculate the end point and enter it in the matrix
    points(1,n) = genpoints_quintic(coeffs,time(n));
end
end

