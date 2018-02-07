function points = interpolation( start_point, end_point, num_steps)
% Function interpolates between two points given the number of steps
% start_point and end_point are column vectors with x,y,z end effector
% locations
% num_steps is the number of evenly spaced steps from start_point to
% end_point
%   returns a set of points

for i = 1:3
    points(i,:) = linspace(start_point(i,1),end_point(i,1)...
        ,num_steps+2);
end

end

