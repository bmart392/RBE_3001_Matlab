%% Updates the 3D plot

function RobotPlotter(R, q1)

% solves for the beginning and end of every link
transformation_matrix = kinematics(q1);

disp(transformation_matrix);

% sets the Robot structure handle
set(R.handle, 'XData', [transformation_matrix(:,1)], 'YData', [transformation_matrix(:,2)], 'ZData', [transformation_matrix(:,3)]);

end