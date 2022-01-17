function [glare] = designGlare( glare, lcd)
%xxxx Summary of this function goes here
%   Detailed explanation goes here

    % Estimate size considering the visual angle glare.
    pixSize=lcd.screenWidth/lcd.screenXpixels; % Pixel sizecm/pix.
    SizeCm=2*lcd.viewingDistance*tan(pi*glare.glareDimDegree/(2*180)); % Dimension of gabor in cm.

    % Dimension of glare square in pixels.
    glare.glareDimPix=round(SizeCm/pixSize); 

    % Set of witdh of the glare squre.
    %glare.glareWidth=3;
    
end
