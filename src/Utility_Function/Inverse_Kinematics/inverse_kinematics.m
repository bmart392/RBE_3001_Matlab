%% calculate the inverse kinematics given the x, y, and z end effector coordinates

% The input is a column vector.
function T = inverse_kinematics(endeffectlocation)

l1 = 0.135;   % The straight up link.
l2 = 0.175;   % The shoulder link.
l3 = 0.16928; % The elbow link.


degreesToRadians = pi/180;    % Radians to degrees conversion

x = endeffectlocation(1,1);
y = endeffectlocation(2,1);
z = endeffectlocation(3,1);

% These are the physical angular limits of the arm. 
% These all need to be tested manually.
theta1max = 85*degreesToRadians;    
theta1min = -85*degreesToRadians;    

theta2max = 95*degreesToRadians;  % The should be all the way up
theta2min = -10*degreesToRadians; % This is the lowest the shoulder can go. 
                 % This needs to be tested further.

theta3max = 80*degreesToRadians;  
theta3min = -80*degreesToRadians;  

%% Calculations and Error testing 

% 1024 ticks is the upper limit  - this may need to be checked later again
% -1024 ticks is the lower limit

% Check to see if the location is even possible to be reached in
% terms of x,y,z location. WE ARE IGNORING ROTATION FOR NOW.
toohigh = (l1 + l2 + l3) < z;             % Vertical height
toolow = z < -0.05;                       % Vertical low
toobig = (l2 + 13) < ((x^2) + (y^2))^.5;  % Flat circle parallel to the
                                          % ground is too big for the 
                                          %non-vertical links to reach.

% Check if either of the 3 conditions are met
if (toobig==true || toohigh==true || toolow==true)
   error('Point is outside the workspace. ');
end

% Find theta1, the waist angle.
theta1 = atan2(-y, x);

if (~(isreal(theta1)))
   error('Imaginary theta1 angle');
end

% 1. Assume that link 1 does not effect the z. This means that we
% can subtract l1 from z and do all the calculations as a 2-link arm

endloc = [x y (z - l1)]';

% This is the magnitude of the wanted location vector.
magend = ((endloc(1,1)^2) + (endloc(2,1)^2) + (endloc(3,1)^2))^(0.5);

% Next, calculate the angle of the upper link against the horizontal
% created by the first link. We are calling that angle theta3.

theta3 = (pi/2)-acos(-(clamp(((l2^2) + (l3^2) - (magend^2)) / ...
    (2 * l2 * l3), -1, 1)));

% Check for imaginary angles
if (~(isreal(theta3)))
   error('Imaginary theta3 angle.');
end

% Elbow down
% Now we solve for alpha, the angle from the horizontal to link 2.
alpha = atan2( endloc(3,1), ((endloc(1,1)^2 + endloc(2,1)^2)^(0.5)) );

% Solve for beta.
beta = asin(clamp(((l2^2) + (magend^2) - (l3^2))...
    / (2 * l2 * magend), -1, 1));

% Theta2 as elbow down.
theta2 = alpha - beta + (pi/2);

if (~(isreal(theta2)))
   error('Imaginary theta2 angle.');
end

% Final error checking to see if the angles are out of bounds.
if (theta1 < theta1min || theta1 > theta1max)
    error('The Waist angle (Theta 1) is out of range.');
end

if (theta2 < theta2min || theta2 > theta2max)
    error('The Shoulder angle (Theta 2) is out of range.');
end

if (theta3 < theta3min || theta3 > theta3max)
    error('The Elbow angle (Theta 3) is out of range.');
end

% Return radians in a column vector.
T =  ([theta1 (theta2) theta3]');

end