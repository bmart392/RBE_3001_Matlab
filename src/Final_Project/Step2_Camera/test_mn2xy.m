function [ outarr ] = test_mn2xy( m, n , tot_width_in_cm, tot_height_in_cm )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

camera_calibration;

[ R,t ] = extrinsics(imagePoints(:,:,1),worldPoints(:,:,1),cameraParams);

outarr = pointsToWorld(cameraParams,R,t,[m,n]);

outarr = (outarr + [ 225 25 ])./ 1000;

outarr(2) = outarr(2)*(-1);

end

