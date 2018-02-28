% This function determines what values to use in the mn2xy function to
% appropriately find objects in world coordinates
%   INPUT:  m = the column in which the centroid of the object is found
%           n = the row in which the centroid is found
%
%   OUTPUT: outarr = a 1 x 2 array holding the [ x , y ] coordinates

function [ outarr ] = choose_mn2xy( m , n )

%   This diagram represents zones on the board. Each interface value is in
%       camera pixels in the n dimension;
%
%   The Robot_Interface is at the robot.
%   The Camera_Interface is at the camera.
%
%   +-------Robot-------+   Robot_Interface
%   |                   |
%   |    Zone 0         |
%   |    W = 27; H = 8  |
%   |                   |
%   +------- 290 -------+   Interface_A
%   |                   |
%   |    Zone 5         |
%   |    W = 21; H = 2  |
%   |                   |
%   +------- 325 -------+   Interface_E
%   |                   |
%   |     Zone 10       |
%   | W = 25; H = -18   |
%   |                   |
%   +------- 350 -------+   Interface_I
%   |                   |
%   |      Zone 15      |
%   |   W = 21; H = 55  |
%   |                   |
%   +------- 360 -------+   Interface_K
%   |                   |
%   |      Zone 17      |
%   |   W = 21; H = 35  |
%   |                   |
%   +------- 372 -------+   Interface_M
%   |                   |
%   |       Zone 20     |
%   |   W = 17; H = 18  |
%   |                   |
%   +------- 390 -------+   Interface_Q
%   |                   |
%   |      Zone 25      |
%   |   W = 17; H = 14  |
%   |                   |
%   +------- 410 -------+   Interface_U
%   |                   |
%   |     Zone 30       |
%   |   W = 17; H =11   |
%   |                   |
%   +---- Camera -------+ Interface_Camera


% Set the values for Zone 0
Zone_0_total_width = 27;
Zone_0_total_height = 8;

% Set the pixel value for Interface_A
Interface_A = 290;

% Set the values for Zone 5
Zone_5_total_width = 21;
Zone_5_total_height = 2;

% Set the pixel value for Interface_E
Interface_E = 325;

% Set the values for Zone 10
Zone_10_total_width = 25;
Zone_10_total_height = -18;

% Set the pixel value for Interface_I
Interface_I = 350;

% Set the values for Zone 15
Zone_15_total_width = 21;
Zone_15_total_height = 55;

% Set the pixel value for Interface_K
Interface_K = 360;

% Set the values for Zone 17
Zone_17_total_width = 21;
Zone_17_total_height = 35;

% Set the pixel value for Interface_M
Interface_M = 372;

% Set the values for Zone 20
Zone_20_total_width = 17;
Zone_20_total_height = 18;

% Set the pixel value for Interface_Q
Interface_Q = 390;

% Set the values for Zone 25
Zone_25_total_width = 17;
Zone_25_total_height = 14;

% Set the pixel value for Interface_U
Interface_U = 410;

% Set the values for Zone 30
Zone_30_total_width = 17;
Zone_30_total_height = 11;

% Check if the object is in Zone 0
if n < Interface_A
    
    outarr = mn2xy( m, n, Zone_0_total_width, Zone_0_total_height);
    
    
    % Check if the object is in Zone 5
elseif (Interface_A <= n && n < Interface_E)
    
    outarr = mn2xy( m, n, Zone_5_total_width, Zone_5_total_height);
    
    
    % Check if the object is in Zone 10
elseif (Interface_E <= n && n < Interface_I)
    
    outarr = mn2xy( m, n, Zone_10_total_width, Zone_10_total_height);
    
    
    % Check if the object is in Zone 15
elseif (Interface_I <= n && n < Interface_K)
    
    outarr = mn2xy( m, n, Zone_15_total_width, Zone_15_total_height);
    
    
    % Check if the object is in Zone 17
elseif (Interface_K <= n && n < Interface_M)
    
    outarr = mn2xy( m, n, Zone_17_total_width, Zone_17_total_height);
    
    
    % Check if the object is in Zone 20
elseif (Interface_M <= n && n < Interface_Q)
    
    outarr = mn2xy( m, n, Zone_20_total_width, Zone_20_total_height);
    
    
    % Check if the object is in Zone 25
elseif (Interface_Q <= n && n < Interface_U)
    
    outarr = mn2xy( m, n, Zone_25_total_width, Zone_25_total_height);
    
    
    % Check if the object is in Zone 30
elseif n >= Interface_U
    
    outarr = mn2xy( m, n, Zone_30_total_width, Zone_30_total_height);
    
end

end

