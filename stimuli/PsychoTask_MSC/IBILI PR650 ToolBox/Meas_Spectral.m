function [I2spec, wavelength, Spect_int, units] = Meas_Spectral (port_obj)
%------------------------------------------------------------------
% Radiometric (spectral) data. Integrated intensity (I2 - total area 
% under sepctral curve) in units specified by 'U'.
% Measure Light Under Conditions defined by the 'S' command line.
%
%*******************Glautech Project Team (JPAM)*******************
%------------------------------------------------------------------

%(command M5 or D5, response code 5).
wavelength = zeros(1,101);
Spect_int = zeros(1,101);
fprintf(port_obj,'M5\n');
[qqUroot] = fgetl(port_obj);
[I2spec] = fgetl(port_obj);
for n=1:101
    [wavelroot] = fgetl(port_obj);
    wavel = regexp(wavelroot, ',', 'split');
    wavelength(n) = str2double(wavel(1));
    Spect_int(n) = str2double(wavel(2));
end    
qqU = regexp(qqUroot, ',', 'split');
qq = qqU(1);
U = qqU(2);
PR650_QualityCode(qq);
[units] = Read_Units(U,1,1); 