%% Updates the 3D plot

% This robot plotter is different in that we are using the new
% forward_kinematics method for lab 4 pat 7.
% q1 is still a column vector.
function RobotPlotter2(R, q1)

% solves for the beginning and end of every link
transformation_matrix = forward_kinematics_rad(q1);

%disp(transformation_matrix);

% sets the Robot structure handle
set(R.handle, 'XData', [transformation_matrix(:,1)], 'YData', [transformation_matrix(:,2)], 'ZData', [transformation_matrix(:,3)]);

end