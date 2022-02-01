function pos = getGlareSidePos( glare, a, b, c, d)


% Legnth of one side - similar to the other 3.
sideLength = pdist([a,b;a,d],'euclidean');

% Number of points considering side length, screen and visual angles.
numPoints = sideLength / glare.glareSpacingPixs;

% Separation between points.
sepBetweenPointsInPix= linspace(0,sideLength,numPoints);

pos = [];

% Get position from all sides.

% Left

xCoord = ones(size(sepBetweenPointsInPix)) * a;
yCoord = b+sepBetweenPointsInPix;
pos=[xCoord; yCoord];

% Top
xCoord = a+sepBetweenPointsInPix;
yCoord = ones(size(sepBetweenPointsInPix)) * b;
pos=[pos,[xCoord; yCoord]];

% Bottom
xCoord = a+sepBetweenPointsInPix;
yCoord = ones(size(sepBetweenPointsInPix)) * d;
pos=[pos,[xCoord; yCoord]];

% Right
xCoord = ones(size(sepBetweenPointsInPix)) * c;
yCoord = b+sepBetweenPointsInPix;
pos=[pos,[xCoord; yCoord]];

end



