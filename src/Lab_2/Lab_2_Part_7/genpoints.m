% Generate a point based on the coefficients and time inputed
% INPUTS: a 4 x 1 matrix representing the coefficients of the equation
%           and a time the function should be evaluated at
% OUTPUT: a 1 x 1 matrix representing the location at the given time
function point = genpoints(coefficients,time)
%GENPOINTS Summary of this function goes here
%   Detailed explanation goes here
point = (coefficients(1) + coefficients(2)*time + ... 
    coefficients(3)*time^2 + coefficients(4)*time^3);
%disp(point);
end

