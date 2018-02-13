clc; close all; clear all;
a = jacob0([0;0;0]); b = a(1:3,:); c = pinv(b);
disp(" This is b: "); disp(b);
disp(" This is c: "); disp(c);
y0 = forward_kinematics([0;0;0]);
disp(" This is y0: "); disp(y0);
% Creating the robot structure.
Robot.l1 = 0.135; Robot.l2 = 0.175; Robot.l3  = 0.16928;

disp(" wiuerioeuwhnf ");
disp(y0(4,:)+[0.1 0 0.05]);
finalForwardKinematics = y0(4,:)+[0.1 0 0.05];
forward_offset = forward_kinematics([0;0;0]);
currentForwardKinematics = forward_offset(4,:);

disp((finalForwardKinematics - forward_offset(1:3,:)));

deltaBeforeThresh = b*(finalForwardKinematics - forward_offset(1:3,:))';
disp(" delta Q: "); disp(deltaBeforeThresh);