function PR650_QualityCode (qq)
%-------------------------------------------------------------
% Returns the PR650 ASCII Mode Measurement (qq) Quality Codes.
%
%*************Glautech Project Team (JPAM)********************
%-------------------------------------------------------------

if (str2double(qq) ~= 0)
   switch str2double(qq)
   case  1, msg = 'No EOS signal at start of measurement';
   case  3, msg = 'No start signal';
   case  4, msg = 'No EOS signal to start integration time';
   case  5, msg = 'DMA failure';
   case  6, msg = 'No EOS after changed to SYNC mode';
   case  7, msg = 'Unable to sync to light source';
   case  8, msg = 'Sync lost during measurement';
   case 10, msg = 'Weak light signal';
   case 12, msg = 'Unspecified hardware malfunction';
   case 13, msg = 'Software error';
   case 14, msg = 'No sample in L*u*v* or L*a*b* calculation';
   case 16, msg = 'Adaptive integration taking to much time. Possible variable light source';
   case 17, msg = 'Main battery is low';
   case 18, msg = 'Low light level';
   case 19, msg = 'Light level too high (overload)';
   case 20, msg = 'No sync signal';
   case 21, msg = 'RAM error';
   case 29, msg = 'Corrupted data';
   case 30, msg = 'Noisy signal';
   otherwise, msg = ['Unknown error number (error = ' int2str(qq) ')'];
   end
   disp(msg);
else
   disp('Measurement Quality Code (qq) okay.')
end