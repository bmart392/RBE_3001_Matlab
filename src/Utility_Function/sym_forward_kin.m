clc;

syms theta1 theta2 theta3 L2 L3 L1 alpha1 b c d;

%alpha1 = pi/2;
alpha2 = 0;
alpha3 = 0;
d2 = 0;
d3 = 0;
a1 = 0;

jointangles = [theta1; theta2; theta3];

%vertices = forward_kinematics_rad(jointangles);

T01 = [cos(theta1) -1*sin(theta1)*cos(alpha1) sin(theta1)*sin(alpha1) a1*cos(theta1);
    sin(theta1) cos(theta1)*cos(alpha1) -1*cos(theta1)*sin(alpha1) a1*sin(theta1);
    0           sin(alpha1)                cos(alpha1)             L1;
    0           0                          0                       1];


T12 = [cos(theta2) -1*sin(theta2)*cos(alpha2) sin(theta2)*sin(alpha2) L2*cos(theta2);
    sin(theta2) cos(theta2)*cos(alpha2) -1*cos(theta2)*sin(alpha2) L2*sin(theta2);
    0           sin(alpha2)                cos(alpha2)             d2;
    0           0                          0                       1];

T23 = [cos(theta3) -1*sin(theta3)*cos(alpha3) sin(theta3)*sin(alpha3) L3*cos(theta3);
    sin(theta3) cos(theta3)*cos(alpha3) -1*cos(theta3)*sin(alpha3) L3*sin(theta3);
    0           sin(alpha3)                cos(alpha3)             d3;
    0           0                          0                       1];

% disp('T01');
% disp(T01);
% 
% T02 = T01*T12;
% disp('T02');
% disp(T02);
% 
% T03 = T02*T23;
% disp('T03');
% disp(T03);

% px = T03(1,4);
% py = T03(2,4);
% pz = T03(3,4);

T01s = [cos(theta1) 0  sin(theta1)    0;
        sin(theta1) 0  -1*cos(theta1) 0;
        0           1  0              L1;
        0           0  0              1];


T12s = [cos(theta2) -1*sin(theta2) 0   L2*cos(theta2);
        sin(theta2) cos(theta2)    0   L2*sin(theta2);
        0           0              1   0;
        0           0              0   1];

T23s = [cos(theta3) -1*sin(theta3) 0    L3*cos(theta3);
        sin(theta3) cos(theta3)    0    L3*sin(theta3);
        0           0              1    0;
        0           0              0    1];
    
disp('T01s');
disp(T01s);

T02s = T01s*T12s;
disp('T02s');
disp(T02s);

T03s = T02s*T23s;
disp('T03s');
disp(T03s);

px = T03s(1,4);
py = T03s(2,4);
pz = T03s(3,4);

pe(1,1) = px;
pe(2,1) = py;
pe(3,1) = pz;
disp('pe');
disp(pe);

jacobian = zeros(3,3);
jacobian(:,1) = cross([0;0;1],pe);
jacobian(:,2) = cross(T01s(1:3,3),(pe-T01s(1:3,4)));
jacobian(:,3) = cross(T02s(1:3,3),(pe-T02s(1:3,4)));
disp('jacobian');
disp(jacobian);


