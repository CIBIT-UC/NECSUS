function glaredemo()


% Get the screen numbers
screens=Screen('Screens');

% Draw to the external screen if avaliable
screenNumber=max(screens);


[window, windowRect]=Screen('OpenWindow',screenNumber, 0);


% Get the centre coordinate of the window
[xCenter, yCenter]=RectCenter(windowRect);

% Get the size of the on screen window
[screenXpixels, screenYpixels]=Screen('WindowSize', window);

dur=1; 

sidelength=400;
sidewidth=5;


Screen('FrameRect',window,[],[xCenter-sidelength yCenter-sidelength xCenter+sidelength yCenter+sidelength], sidewidth)


Screen('DrawLines',window,[200 300 300 400 400 500; 300 300 400 400 500 600],2, [255 8 89])
Screen('Flip',window)
WaitSecs(dur)


Screen('CloseAll');