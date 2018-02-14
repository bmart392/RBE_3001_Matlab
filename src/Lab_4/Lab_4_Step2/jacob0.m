%% Step 2: function to calculate the jacobian
% INPUT: column vector q (3,1) of joint angles in radians
% OUTPUT: jacobian matrix (6x3)

function j = jacob0(q)

L1 = 0.135;            % Meters
L2 = 0.175;            % Meters
L3 = 0.16928;          % Meters

theta1 = q(1,1);
theta2 = q(2,1);
theta3 = q(3,1);

T1 = tdh(L1, theta1 , 0, pi/2);
T2 = tdh(0, theta2, L2, 0);
T3 = tdh(0, theta3-pi/2, L3, 0);

T01 = T1;
T02 = T1 * T2;
T03 = T1 * T2 * T3;

% end effector position
pe(1,1) = T03(1,4);
pe(2,1) = T03(2,4);
pe(3,1) = T03(3,4);

jacobian = zeros(3,3);
jacobian(:,1) = cross([0;0;1],pe);
jacobian(:,2) = cross(T01(1:3,3),(pe-T01(1:3,4)));
jacobian(:,3) = cross(T02(1:3,3),(pe-T02(1:3,4)));

j = jacobian;
end