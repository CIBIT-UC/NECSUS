function Set_Up(port_obj, intg_time, avg_cnt, units_type)  
%-------------------------------------------------------------------
% Set-Up parameters
% intg_time = Integration Time in milliseconds. 
% Allowable values:
% 0, use adaptative integration time.
% 10-6000 milliseconds.
%
% avg_cnt = Number of measurements to average.
% Default = 01
% Allowable values: 01-99
%
% units_type = Specifies CIE Y values.
% Allowable values:
% 0 - English,
% 1 - metric SI,
%-------------------------------------------------------------------

cmd = ['S1,,,,,'];

if 0<=intg_time<=6000 
   cmd = [cmd num2str(intg_time) ','];
else
    disp('intg_time value not allowed');
end

if 1<=avg_cnt<=99 
   cmd = [cmd num2str(avg_cnt) ','];
else
    disp('avg_cnt value not allowed');
end

if units_type == 0 
   cmd = [cmd num2str(units_type) '\n'];
elseif units_type == 1
   cmd = [cmd num2str(units_type) '\n'];
else
    disp('units_type value not allowed');
end

fprintf(port_obj, cmd);
[pproot,count] = fgetl(port_obj);
pp = str2double(pproot);
if count ~= 0
    if pp == 0 || isnan(pp)
        disp('All okay! Ready to start measurement.');
    elseif 1<=pp && pp<=8
        disp(['Parameter ',int2str(pp),' in S command is invalid.']);
    else 
        disp('No Primary accessory specified, or more than one Primary Accessory was specified or the first accessory is not a Primary Accessory');
    end
else
    disp('Connection Failed!')
end
clear pproot pp count cmd 