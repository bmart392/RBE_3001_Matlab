% Function displays a dialog box that allows the user to input data into
% the script
% INPUTS:   question = a character array of the message the user should see
%           title = a character array of the title of the dialog box
%           option1 = option that appears on the left most button
%           option2 = option that appears on the center button
%           option3 = option that appears on the right most button
% OUTPUT:   a number representing the choice of the user
%           NOTE: the number returned will correspond to the order of the
%           options
function input = dialog_box_3option(question,title,option1,...
    option2,option3)
% Construct a questdlg with three options
choice = questdlg(question, title,option1,option2,option3,option3);

% Handle response
switch choice
    case option1
        input = 1;
    case option2
        input = 2;
    case option3
        input = 0;
    otherwise
        input = 0;
        
end
end
