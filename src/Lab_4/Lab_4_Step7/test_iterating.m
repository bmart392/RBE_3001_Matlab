clc; clear all; close all;
% y0 is the initial condition.
y0 = forward_kinematics([0; 0; 0]);

% Start pos angles
q0 = zeros(3,1);

% iterating/current angles
qi = zeros(3,1);

qi_xyz = zeros(3,1);

threshold = [0.01; 0.00; 0.01];


% Now this read in position is the wanted end effector position.
wantedEndEffectorPosition = [0.1; 0; 0.1]; % pd;

case1 = abs((wantedEndEffectorPosition(1)-qi_xyz(1))) >= threshold(1);
case3 = abs((wantedEndEffectorPosition(3)-qi_xyz(3))) >= threshold(3);

%disp((abs((wantedEndEffectorPosition-qi_xyz)) >= threshold));
while (case1 || case3)
    qi = inverse_kin_jacobs2(wantedEndEffectorPosition, ...
        q0, qi, [case1; 0; case3]);    
    % Make sure to add the difference back in.
    %qi = qi + deltaq(:,1);
    qi_xyz = kinematics_general(qi);
    
    disp('qi_xyz');
    disp(qi_xyz);
    
    case1 = abs((wantedEndEffectorPosition(1)-qi_xyz(1))) >= threshold(1);
    case3 = abs((wantedEndEffectorPosition(3)-qi_xyz(3))) >= threshold(3);
    disp('case1');
    disp(case1);
    disp('case3');
    disp(case3);
    pause(0.5);
end