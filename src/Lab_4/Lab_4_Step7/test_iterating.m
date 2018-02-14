clc; clear all; close all;
% Start pos angles
q0 = zeros(3,1);

% iterating/current angles
qi = zeros(3,1);
% The iterator.
qi_xyz = zeros(3,1);

threshold = [0.0001; 0; 0.0001];

% Now this read in position is the wanted end effector position.
wantedEndEffectorPosition = [0.1; 0; 0.1]; % pd;

case1 = (wantedEndEffectorPosition(1)-qi_xyz(1)) >= threshold(1) ...
    || (wantedEndEffectorPosition(1)-qi_xyz(1)) <= -threshold(1);
case3 = (wantedEndEffectorPosition(3)-qi_xyz(3)) >= threshold(3) ...
    || (wantedEndEffectorPosition(3)-qi_xyz(3)) <= -threshold(3);

%disp((abs((wantedEndEffectorPosition-qi_xyz)) >= threshold));
while (case1 || case3)
    qi = inverse_kin_jacobs2(wantedEndEffectorPosition, ...
        q0, qi, [case1; 0; case3]);
    % Make sure to add the difference back in.
    %qi = qi + deltaq(:,1);
    temp1 =  forward_kinematics_rad(qi);
    qi_xyz = temp1(4,:)';
    
    %disp('qi_xyz magnitude: ');
    %disp((((qi_xyz(1,1) - 0.2) ^2) + ...
     %   (qi_xyz(2,1)^2) + ((qi_xyz(3,1)- 0.2)^2) )^.5 );
    
    case1 = (wantedEndEffectorPosition(1)-qi_xyz(1)) >= threshold(1) ...
        || (wantedEndEffectorPosition(1)-qi_xyz(1)) <= -threshold(1);
    case3 = (wantedEndEffectorPosition(3)-qi_xyz(3)) >= threshold(3) ...
        || (wantedEndEffectorPosition(3)-qi_xyz(3)) <= -threshold(3);
    
    disp('case1');
    disp(case1);
    disp('case3');
    disp(case3); 
    
end
% q0 = qi;