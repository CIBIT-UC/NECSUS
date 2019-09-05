function [freq] = Meas_Sync (port_obj)
%---------------------------------------------------------
% Measure frequency in Hz.
%
%**************Glautech Project Team (JPAM)***************
%---------------------------------------------------------
%(command F).
fprintf(port_obj,'F\n');
[dataroot] = fgetl(port_obj);
freq1 = regexp(dataroot, ',', 'split');
qq = freq1(1);
freq = freq1(2);
PR650_QualityCode(qq);