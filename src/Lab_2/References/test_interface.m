function points = capturepoints()
readings = zeros(3,1);
desiredpos = zeros(3,3);
prompt = 'Do you want to set the encoder values? type capture to set values  or n to skip: ';
inputstr = input(prompt,'s');
disp(inputstr);
if isempty(inputstr)
inputstr = 'n';
end

if inputstr == 'capture'

    inputstr = 'n';

while inputstr == 'n'
    returnstatuspacket = pp.command(STATUSID, statuspacket);
    readings(1,1) = returnstatuspacket(1);
    readings(2,1) = returnstatuspacket(4);
    readings(3,1) = returnstatuspacket(7);
    prompt = 'Do you want to set the 1st encoder value here? y/n';
    disp(readings);
    inputstr = input(prompt,'s');
    if isempty(inputstr)
        inputstr = 'n';
    end
end

desiredpos(:,1) = readings;

 inputstr = 'n';
 
while inputstr == 'n'
    returnstatuspacket = pp.command(STATUSID, statuspacket);
    readings(1,1) = returnstatuspacket(1);
    readings(2,1) = returnstatuspacket(4);
    readings(3,1) = returnstatuspacket(7);
    prompt = 'Do you want to set the 2st encoder value here? y/n';
    disp(readings);
    inputstr = input(prompt,'s');
    if isempty(inputstr)
        inputstr = 'n';
    end
end

desiredpos(:,2) = readings;

 inputstr = 'n';

while inputstr == 'n'
    returnstatuspacket = pp.command(STATUSID, statuspacket);
    readings(1,1) = returnstatuspacket(1);
    readings(2,1) = returnstatuspacket(4);
    readings(3,1) = returnstatuspacket(7);
    prompt = 'Do you want to set the 3rd encoder value here? y/n';
    disp(readings);
    inputstr = input(prompt,'s');
    if isempty(inputstr)
        inputstr = 'n';
    end
end

desiredpos(:,3) = readings;
points = desiredpos;

end
end