function [lum_obtained, Rb, Gb, Bb] = lum_match_RGBfinder(lum_required, bits_resolution)

load('Common\LCD_linear_Acromatic_grey_data.mat');

rgb_Grey = ((((lum_required) - FitParameters(1,3))/(FitParameters(1,1)))^(1/(FitParameters(1,2))));
RGB_Grey = rgb_Grey*((2^(bits_resolution))-1);

Rb = round(RGB_Grey);
Gb = round(RGB_Grey);
Bb = round(RGB_Grey);

% desvio devido ao arredondamento
real_Grey = Rb/((2^(bits_resolution))-1);

lum_obtained = (FitParameters(1,1)*(real_Grey^(FitParameters(1,2))))+FitParameters(1,3);
end