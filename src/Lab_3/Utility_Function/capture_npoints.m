function points = capture_npoints(STATUSID, statuspacket, pp, numreadings)
readings = zeros(numreadings,1);
points = zeros(numreadings,3);

YES = 1;            % Set constant for determining answer of user input
NO = 0;             % Set constant for determining answer of user input
EXIT = 2;           % Set constant for determining answer of user input

inputstr = NO;

for i = 1:numreadings
    while inputstr == NO
        returnstatuspacket = pp.command(STATUSID, statuspacket);
        readings(1) = returnstatuspacket(1);
        readings(2) = returnstatuspacket(4);
        readings(3) = returnstatuspacket(7);
        prompt = 'J0 = ' + readings(1) + newline + ...
            'J1 = ' + readings(2) + newline + ...
            'J2 = ' + readings(3) + newline +...
            'Do you want to set the 1st position value here?';
        inputstr = dialog_box_truefalse(prompt,"");
        
        if inputstr == EXIT
            break
        end
        
    end
    
    if inputstr == EXIT
        points = 999;
        break
    end
    
    points(i,:) = readings;
end
