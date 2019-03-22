function [linInput] = luminanceToRgb(lumRequired, bitsRes, lcd)

if nargin<3  
    pathToGreydata=lcd.pathToGreyData;
    %'Common\LCD_linear_Acromatic_grey_data.mat';
end

if nargin<2
    bitsRes=8;
end

if nargin<1
    lumRequired=20;
end

% --- load data ---
% LCD monitor RGB matrix on input
% returns RGB_lum (true output), FitParamters (gamma, offset)
load(pathToGreydata);

maxLum=max(RGB_lum(:,2));

% Assuming linear CLUT.
linInput=lumRequired/maxLum;

end