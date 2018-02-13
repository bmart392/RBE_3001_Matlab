%% Step 2: function to calculate the jacobian
 % INPUT: column vector q (3,1) of joint angles in RADIANS
 % OUTPUT: jacobian matrix (6x3)
 
function j = jacobrad(q)
 
L1 = 0.135;            % Meters
L2 = 0.175;            % Meters
L3 = 0.16928;          % Meters

theta1 = q(1,1);
theta2 = q(2,1);
theta3 = q(3,1);

        % This half above is the linear velocity angle contributions
j = [ (-1*((sin(theta1))*L3*(cos(theta2+theta3))+L2*(sin(theta1))))      (-1*(cos(theta1))*L3*(sin(theta2 + theta3)))      (-1*(cos(theta1))*L3*(sin(theta2 + theta3)));

           ((cos(theta1))*L3*(cos(theta2+theta3))+L2*(cos(theta1)))      (-1*(sin(theta1))*L3*(sin(theta2 + theta3)))      (-1*(sin(theta1))*L3*(sin(theta2 + theta3)));

                                    0                                           (-1*L3*(cos(theta2 + theta3)))                    (-1*L3*(cos(theta2 + theta3)));
        % This half below is the rotational velocity angle ontributions
                                    0                                                    -sin(theta1)                                     -sin(theta1);

                                    0                                                     cos(theta1)                                      cos(theta1);

                                    1                                                         0                                                  0
            ];
 
 end