function [nData, BandW, Fstwave, Lstwave, width] = SpectralRange (port_obj)
%----------------------------------------------------
% Spectral Range of this instrument.
% Response Code 120.
%
%************Glautech Project Team (JPAM)************
%----------------------------------------------------
fprintf(port_obj,'D120\n');
[Spec_Range] = fgetl(port_obj);
Spectinf = regexp(Spec_Range, ',', 'split');
nData = Spectinf(1);
BandW = Spectinf(2);
Fstwave = Spectinf(3);
Lstwave = Spectinf(4);
width = Spectinf(5);
end 