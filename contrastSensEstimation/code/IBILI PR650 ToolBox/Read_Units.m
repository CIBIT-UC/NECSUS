function [units] = Read_Units (U, Spectral_id, Eng_SI)
%---------------------------------------------------------
% Read the Units type defined by the 'S' command.
% U = Units field in PR-650 responses
% Spectral_id = 0 or 1, 0 non spectral measures, 1 spectral
% Eng_SI = if we choose the English or SI System
%
%************Glautech Project Team (JPAM)*****************
%---------------------------------------------------------
flag = str2double(U);
% if command set is in English units (0) if is in SI units (1)
if Eng_SI == 0
    if Spectral_id == 0
        if flag == 0
            units = 'footLamberts';
        elseif flag == 1
            units = 'footCandles';
        else
            disp('Uncalibrated');
        end
    elseif Spectral_id == 1
        if flag == 0
            units = 'spectral radiance (W*m-2*sr-1*nm-1)';
        elseif flag == 1
            units = 'spectral irradiance (W*m-2*nm-1)';
        else
            disp('Uncalibrated');
        end
    else
        disp('Correct Spectral_id Parameter missing in function Read_Units');
    end
elseif Eng_SI == 1
     if Spectral_id == 0
        if flag == 0
            units = 'cd/m2';
        elseif flag == 1
            units = 'lux';
        else
            disp('Uncalibrated');
        end
    elseif Spectral_id == 1
        if flag == 0
            units = 'spectral radiance (W*m-2*sr-1*nm-1)';
        elseif flag == 1
            units = 'spectral irradiance (W*m-2*nm-1)';
        else
            disp('Uncalibrated');
        end
    else
        disp('Correct Spectral_id Parameter missing in function Read_Units');
    end
else
    disp('Correct Eng_SI Parameter missing in function Read_Units');
end