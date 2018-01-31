
% This function solves for the coefficients of a cubic polynomial that
% describes the trajectory of a joint.
%
% INPUTS : start time, end time, start velocity, end velocity,
% start angle, end angle
%
% OUTPUTS : a 4 x 1 column matrix with a0 through a3
function coefficients = gencoeff_quintic(t0, tf, q0, qf, v0, vf, a0, af)

coefficients = [
    1    t0   t0^2   t0^3     t0^4      t0^5;
    0    1    2*t0   3*t0^2   4*t0^3    5*t0^4;
    0    0    2      6*t0     12*t0^2   20*t0^3;
    1    tf   tf^2   tf^3     tf^4      tf^5;
    0    1    2*tf   3*tf^2   4*tf^3    5*tf^4;
    0    0    2      6*tf     12*tf^2   20*tf^3; ...
    ] \ [ q0; v0; a0; qf; vf; af;];
end

