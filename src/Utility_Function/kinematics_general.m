%KINEMATICS_GENERAL This function will take 3xn matrix of joint angles
%and give the corresponding xyz coordinate
% INPUT: a 3xn matrix where each column is a set of joint angles
% OUTPUT: a 3xn matrix where each column is a set of of xyz coordinates

function coordinates = kinematics_general(angles)

% Find the number of rows and columns in the input matrix
size_angles = size(angles);

if(size_angles(1) == 0 || size_angles(2) == 0)
    error('The array passed in has a size of zero in one or both dimension');
end

% Create a matrix to hold the answer from kinematics
coordinates = zeros(3,size_angles(2));

% Convert the input angles from degrees to encoder ticks
angconv = 11.4; % ticks per degree
anglesinticks = angles(:,:).*angconv;    

LASTROW = 4;    % Create a constant to pull from the last row of .
                % the matrix returned by kinematics

% The outer loop (the i loop) loops through every column of the input 
%   matrix which converts the joint angles to xyz and places them in the 
%   return matrix   
% The inner loop (the j loop) loops through the three rows of the xyz 
%   matrix and places them in the return matrix
for i = 1:size_angles(2)
    xyz_group = kinematics(anglesinticks(:,i));
    for j = 1:3
        coordinates(j,i) = xyz_group(LASTROW,j); 
    end
end
end

