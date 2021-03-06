%% Step 2: function to calculate the jacobian
 % INPUT: column vector q (3,1) of joint angles in RADIANS
 % OUTPUT: jacobian matrix (6x3)
 
function j = jacobrad2(q)
 
L1 = 0.135;            % Meters
L2 = 0.175;            % Meters
L3 = 0.16928;          % Meters

theta1 = q(1,1);
theta2 = q(2,1);
theta3 = q(3,1);

% j11 = (L3*s1*s23)-(L2*s1*c2)        
J11 = (L3*sin(theta1)*sin(theta2+theta3))-(L2*sin(theta1)*cos(theta2));
% j12 = (-1*L3*c1*c23)-(L2*c1*s2)
J12 = ((-1)*L3*cos(theta1)*cos(theta2+theta3))-(L2*cos(theta1)*sin(theta2));
% j13 = -1*L3*c1*c23
J13 = ((-1)*(cos(theta1))*L3*(cos(theta2 + theta3)));

% j21 = (L2*c1*c2)-(L3*c1*s23)
J21 = (L2*cos(theta1)*cos(theta2))-(L3*cos(theta1)*sin(theta2+theta3));
% j22 = (-1*L2*s1*s2)-(L3*s1*c23)
J22 = ((-1)*L2*sin(theta1)*sin(theta2))-(L3*sin(theta1)*cos(theta2+theta3));
% j23 = -1*L3*s1*c23
J23 = ((-1)*L3*sin(theta1)*cos(theta2+theta3));

% j31 = 0
J31 = 0; %(-1*L3*cos(theta1)*cos(theta2+theta3));
% j32 = (L3*s23)-(L2*c2)
J32 = (L3*sin(theta2+theta3))-(L2*cos(theta2));
% j33 = L3*s23
J33 = L3*sin(theta2+theta3);

        % This half above is the linear velocity angle contributions
j = [ J11 J12 J13 ;

      J21 J22 J23 ;      

      J31 J32 J33 ;                         
        % This half below is the rotational velocity angle ontributions
       0   (-1)*sin(theta1)   (-1)*sin(theta1);

       0    cos(theta1)       cos(theta1);

       1      0                   0];
        
 end