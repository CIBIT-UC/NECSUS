function [ModelNumber] = ModelNumber (port_obj)
%----------------------------------------------------
% Get the Model Number of the instrument in use.
% Response Code 111.
%
%*********Glautech Project Team (JPAM)***************
%----------------------------------------------------
fprintf(port_obj,'D111\n');
[ModelNumber] = fgetl(port_obj);
end 