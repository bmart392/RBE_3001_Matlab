function [ outarr ] = choose_mn2xy( m , n )
%CHOOSE_MN2XY Summary of this function goes here
%   Detailed explanation goes here

disp('m');
disp(m);
disp('n');
disp(n);

zone_robot_middle_interface = 325;
zone_middle_camera_interface = 400;

zone_robot_middle_total_width = 19;
zone_robot_middle_total_height = 2;

zone_middle_total_width = 15;
zone_middle_total_height = 15;

zone_middle_camera_total_width = 17;
zone_middle_camera_total_height = 12;

if n < zone_robot_middle_interface
    
    outarr = mn2xy( m, n, zone_robot_middle_total_width, ...
        zone_robot_middle_total_height);
    
elseif (zone_robot_middle_interface <= n && ...
        n < zone_middle_camera_interface)
    
    outarr = mn2xy( m, n, zone_middle_total_width, ...
        zone_middle_total_height);

elseif n >= zone_middle_camera_interface
    
    outarr = mn2xy( m, n, zone_middle_camera_total_width, ...
        zone_middle_camera_total_height);

end

end

