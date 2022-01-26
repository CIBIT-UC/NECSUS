function glare = glareInfo()
%GLAREINFO Summary of this function goes here
%   Detailed explanation goes here


glare=struct();

glare.glareDimDegree    = 12.5; % Dimension of the glare setup (degrees).

% Dot specs.
glare.glareDotWidth     = .3;  % width of dot (deg).
glare.spaceBetwDotsDeg  = 2; % spacing between dots (deg).

% glare.glareWidth= XXX ; % Dimension of the glare setup (pixels)

glare.s                 = RandStream('mlfg6331_64'); % Randomize dots blinking.
glare.numBlinkingDots   = 10;

glare.blinkOffTime      =.1; % (seconds)
glare.blinkInterval     =.3; % (seconds)

glare.y=[];
glare.xy=[];

end

