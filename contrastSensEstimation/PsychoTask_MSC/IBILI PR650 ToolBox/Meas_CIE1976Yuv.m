function [Y,u,v,units] = Meas_CIE1976Yuv (port_obj, meas_numb)
%------------------------------------------------------------------
% Luminance and 1976 CIE u' and v'.
% Measure Light Under Conditions defined by the 'S' command line.
%
%*******************Glautech Project Team (JPAM)*******************
%------------------------------------------------------------------

%(command M3 or D3, response code 3).
Y=zeros(1,meas_numb);
u=zeros(1,meas_numb);
v=zeros(1,meas_numb);
if meas_numb == 1
    fprintf(port_obj,'M3\n');
    [CIEYuvroot] = fgetl(port_obj);
    CIEYuv = regexp(CIEYuvroot, ',', 'split');
    qq = CIEYuv(1);
    U = CIEYuv(2);
    Y(1) = str2double(CIEYuv(3));
    u(1) = str2double(CIEYuv(4));
    v(1) = str2double(CIEYuv(5));
    PR650_QualityCode(qq);
elseif 1<meas_numb<=10
    pause on
    for n = 1:meas_numb
        fprintf(port_obj,'M3\n');
        [CIEYuvroot] = fgetl(port_obj);
        CIEYuv = regexp(CIEYuvroot, ',', 'split');
        qq = CIEYuv(1);
        U = CIEYuv(2);
        Y(n) = str2double(CIEYuv(3));
        u(n) = str2double(CIEYuv(4));
        v(n) = str2double(CIEYuv(5));
        PR650_QualityCode(qq);
        pause(5);
    end
    pause off
else
    disp('Number of Measures Range from 0 to 10');
end
[units] = Read_Units(U,0,1);
