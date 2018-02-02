% Function displays a dialog box that allows the user to input data into
% the script
% INPUTS:   question = a character array of the message the user should see
%           title = a character array of the title of the dialog box
% OUTPUT:   a boolean representing the choice of the user
%           NOTE: Both the "No" and "Cancel" option both return logic false
function input = dialog_box_truefalse(question,title)
% Construct a questdlg with three options
choice = questdlg(question, title);

% Handle response
switch choice
    case 'Yes'
        input = 1;
    case 'No'
        input = 0;
    case 'Cancel'
        input = 0;
end
end
