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

        % This half above is the linear velocity angle contributions
j = [ (L3*sin(theta1)*sin(theta1+theta2))-(L2*sin(theta1)*cos(theta2))    ((-1)*L3*cos(theta1)*cos(theta2+theta3))-(L2*cos(theta1)*sin(theta1))    (-1*(cos(theta1))*L3*(sin(theta2 + theta3)));

      (L2*cos(theta1)*cos(theta2))-(L3*cos(theta1)*sin(theta2+theta3))    (-1*L2*sin(theta1)*sin(theta2))-(L3*sin(theta1)*cos(theta2+theta3))      (L3*sin(theta2+theta3))-(L2*cos(theta2));

      (-1*L3*cos(theta1)*cos(theta2+theta3))                              ((-1)*L3*sin(theta1)*cos(theta2+theta3))                                  L3*sin(theta2+theta3);
        % This half below is the rotational velocity angle ontributions
       0                                                                  (-1)*sin(theta1)                                                         (-1)*sin(theta1);

       0                                                                  cos(theta1)                                                              cos(theta1);

       1                                                                  0                                                                        0];
        
        
        %% professor's answer
        % j11 = (L3*s1*s12)-(L2*s1*c2)
        % j12 = (-1*L3*c1*c23)-(L2*c1*s1)
        % j13 = -1*L3*c1*c23
        % j21 = (L2*c1*c2)-(L3*c1*s23)
        % j22 = (-1*L2*s1*s2)-(L3*s1*c23)
        % j23 = -1*L3*s1*c23
        % j31 = 0
        % j32 = (L3*s23)-(L2*c2)
        % j33 = L3*s23
 
 end