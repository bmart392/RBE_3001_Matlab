
% This function solves for the coefficients of a cubic polynomial that
% describes the trajectory of a joint.
%
% INPUTS : start time, end time, start velocity, end velocity,
% start angle, end angle
%
% OUTPUTS : a 4 x 1 column matrix with a0 through a3
function coefficients = gencoeff_cubic(t0, tf, q0, qf, v0, vf)

coefficients = [
    1 t0 t0^2 t0^3;
    0 1 2*t0 3 * t0^2;
    1 tf tf^2 tf^3;
    0 1 2*tf 3*tf^2;] \ [ q0; v0; qf; vf; ];
end

