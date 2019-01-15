function [SerialNumber] = SerialNumber (port_obj)
%----------------------------------------------------
% Get Serial Number of the PR-650.
% Response Code 110
%
%***********Glautech Project Team (JPAM)*************
%----------------------------------------------------
fprintf(port_obj,'D110\n');
[SerialNumber] = fgetl(port_obj);
end 