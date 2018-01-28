classdef RobotPlotter
    properties %(SetAccess = private)
        % The theta angles are passed in parameters that will be changing
        % when we want to update the plot.
        Theta1= 0;
        Theta2 = 0;
        Theta3 = 0;
        % Link Lengths in meters
        L1; % = 0.135;
        L2; % = 0.175;
        L3; % = 0.16928;
    end
    % properties (SetAccess = private, GetAccess = public)
        % Coordinates
    % end
    methods
        % This is the class constructor.
        % Make sure this is a column vector!!!
        function obj = RobotPlotter(lengths)
            obj.L1 = abs(lengths(1,1));
            obj.L2 = abs(lengths(2,1));
            obj.L3 = abs(lengths(3,1));
            disp('Created object Properly');
        end
        function setAngles(obj, q1) % Make sure this is a column vector!!!
            disp('Attempting to set Angles.');
            obj.Theta1 = q1(1,1);
            obj.Theta2 = q1(2,1);
            obj.Theta3 = q1(3,1);
            disp('Angles set properly.');
        end
        
        function T = plotArm3d(obj)

            % The alpha gets the z-axis aligned about the x
            % The theta gets the x-axis aligned about the z

            % parameter table

            %          d     theta     a    alpha
            %      ---------------------------------
            %  1   |   L1    theta1    0     pi/2
            %  2   |   0     theta2    L2      0
            %  3   |   0     theta3    L3      0

            % tdh(d, theta, a, alpha)

            % Create our transformation matrices
            % T0 = [0 0 0]'; % Create the vertical matrix.
            % d_h_params.tdh(0,0,0,0);
            % T1 = d_h_params.tdh(L1,(q(1,1)*pi/180),0,pi/2);
            % T1 = tdh(obj.L1,(obj.Theta1*pi/180),0,pi/2);
            disp("THeta")
            disp(obj.Theta1)
            T1 = tdh(obj.L1,pi/2,0,pi/2);
            T2 = tdh(0,(obj.Theta2*pi/180),obj.L2,0);
            T3 = tdh(0,(obj.Theta3*pi/180),obj.L3,0);

            % We redefine these 2 trasformations so that they start from the previous
            % transformation.
            T2 = T1*T2;
            T3 = T2*T3;

            % Now we extract the x, y, and z components of our links, and add them to a
            % matrix of coordinates.
            RobotArm = [0 0 0]';
            RobotArm = cat(2, RobotArm, T1(1:3,4));
            RobotArm = cat(2, RobotArm, T2(1:3,4));
            RobotArm = cat(2, RobotArm, T3(1:3,4));
            
            T = RobotArm;
            
            % The code below demonstrates how to display the robot.
            % DO NOT TOUCH!!!!!!!!!!!!!!!!! 
            % Now we get the x, y, and z coordinates and create an x and y and z column
            % vectors.
            % X1 = RobotArm(1,:)';
            % Y1 = RobotArm(2,:)';
            % Z1 = RobotArm(3,:)';

            % Our plotting code here
            % plot3(X1, Y1, Z1, 'LineWidth', 5);

            % T = T1*T2*T3;
        end     
    end
end