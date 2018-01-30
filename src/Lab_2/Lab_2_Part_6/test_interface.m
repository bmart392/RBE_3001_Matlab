prompt = 'Do you want to set the encoder values? type "capture to set values';
    inputstr = input(prompt,'s');
    if isempty(inputstr)
    inputstr = 'n';
    end
if inputstr == "capture"
    disp(1);
end