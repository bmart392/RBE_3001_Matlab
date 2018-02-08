function points = gentraj_twopoint(t0, tf, v0, vf, q0, qf)
%GENTRAJ_TWOPOINT Summary of this function goes here
%   Detailed explanation goes here
coeffs = gencoeff(t0, tf, v0, vf, q0, qf);

points(1,:) = genpoints(coeffs,t0);
points(2,:) = genpoints(coeffs,tf);



end

