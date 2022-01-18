function pos = getGlareSidePos( ppd, a, b, c, d, spacingBetwInDeg)

if nargin <1
    ppd=4;
    
    % point#1 (a,b); point#2 (c,d)
    a = 0;
    b = 0;
    c=100; 
    d=100;
    
    spacingBetwInDeg=1;
end

% Legnth of one side - similar to the other 3.
sideLength = pdist([a,b;a,d],'euclidean');

% Number of points considering side length, screen and visual angles.
numPoints = sideLength / (spacingBetwInDeg * ppd);

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



