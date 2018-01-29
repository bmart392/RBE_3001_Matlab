function points = gentraj_interpolation(t0, tf, v0, vf, q0, qf, numpoints)

points = zeros(numpoints + 1, 1);
time = 0:(tf/numpoints):tf;
%disp(time);

    for n = 1:numpoints

        coeffs = gencoeff(t0, tf, v0, vf, q0, qf);

        points(n,1) = genpoints(coeffs,time(n));
        %disp(points);
    end
    points(numpoints+1,1) = genpoints(coeffs,tf);
     
    
end

