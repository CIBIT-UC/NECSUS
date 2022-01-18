

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

offTime=.250; % (seconds)

s = RandStream('mlfg6331_64'); 
BlinkDots = 3;



%%

glareSquareDeg  = 10;

% pixels per degree
mon_width   = 59;   % horizontal dimension of viewable screen (cm)
v_dist      = 40;   % viewing distance (cm)

ppd         = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    

dot_w       = 1;  % width of dot (deg)
spacingBetwInDeg = 2; % spacing between dots (deg).
glareSquarePix  = glareSquareDeg * ppd;


%% Draw something

Screen('FillRect', w, white, [1 1 290 290]);

Screen('Flip', w);


%%
% [minSmoothPointSize, maxSmoothPointSize, minAliasedPointSize, maxAliasedPointSize] = Screen(%DrawDots , windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);

xymatrix=getGlareSidePos( ppd,...
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

