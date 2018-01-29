function RobotPlotter(R, q1) %T = RobotPlotter(R, q1)
    
y = kinematics(q1);

set(R.handle, 'XData', [y(:,1)], 'YData', [y(:,2)], 'ZData', [y(:,3)]); 
    
end