function [Batt_Stat] = Battery_Status (port_obj)
%----------------------------------------------------
% It reports the Main Battery and ICM Card Low 
% Battery status. 
% Response Code 115.
%
%***********Glautech Project Team (JPAM)*************
%----------------------------------------------------
fprintf(port_obj,'D115\n');
[Batt_Stat] = fgetl(port_obj);
end 