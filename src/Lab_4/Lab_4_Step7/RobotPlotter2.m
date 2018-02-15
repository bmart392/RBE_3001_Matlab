%% Updates the 3D plot

% This robot plotter is different we use the new forward
% q1 is still a column vector.
function RobotPlotter2(R, q1)
% solves for the beginning and end of every link
transformation_matrix = forward_kinematics_rad(q1);

% sets the Robot structure handle
set(R.handle, 'XData', transformation_matrix(:,1), ...
    'YData', transformation_matrix(:,2), ...
    'ZData', transformation_matrix(:,3));

end