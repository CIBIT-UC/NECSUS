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
gaborDimDegree=20; %750; % Dimension of the region where will draw the Gabor in pixels

nTrials = 1;
setTest=[1 10 4096 1024 .5 1.5];


phase=0; % spatial phase
angle=0; %the optional orientation angle in degrees (0-360)
aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
desiredSF=.1;
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

try
    
    % Time at which the task starts
    % startTime = GetSecs;
    
    % --------------------------COLOR SETUP--------------------------------
    
    % get background RGB from gray monitor luminance response
    % bit resolution => 8
    [normlzInput,Rb,Gb,Bb]=lum_match_RGBfinder(backGroundLum,8);
    
    % define white.
    white=WhiteIndex(screenNumber); % required to display fixation cross
    
    %  ----------------------- START DISPLAY ------------------------------
    
    % Open an on screen window
    [window, windowRect]=Screen('OpenWindow', screenNumber,[Rb,Gb,Bb],[],[],[],[],0);
    
    % Get the centre coordinate of the window
    [xCenter, yCenter]=RectCenter(windowRect);
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels]=Screen('WindowSize', window);
    % Set the text size
    Screen('TextSize', window, 50);
    
    % Get Spatial Frequency (cycles Per Pixel) and  gabor dimensions
    [SF] = computeSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);
    [gaborDimPix] = computeGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree);
    
    % Sigma of Gaussian
    sigma = gaborDimPix /7;
    
    % Build a procedural gabor texture
    gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[normlzInput,normlzInput,normlzInput, 0.0], 0);
    
    nGabors=2;
    
    % Make the destination rectangles for all the Gabors in the array
    baseRect = [0 0 gaborDimPix gaborDimPix];
   
    allRects(:, 1) = CenterRectOnPointd(baseRect, xCenter-300, yCenter);
    allRects(:, 2) = CenterRectOnPointd(baseRect, xCenter+300, yCenter);
    
    propertiesMat = repmat([phase+180, SF, sigma, NaN, aspectratio, 0, 0, 0],...
    nGabors, 1);

    
    
    % Fixation cross
    

    
    % set of size of the arms of our fixation cross
    fixCrossDimPix=20;
    
    % set the coordinates for fixation cross in the center of the screen
    xCrossCoords=[-fixCrossDimPix fixCrossDimPix 0 0];
    yCrossCoords=[0 0 -fixCrossDimPix fixCrossDimPix];
    CrossCoords=[xCrossCoords; yCrossCoords];
    
    % set the line width for our fixation cross
    lineWidthPix=4;
    
    
    %-------------------------TIME INFORMATION---------------------------%
    
    % Query the frame duration
    ifi = Screen('GetFlipInterval', window);
    
    % Presentation Time for the Gabor in seconds and frames
    presTimeSecs = 5; %500msec
    presTimeFrames = round(presTimeSecs / ifi);
    
    % Interstimulus interval time in seconds and frames
    isiTimeSecs = 1; %1000msec
    isiTimeFrames = round(isiTimeSecs / ifi);
    
    
    %%
    
    %-------------------------STIMULI INFORMATION---------------------------%
    
    
    
    for trial = 1:nTrials
        
        propertiesMat(:,4) = [setTest(trial);setTest(trial+1)];
        
        fprintf('\n left %f, right %i.\n ', setTest(trial), setTest(trial+1))
        
        
        tTest=setTest(trial);
        
        % Now we present the isi interval with fixation point minus one frame
        % because we presented the fixation point once already when getting a
        % time stamp
        for frame = 1:isiTimeFrames
            
            % Draw the fixation cross
            Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
            % Flip to the screen
            Screen('Flip', window);
        end
        
        % Now we draw the Gabor
        for frame=1:presTimeFrames
            
            % Set the right blend function for drawing the gabors
            Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');
            
            % Draw the Gabor
            Screen('DrawTextures', window, gabortex, [], allRects, angle, [], [], ...
                [], [], kPsychDontDoRotation, propertiesMat');
            
            % Flip to the screen
            Screen('Flip', window);
            
        end
        
        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
        % Flip to the screen
        Screen('Flip', window);
    end
    
    
    
    Screen('Close',window);
    
    
catch me
    warning(me.message);
    % Close PTB Screen
    Screen('CloseAll');
    
    rethrow(me);
    
end
