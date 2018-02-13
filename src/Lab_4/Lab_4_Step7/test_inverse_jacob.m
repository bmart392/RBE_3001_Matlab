clc; close all; clear all;
a = jacobrad([0;0;0]); b = a(1:3,:); c = pinv(b);
% disp(" This is b: "); disp(b);
% disp(" This is c: "); disp(c);
y0 = forward_kinematics([0;0;0]);
disp(" This is y0(4,:): "); disp(y0(4,:));
% Creating the robot structure.
Robot.l1 = 0.135; Robot.l2 = 0.175; Robot.l3  = 0.16928;
forward_offset = y0(4,:);

disp(" final xyz location ");
finalForwardKinematics = forward_offset + [0.1 0 0.2];
disp(finalForwardKinematics);

deltaBeforeThresh = (180/pi).*(c*((finalForwardKinematics - ...
    forward_offset)'));
disp(" delta Q: "); disp(deltaBeforeThresh);