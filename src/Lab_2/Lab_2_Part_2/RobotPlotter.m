%% Updates the 3D plot

function RobotPlotter(R, q1)

% solves for the beginning and end of every link
y = kinematics(q1);

% sets the Robot structure handle
set(R.handle, 'XData', [y(:,1)], 'YData', [y(:,2)], 'ZData', [y(:,3)]);

end