% demo test

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

clear all;
close all;
clc;

% keyboard "normalization" of Escape key
KbName('UnifyKeyNames');

% --- LCD monitor / GABOR INFORMATION ---
screenHeight=25.9; % Screen height (cm)34.7; %
screenWidth=54.6; % Screen width (cm)
viewingDistance=40; %150; % Viewing Distance (cm)
gaborDimDegree=40; %750; % Dimension of the region where will draw the Gabor in pixels

nTrials = 1;


phase=0; % spatial phase
angle=0; %the optional orientation angle in degrees (0-360)
aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
backGroundLum=20;


desiredSF=.05;
setTest=40;


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


try
    
    % Time at which the task starts
    % startTime = GetSecs;
    
    % --------------------------COLOR SETUP--------------------------------
    
    % get background RGB from gray monitor luminance response
    % bit resolution => 8
    [normlzInput,Rb,Gb,Bb]=lumMatchRGBFinder(backGroundLum,8);
    
    % define white.
    white=WhiteIndex(screenNumber); % required to display fixation cross
    
    %  ----------------------- START DISPLAY ------------------------------
    
    % Open an on screen window
    [window, windowRect]=Screen('OpenWindow', screenNumber,[Rb,Gb,Bb],[],[],[],[],0);
    
    load('C:\Users\Bruno\Desktop\LuminanciaLCD-PR650-dez2018\LCDnexus\necsusNOLIGHT-LCD_monitor_RGB_Lum11-Dec-2018.mat');
    gammaTable = RGB_lum;
    for c = 1:4
        gammaTable(:,c)=gammaTable(:,c)./max(gammaTable(:,c));
    end
  
    Screen('LoadNormalizedGammaTable', window, gammaTable(:,2:end))
    
    %%
    
    % Get the centre coordinate of the window
    [xCenter, yCenter]=RectCenter(windowRect);
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels]=Screen('WindowSize', window);
    % Set the text size
    Screen('TextSize', window, 50);
    
    % Get Spatial Frequency (cycles Per Pixel) and  gabor dimensions
    [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);
    [gaborDimPix] = getGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree);
    
    % Sigma of Gaussian
    sigma = gaborDimPix /7;
    
    % Build a procedural gabor texture
    gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[normlzInput,normlzInput,normlzInput, 0.0], 0);
    
    nGabors=2;
    
    % Make the destination rectangles for all the Gabors in the array
    baseRect = [0 0 gaborDimPix gaborDimPix];
    
    allRects(:, 1) = CenterRectOnPointd(baseRect, xCenter, yCenter);
    
    propertiesMat = [phase+180, SF, sigma, setTest, aspectratio, 0, 0, 0];
    
    % Fixation cross
    
    % set of size of the arms of our fixation cross
    fixCrossDimPix=20;
    
    % set the coordinates for fixation cross in the center of the screen
    xCrossCoords=[-fixCrossDimPix fixCrossDimPix 0 0];
    yCrossCoords=[0 0 -fixCrossDimPix fixCrossDimPix];
    CrossCoords=[xCrossCoords; yCrossCoords];
    
    % set the line width for our fixation cross
    lineWidthPix=4;
    
    
    
    
    
    %%
    
    %-------------------------STIMULI INFORMATION---------------------------%
    
    
    fprintf('\n test %f.\n ', setTest)
    
    
    tTest=setTest;
    
        
    % Now we draw the Gabor
    
    % Set the right blend function for drawing the gabors
    Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');
    
    % Draw the Gabor
    Screen('DrawTextures', window, gabortex, [], allRects, angle, [], [], ...
        [], [], kPsychDontDoRotation, propertiesMat');
    
    % Flip to the screen
    Screen('Flip', window);
    
%     
%     Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
%     Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
%     % Flip to the screen
%     Screen('Flip', window);
%     
    escapekey=KbName('Escape');
    
    while 1
        [keyIsDown,secs, keyCode] = KbCheck;
        if keyCode(escapekey)
            ShowCursor;
            sca;
            return
        end
    end
    
    Screen('Close',window);
    
    
catch me
    warning(me.message);
    % Close PTB Screen
    Screen('CloseAll');
    
    rethrow(me);
    
end
