function glare = glareInfo()
%GLAREINFO Summary of this function goes here
%   Detailed explanation goes here


glare=struct();

glare.glareDimDegree    = 12.5; % Dimension of the glare setup (degrees).

% Dot specs.
glare.glareDotWidth     = .5;  % width of dot (deg).
glare.spaceBetwDotsDeg  = 1; % spacing between dots (deg).

% glare.glareWidth= XXX ; % Dimension of the glare setup (pixels)

glare.s                 = RandStream('mlfg6331_64'); % Randomize dots blinking.
glare.numBlinkingDots   = 5;

glare.blinkOffTime      =.3; % (seconds)
glare.blinkInterval     =.5; % (seconds)

end

