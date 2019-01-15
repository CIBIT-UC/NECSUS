function [PRsoft_Version] = Soft_Version (port_obj)
%----------------------------------------------------
% Get the Version of the PR-650 software.
% Response Code 114.
%
%***********Glautech Project Team (JPAM)*************
%----------------------------------------------------
fprintf(port_obj,'D114\n');
[PRsoft_Version] = fgetl(port_obj);
end 