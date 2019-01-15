% demo test

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

clear all;
close all;
clc;

% --- LCD monitor / GABOR INFORMATION ---
screenHeight=25.9; % Screen height (cm)34.7; %
screenWidth=54.6; % Screen width (cm)
viewingDistance=40; %150; % Viewing Distance (cm)
gaborDimDegree=12; %750; % Dimension of the region where will draw the Gabor in pixels

nTrials = 4;
setTest=[1024 2048 4096 1024 .5 1.5];


phase=0; % spatial phase
angle=0; %the optional orientation angle in degrees (0-360)
aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
desiredSF=3;
backGroundLum = 20;


% --- Trick by the PTB authors to avoid synchronization problem ---
figure(1);
plot(sin(0:0.1:3.14));
% Close figure with sin plot
close Figure 1
% --- end of synchronization trick ---

% Get the screen numbers
screens=Screen('Screens');

% Draw to the external screen if avaliable
screenNumber=max(screens);


%-------------------------------------------------
% Backgroud Color: Black
% Start Test Display


gray = [1 128 255 512];

try
    [window, windowRect]=Screen('OpenWindow', screenNumber);
    
    xcenter = windowRect(3)/2;
    ycenter = windowRect(4)/2;
    
        %------------------------------------------------- 
    % Backgroud Color: Black
    Screen('FillRect',window,[0 0 0]);
    Screen('Flip',window);
    
    for g = 1:3
        
        Screen('FillOval', window, [gray(g) gray(g) gray(g)],[(xcenter-150)-40 ycenter-40 (xcenter-150)+40 ycenter+40]);
        Screen('FillOval', window, [gray(g+1) gray(g+1) gray(g+1)],[(xcenter+150)-40 ycenter-40 (xcenter+150)+40 ycenter+40]);

        Screen('Flip',window);

        
        pause(5)
    end
    
    
    
    %     % Time at which the task starts
    %     % startTime = GetSecs;
    %
    %     % --------------------------COLOR SETUP--------------------------------
    %
    %     % get background RGB from gray monitor luminance response
    %     % bit resolution => 8
    %     [normlzInput,Rb,Gb,Bb]=lumMatchRGBFinder(backGroundLum,8);
    %
    %     % define white.
    %     white=WhiteIndex(screenNumber); % required to display fixation cross
    %
    %     %  ----------------------- START DISPLAY ------------------------------
    %
    %     % Open an on screen window
    %     [window, windowRect]=Screen('OpenWindow', screenNumber,[Rb,Gb,Bb],[],[],[],[],0);
    %
    %     % Get the centre coordinate of the window
    %     [xCenter, yCenter]=RectCenter(windowRect);
    %
    %     % Get the size of the on screen window
    %     [screenXpixels, screenYpixels]=Screen('WindowSize', window);
    %     % Set the text size
    %     Screen('TextSize', window, 50);
    %
    %     % Get Spatial Frequency (cycles Per Pixel) and  gabor dimensions
    %     [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);
    %     [gaborDimPix] = getGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree);
    %
    %     % Sigma of Gaussian
    %     sigma = gaborDimPix /7;
    %
    %     % Build a procedural gabor texture
    %     gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[normlzInput,normlzInput,normlzInput, 0.0], 0);
    %
    %     nGabors=2;
    %
    %     % Make the destination rectangles for all the Gabors in the array
    %     baseRect = [0 0 gaborDimPix gaborDimPix];
    %
    %     allRects(:, 1) = CenterRectOnPointd(baseRect, xCenter-300, yCenter);
    %     allRects(:, 2) = CenterRectOnPointd(baseRect, xCenter+300, yCenter);
    %
    %     propertiesMat = repmat([phase+180, SF, sigma, NaN, aspectratio, 0, 0, 0],...
    %         nGabors, 1);
    %
    %
    %
    %
    %
    
    Screen('Close',window);
    
    
catch me
    warning(me.message);
    % Close PTB Screen
    Screen('CloseAll');
    
    rethrow(me);
    
end
