
function radang = angtodeg(encoderticks)
encodertodegreeconversion = 11.44;
degradconv = pi/180;

radang = encoderticks * encodertodegreeconversion * degradconv;
end
