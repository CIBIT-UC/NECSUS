function [Int_time, Op_temp] = Intime_Temp (port_obj)
%----------------------------------------------------
% Integration Time and Operating Temperature during 
% the last measurement.
% Response Code 130.
% 
%**********Glautech Project Team (JPAM)**************
%----------------------------------------------------
fprintf(port_obj,'D130\n');
[dataroot] = fgetl(port_obj);
data = regexp(dataroot, ',', 'split');
Int_time = data(1);
Op_temp = data(2);
end 