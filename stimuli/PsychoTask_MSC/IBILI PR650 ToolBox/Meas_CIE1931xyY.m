function [x,y,Y,units] = Meas_CIE1931xyY (port_obj, meas_numb)
%------------------------------------------------------------------
% Measures Luminance and 1931 CIE x and y.
% Measure Light Under Conditions defined by the 'S' command line.
% port_obj = Serial Port Object
% meas_numb = Number of Consecutive Measures 1 to 10. 
%
% Ex:
% to make 2 consecutive measures,
%
% >>Connect_PR650;
% >>[x,y,Y,units] = Meas_CIE1931xyY (PR650,2);
% >>Disconnect_PR650(PR650);
%
%*******************Glautech Project Team (JPAM)*******************
%------------------------------------------------------------------

%Luminance and 1931 CIE x and y (command M1 or D1, response code 1).
x=zeros(1,meas_numb);
y=zeros(1,meas_numb);
Y=zeros(1,meas_numb);
if meas_numb == 1
    fprintf(port_obj,'M1\n');
    [CIExyYroot] = fgetl(port_obj);
    CIExyY = regexp(CIExyYroot, ',', 'split');
    qq = CIExyY(1);
    U = CIExyY(2);
    Y(1) = str2double(CIExyY(3));
    x(1) = str2double(CIExyY(4));
    y(1) = str2double(CIExyY(5));
    PR650_QualityCode(qq);
elseif 1<meas_numb<=10
    pause on
    for n = 1:meas_numb
        fprintf(port_obj,'M1\n');
        [CIExyYroot] = fgetl(port_obj);
        CIExyY = regexp(CIExyYroot, ',', 'split');
        qq = CIExyY(1);
        U = CIExyY(2);
        Y(n) = str2double(CIExyY(3));
        x(n) = str2double(CIExyY(4));
        y(n) = str2double(CIExyY(5));
        PR650_QualityCode(qq);
        pause(5);
    end    
    pause off
else
    disp('Number of Measures Range from 0 to 10');
end
[units] = Read_Units(U,0,1); 