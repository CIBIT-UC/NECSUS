%--------------------------------------------------------------------
% This M-File connects the PC with the PR-650 using the serial port 
% communication protocol RS-232.
%
% This M-File creates a serial port object called PR650. IBILI PR650 
% toolbox functions must have this port object in their input. 
%
% Example: 
% function Read_Data(port_obj)
% Substitute "port_obj" for PR650
%
%*******************Glautech Project Team (JPAM)*********************
%--------------------------------------------------------------------

% Close all serial ports open and clears the workspace. 
if isempty(instrfind)==0
    fclose(instrfind);
end

%------------------------------------------------------------
% Create a SERIAL port object. (Assuming COM1)
%------------------------------------------------------------
PR650 = serial('COM1');

%------------------------------------------------------------
% Properties References PR650.
%------------------------------------------------------------
% Communications Properties:
PR650.BaudRate = 9600;
PR650.DataBits = 8;
PR650.Parity = 'none';
PR650.StopBits = 1;
PR650.Terminator = 'CR/LF';
% Write Properties:
PR650.OutputBufferSize = 512;
PR650.Timeout = 60;
% Read Properties:
PR650.InputBufferSize = 512;
PR650.ReadAsyncMode = 'continuous';
% Callback Properties: (Possibly Avaiable in Future Releases)
% Control Pin Properties:
PR650.FlowControl = 'none';
% Recording Properties:
PR650.RecordDetail = 'verbose';
PR650.RecordMode = 'overwrite';
PR650.RecordName = 'C:\Documents and Settings\jpmeneses\My Documents\MATLAB\Record_COM.txt';
% General Purpose Properties:
pause on;

%------------------------------------------------------------
% Connecting to the port RS-232.
%------------------------------------------------------------
fopen(PR650);

%------------------------------------------------------------
% Connection and Set-Up Measurement Parameters.
%------------------------------------------------------------
% Remote Mode Startup (Manual PR650).
% Set the RTS line high.
PR650.RequestToSend = 'on';
pause(1);
% Set the RTS line low. This causes the PR650 to reset.
PR650.RequestToSend = 'off';
pause(1);
% Set the RTS line high.
PR650.RequestToSend = 'on';
pause(1);
% Send a command within 5 seconds to start communicating with the PR650.
% Command Structure S [Format+1st acc,2nd acc,3rd acc,4th acc,nom sync,integration time,avg cnt,units type+Terminator].
% Set-Up Parameters (Manual PR650).
fprintf(PR650,'S1,,,,,0,1,1\n');
% Response Code 201 [pp<CR>]
[pproot,count] = fgetl(PR650);
pp = str2double(pproot);
if count ~= 0
    if isempty(pp) || pp == 0 || isnan(pp)
        disp('All okay! Ready to start measurement.');
    elseif 1<=pp && pp<=8
        disp(['Parameter ',int2str(pp),' in S command is invalid.']);
    else 
        disp('No Primary accessory specified, or more than one Primary Accessory was specified or the first accessory is not a Primary Accessory');
    end
else
    disp('Connection Failed!')
end
clear pproot pp count