function [Y,x,y,u,v,units] = Meas_1931xy1976uv (port_obj)
%------------------------------------------------------------------
% Luminance, 1931 CIE x and y and 1976 CIE u'v'.
% Measure Light Under Conditions defined by the 'S' command line.
%------------------------------------------------------------------

%(command M6 or D6, response code 6).
fprintf(port_obj,'M6\n');
[xyuvroot] = fgetl(port_obj);
xyuv = regexp(xyuvroot, ',', 'split');
qq = xyuv(1);
U = xyuv(2);
Y = str2double(xyuv(3));
x = str2double(xyuv(4));
y = str2double(xyuv(5));
u = str2double(xyuv(6));
v = str2double(xyuv(7));
PR650_QualityCode(qq);
[units] = Read_Units(U,0,1);