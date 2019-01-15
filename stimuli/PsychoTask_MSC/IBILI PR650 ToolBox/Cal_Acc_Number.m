function [nn] = Cal_Acc_Number (port_obj)
%----------------------------------------------------
% Get the Number of  Calibrated Accessories for this 
% instrument.
% Response Code 112.
%
%**********Glautech Project Team (JPAM)**************
%----------------------------------------------------
fprintf(port_obj,'D112\n');
[nn] = fgetl(port_obj);
end 