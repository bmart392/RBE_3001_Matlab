function angle_path = inversekinematics_path_quintic( point_path )
% INVERSEKINEMATICS_PATH Converts a path of x,y,z coordinates to a path of
% joint angles
% INPUTS: a 3xn matrix holding the path in xyz coordinates
% OUTPUTS:  a 3xn matrix holding the path in joint angles
%   Detailed explanation goes here
for i =1:10
   angle_path(:,i) = inverse_kinematics(point_path(:,i)); 
end

end

