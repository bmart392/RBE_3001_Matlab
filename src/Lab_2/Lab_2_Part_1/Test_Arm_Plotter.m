
clear all; close all; clc

% Our test vector for joint angles, input in degrees.
vect1 = [ -30 50 -20 ]';

matrix1 = plotArm3(vect1);

disp(matrix1);