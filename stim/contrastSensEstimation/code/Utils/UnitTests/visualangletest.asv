screenXpixels = 1920; 
screenWidth = 50;
viewingDistance = 150;
glareDimDegree = 25;


% Estimate size considering the visual angle glare.
pixSize     = screenWidth/screenXpixels; % Pixel sizecm/pix.
SizeCm      = 2*viewingDistance*tan(pi*glareDimDegree/(2*180)) % Dimension of gabor in cm.

% Dimension of glare square in pixels.
glareDimPix   = round(SizeCm/pixSize)



