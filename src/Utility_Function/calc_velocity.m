function velocities = calc_velocity( samples )
%CALC_VELOCITY Summary of this function goes here
%   Detailed explanation goes here

num_dimensions = size(samples,1);

num_points = size(samples,2);


displacement = zeros(num_dimensions,1);

total_time = samples(1,num_points)-samples(1,1);

for w = 2:num_dimensions
    displacement(w,1) = samples(w,num_points) - samples(w,1);
end

velocities = displacement(2:num_dimensions,1) ./ total_time;

