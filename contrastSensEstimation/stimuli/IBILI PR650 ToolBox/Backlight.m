function [Response101] = Backlight (port_obj, level)
%------------------------------------------------------------------
% Changes the LCD iluminacion level on PR-650. 
%
%*******************Glautech Project Team (JPAM)*******************
%------------------------------------------------------------------

%(command M5 or D5, response code 5).
if level==0
    fprintf(port_obj,'B0\n');
    [Response101] = fgetl(port_obj);
elseif level==1
    fprintf(port_obj,'B1\n');
    [Response101] = fgetl(port_obj);
elseif level==2
    fprintf(port_obj,'B2\n');
    [Response101] = fgetl(port_obj);
else
    fprintf(port_obj,'B3\n');
    [Response101] = fgetl(port_obj);
end