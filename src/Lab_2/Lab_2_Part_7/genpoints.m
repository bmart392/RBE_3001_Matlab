function point = genpoints(coefficients,time)
%GENPOINTS Summary of this function goes here
%   Detailed explanation goes here
point = coefficients(1) + coefficients(2)*time + ... 
    coefficients(3)*time^2 + coefficients(4)*time^3;
end

