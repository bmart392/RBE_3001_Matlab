% Function displays a dialog box that allows the user to input data into
% the script
% INPUTS:   question = a character array of the message the user should
%                       respond to
%           title = a character array of the title of the dialog box
%           isnumber = a boolean value describing if the answer will be a
%                       number
% OUTPUT:   input = If the input is a string > returns a 1x1 array holding
%                       a charater array of the answer
%                   If the input is a number > returns the number inputted
function input = dialog_box_variable(question,title,isnumber)
% Construct a questdlg with three options
input = inputdlg(question, title);

if isnumber
    input = str2double(input);
end

end
