classdef Robot
    properties
        waistangle;
        elbowangle;
        wristangle;
        
        l1length;
        l2length;
        l3length;
        
        transmat;
      
    end
    methods
        
        function initlinks(obj,length1,length2,length3)
            obj.l1length = length1;
            obj.l2length = length2;
            obj.l3length = length3;
        
        end
        
        function setangles(obj,angle1,angle2,angle3)
            obj.waistangle = angle1;
            obj.elbowangle = angle2;
            obj.wristangle = angle3;
        end
        
        function calctransmat(obj)
            
            
        end
        
    end
    
end

        