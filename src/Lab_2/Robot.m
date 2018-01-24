classdef Robot
    properties
        waistangle;
        elbowangle;
        wristangle;
        
        l1length;
        l2length;
        l3length;
        
        % these positions represent the eposition of the end of the link
        % farthest away from the base when the arm is fully extended
        positionl1;
        positionl2;
        positionl3; % also the position of the end effector
    end
    methods
        
        function initlinks(obj,length1,length2,length3)
            obj.l1length = length1;
            obj.l2length = length2;
            obj.l3length = length3;
        
        end
        
        function calcendpos(angle0,angle1,angle2 
        end
        
    end
    
end

        