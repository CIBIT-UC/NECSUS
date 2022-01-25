

ori=[100, 100];
scrSize=8;

% open screen for debug
screens=Screen('Screens');
screenNumber=max(screens);
[w, rect] = Screen('OpenWindow', screenNumber, [0, 0, 0], [ ori, ori*scrSize]);


% Get center position.
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[center(1), center(2)] = RectCenter(rect);

% Get white color.
white = WhiteIndex(w);

% Get white color.
black = BlackIndex(w);

offTime=.100; % (seconds)

s = RandStream('mlfg6331_64'); 
BlinkDots = 3;



%%

glareSquareDeg  = 10;

% pixels per degree
mon_width   = 59;   % horizontal dimension of viewable screen (cm)
v_dist      = 40;   % viewing distance (cm)
ppd         = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    

% Dot specs.
dot_w       = .5;  % width of dot (deg)
spacingBetwInDeg = 1; % spacing between dots (deg).
glareSquarePix  = glareSquareDeg * ppd;



%%
% [minSmoothPointSize, maxSmoothPointSize, minAliasedPointSize, maxAliasedPointSize] = Screen(%DrawDots , windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);

xymatrix=getGlareSide( ppd,...
    center(1) - glareSquarePix, ...
    center(2) - glareSquarePix, ...
    center(1) + glareSquarePix, ...
    center(2) + glareSquarePix, ...
    spacingBetwInDeg);

dotSizePix=ceil(dot_w*ppd);

%Screen('DrawDots', w, xymatrix, s, colvect, center, 1);  % change 1 to 0 or 4 to draw square dots
Screen('DrawDots', w, xymatrix, dotSizePix);  % change 1 to 0 or 4 to draw square dots

Screen('Flip', w, [], 1);

%%

for i = 1: 10
     pause(1)

    y = randsample(s,size(xymatrix,2),BlinkDots);

    Screen('DrawDots', w, xymatrix(:,y), dotSizePix, black);      
    Screen('Flip', w);
    
    pause(offTime)
    
    % Screen('DrawDots', w, xymatrix, s, colvect, center, 1); 
    Screen('DrawDots', w,  xymatrix, dotSizePix, white);  
    
    Screen('Flip', w, [], 1);

end
%%
sca






function pos = getGlareSide( ppd, a, b, c, d, spacingBetwInDeg)

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



