%% Step 2: function to calculate the jacobian
 % INPUT: column vector q (3,1) of joint angles in DEGREES
 % OUTPUT: jacobian matrix (6x3)
 
function j = jacob0(q)
 
L1 = 0.135;            % Meters
L2 = 0.175;            % Meters
L3 = 0.16928;          % Meters

degreesToRadians = pi/180;

theta1 = q(1,1)*degreesToRadians;
theta2 = q(2,1)*degreesToRadians;
theta3 = q(3,1)*degreesToRadians;

j = [ (-1*((sin(theta1))*L3*(cos(theta2+theta3))+L2*(sin(theta1))))      (-1*(cos(theta1))*L3*(sin(theta2 + theta3)))      (-1*(cos(theta1))*L3*(sin(theta2 + theta3)));

           ((cos(theta1))*L3*(cos(theta2+theta3))+L2*(cos(theta1)))         (-1*(sin(theta1))*L3*(sin(theta2 + theta3)))      (-1*(sin(theta1))*L3*(sin(theta2 + theta3)));

                                    0                                               (-1*L3*(cos(theta2 + theta3)))                    (-1*L3*(cos(theta2 + theta3)));

                                    0                                                             0                                                  0

                                    0                                                             0                                                  0

                                    1                                                             1                                                  1
            ];
 
 end