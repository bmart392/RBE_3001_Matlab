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
% OUTPUT: a 1 x 1 matrix representing the location at the given time
function points = gentraj_interpolation_quintic(t0, tf, q0, qf, v0, ...
    vf, a0, af, numpoints)

% Initialize a matrix to hold the points produced
points = zeros(numpoints, 1);

% Create the time step and fill an array with that time step
time = 0:(tf/(numpoints-1)):tf;

% Calculate the coefficients of the quintic polynomial equation
coeffs = gencoeff(t0, tf, q0, qf, v0, vf, a0, af);

% Calculate the position at every time value except the last value and
% then fill the points array with those values
for n = 1:numpoints
    points(n,1) = genpoints(coeffs,time(n));
end

end

