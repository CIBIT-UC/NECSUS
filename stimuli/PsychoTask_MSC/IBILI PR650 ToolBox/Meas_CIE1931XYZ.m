function [X,Y,Z,units] = Meas_CIE1931XYZ (port_obj, meas_numb)
%------------------------------------------------------------------
% Measures 1931 CIE X, Y, and Z.
% Measure Light Under Conditions defined by the 'S' command line.
%
%*******************Glautech Project Team (JPAM)*******************
%------------------------------------------------------------------

%(command M2 or D2, response code 2).
X=zeros(1,meas_numb);
Y=zeros(1,meas_numb);
Z=zeros(1,meas_numb);
if meas_numb == 1
    fprintf(port_obj,'M2\n');
    [CIEXYZroot] = fgetl(port_obj);
    CIEXYZ = regexp(CIEXYZroot, ',', 'split');
    qq = CIEXYZ(1);
    U = CIEXYZ(2);
    X(1) = str2double(CIEXYZ(3));
    Y(1) = str2double(CIEXYZ(4));
    Z(1) = str2double(CIEXYZ(5));
    PR650_QualityCode(qq);
elseif 1<meas_numb<=10
    pause on
    for n = 1:meas_numb
        fprintf(port_obj,'M2\n');
        [CIEXYZroot] = fgetl(port_obj);
        CIEXYZ = regexp(CIEXYZroot, ',', 'split');
        qq = CIEXYZ(1);
        U = CIEXYZ(2);
        X(n) = str2double(CIEXYZ(3));
        Y(n) = str2double(CIEXYZ(4));
        Z(n) = str2double(CIEXYZ(5));
        PR650_QualityCode(qq);
        pause(5);
    end
    pause off
else
    disp('Number of Measures Range from 0 to 10');
end
[units] = Read_Units(U,0,1); 
