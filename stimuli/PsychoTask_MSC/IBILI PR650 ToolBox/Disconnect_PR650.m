function Disconnect_PR650 (port_obj)
%-------------------------------------------------------------------
% End the serial port session (Disconnect and clean up).
%
%*******************Glautech Project Team (JPAM)********************
%-------------------------------------------------------------------
fclose(port_obj)
delete(port_obj)
clear port_obj