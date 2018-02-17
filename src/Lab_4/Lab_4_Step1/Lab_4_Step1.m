
% thetadots is a column vector of the joint angle velocities 1-3
function pdot = jacobian(thetadots)

L1 = 0.135;            % Meters
L2 = 0.175;            % Meters
L3 = 0.16928;          % Meters

theta1 = thetadots(1,1);
theta2 = thetadots(2,1);
theta3 = thetadots(3,1);

pdot = [ (-1*((sin(theta1))*L3*(cos(theta2+theta3))+L2*(sin(theta1))))      (-1*(cos(theta1))*L3*(sin(theta2 + theta3)))      (-1*(cos(theta1))*L3*(sin(theta2 + theta3)));

           ((cos(theta1))*L3*(cos(theta2+theta3))+L2*(cos(theta1)))         (-1*(sin(theta1))*L3*(sin(theta2 + theta3)))      (-1*(sin(theta1))*L3*(sin(theta2 + theta3)));

                                    0                                               (-1*L3*(cos(theta2 + theta3)))                    (-1*L3*(cos(theta2 + theta3)));

                                    0                                                             0                                                  0

                                    0                                                             0                                                  0

                                    1                                                             1                                                  1
            ];

end
