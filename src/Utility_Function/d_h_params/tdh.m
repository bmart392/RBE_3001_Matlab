% We are assuming that the angles are already in radians.
function T = tdh(d, theta, a, alpha)
    % Multiply all of the matrices together.
    T = ((trotz(theta)*translate(0, 0, d))*translate(a, 0, 0))*trotx(alpha);
end