function [Y,CCT,Dev,units] = Meas_LumCCT (port_obj, meas_numb)
%------------------------------------------------------------------
% Luminance and Correlated Color Temperature (Kelvins).
% Deviation of color coordinates from an ideal Planckian radiator  
% in 1960 CIE u-v units. (+ indicates the coordinates lie above 
% the Plankian locus.
% Measure Light Under Conditions defined by the 'S' command line.
%
%*******************Glautech Project Team (JPAM)*******************
%------------------------------------------------------------------

%(command M4 or D4, response code 4).
Y=zeros(1,meas_numb);
CCT=zeros(1,meas_numb);
Dev=zeros(1,meas_numb);
if meas_numb == 1
    fprintf(port_obj,'M4\n');
    [LumCCTroot] = fgetl(port_obj);
    LumCCT = regexp(LumCCTroot, ',', 'split');
    qq = LumCCT(1);
    U = LumCCT(2);
    Y(1) = str2double(LumCCT(3));
    CCT(1) = str2double(LumCCT(4));
    Dev(1) = str2double(LumCCT(5));
    PR650_QualityCode(qq);
elseif 1<meas_numb<=10 
    pause on
    for n = 1:meas_numb
        fprintf(port_obj,'M4\n');
        [LumCCTroot] = fgetl(port_obj);
        LumCCT = regexp(LumCCTroot, ',', 'split');
        qq = LumCCT(1);
        U = LumCCT(2);
        Y(n) = str2double(LumCCT(3));
        CCT(n) = str2double(LumCCT(4));
        Dev(n) = str2double(LumCCT(5));
        PR650_QualityCode(qq);
        pause(5)
    end
    pause off
else
    disp('Number of Measures Range from 0 to 10');
end
[units] = Read_Units(U,0,1);