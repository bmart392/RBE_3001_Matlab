%% Automated_sorting.m
% This is the final script for the sorting process of the final project
% Last Edit: 2/22/17 - Ben - Added Some Intializations

clear java;

javaaddpath('../RBE3001_Matlab_Team_C18_01/lib/hid4java-0.5.1.jar');

import org.hid4java.*;
import org.hid4java.event.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.lang.*;

clc; clear all; close all;

% -------------- Communication Initialization -----------------

% Set up communication with the arm
STATUS_ID = 42;
TORQUE_ID = 25;
PID_ID = 37;
pp = PacketProcessor(7);
pidpacket = zeros(15,'single');
statuspacket = zeros(15,'single');
torquepacket = zeros(15,'single');

% --------------- Positions to place each Type of Object -------------

blue_heavy_storage_position = [ 1; 1; 1];
blue_light_storage_position = [ 1; 1; 1];

green_heavy_storage_position = [ 1; 1; 1];
green_light_storage_position = [ 1; 1; 1];

yellow_heavy_storage_position = [ 1; 1; 1];
yellow_light_storage_position = [ 1; 1; 1];

% -------------- Image Processing Initializations -------------------

% FILL THIS SPACE WITH ANY REQUIRED INITIALIZATIONS, DELETE IF UNNECESSARY

% 

% Clear up memory upon termination
pp.shutdown()
clear java;