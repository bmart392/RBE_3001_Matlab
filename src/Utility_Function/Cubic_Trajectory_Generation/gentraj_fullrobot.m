function trajectory = gentraj_fullrobot(linkcoeff1,linkcoeff2,...
    linkcoeff3,numsteps)
%GENTRAJ_FULLROBOT Summary of this function goes here
%   Detailed explanation goes here

trajectory(:,1) = gentraj_interpolation(linkcoeff1(1), linkcoeff1(2),...
    linkcoeff1(3), linkcoeff1(4),linkcoeff1(5), linkcoeff1(6), numsteps);

trajectory(:,2) = gentraj_interpolation(linkcoeff2(1), linkcoeff2(2),...
    linkcoeff2(3), linkcoeff2(4),linkcoeff2(5), linkcoeff2(6), numsteps);

trajectory(:,3) = gentraj_interpolation(linkcoeff3(1), linkcoeff3(2),...
    linkcoeff3(3), linkcoeff3(4),linkcoeff3(5), linkcoeff3(6), numsteps);


end

