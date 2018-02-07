%INVERSEKINEMATICS_GENERAL This function will take 3xn matrix of xyz
% coordinates and give the corresponding joint angles
% INPUT: a 3xn matrix where each column is a set of xyz coordinates
% 
% OUTPUT: a 3xn matrix where each column is a set of joint angles in
%           degrees

function angles_degrees = inversekinematics_general(coordinates)

% Find the number of rows and columns in the input matrix
size_coordinates = size(coordinates);

if(size_coordinates(1) == 0 || size_coordinates(2) == 0)
    error('The array passed in has a size of zero in one or both dimension');
end

% Create a matrix to hold the answer from inverse_kinematicskinematics
angles_degrees = zeros(3,size_coordinates(2));



FIRSTCOLUMN = 1;    % Create a constant to pull from the first column of 
                        % the matrix returned by inversekinematics

% The outer loop (the i loop) loops through every column of the input 
%   matrix which converts the joint angles to xyz and places them in the 
%   return matrix   
% The inner loop (the j loop) loops through the three rows of the xyz 
%   matrix and places them in the return matrix
for i = 1:size_coordinates(2)
    angles_group = inverse_kinematics(coordinates(:,i));
    for j = 1:3
        angles_degrees(j,i) = angles_group(j,FIRSTCOLUMN); 
    end
end
end

