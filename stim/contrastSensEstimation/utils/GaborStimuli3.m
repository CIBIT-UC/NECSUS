function GaborStimuli3

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
clear all;
sca;

NameSubject=input('Name:','s'); % participant's name
SpatialFrequency=input('SF:','s'); % desired spatial frequency
sky=input('glare/noglare?:','s'); % desired spatial frequency

% keyboard "normalization" of Escape key
Kbname('UnifyKeyNames');

% Trick suggested by the PTB authors to avoid synchronization/calibration
% problems
figure(1)
plot(sin(0:0.1:3.14));
% Close figure with sin plot (PTB authors trick for synchronization)
close Figure 1

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

    try
        % Set "real time priority level"
        Priority(2)

        % Time at which the task starts
        % startTime = GetSecs;


        % --------------------------COLOR SETUP--------------------------------

        % luminance background required => 20 cd/m2
        % bit resolution =>8
        % get background RGB from grey monitor luminance responce
        [lum_obtained,Rb,Gb,Bb]=lum_match_RGBfinder(20,8);
        % define black.

        %  ----------------------- START DISPLAY ------------------------------

        % Open an on screen window
        [window, windowRect] = Screen('OpenWindow', screenNumber,[Rb,Gb,Bb],[], [], [], [], 0);

        % Get the size of the on screen window
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
        % Set the text size
        Screen('TextSize', window, 50);


        %------------------------ PARAMETER SETUP------------------------------

        % % CENTRAL CROSS INFORMATION % %

        % Get the centre coordinate of the window
        [xCenter, yCenter] = RectCenter(windowRect);
        HideCursor;

        % set of size of the arms of our fixation cross
        fixCrossDimPix=20;

        % set the coordinates for fixation cross in the center of the screen
        xCrossCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
        yCrossCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
        CrossCoords = [xCrossCoords; yCrossCoords];

        % set the line width for our fixation cross
        lineWidthPix=4;


        % % GABOR INFORMATION % %

        screenHeight = 70,0; % Screen height (cm)
        screenWidth = 39,5; % Screen width (cm)
        viewingDistance = 40; % Viewing Distance (cm)
        gaborDimPix = 750; % Dimension of the region where will draw the Gabor in pixels
        sigma = gaborDimPix / 7; % Sigma of Gaussian
        phase=0;
        angle = 0; %the optional orientation angle in degrees (0-360)
        aspectratio = 1.0; % Defines the aspect ratio of the hull of the gabor
        desiredSF = str2num(SpatialFrequency); % Desired Spatial Frequency in cpd.


         % Get Spatial Frequency (cycles Per Pixel)
         [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);

         % Build a procedural gabor texture
         gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[0.5573 0.5573 0.5573 0.0]);

         sample_start=2;
         sample_end=14;
         sample_step=2;
         numRepeats=20; %number of times we want to do each conditiondition

         %create a vector with values of contrast 
         contrastStimulis = sample_start:sample_step:sample_end; % values of contrast 
         condVector = Shuffle(repmat(contrastStimulis, 1, numRepeats));% make a full condition vector and then shuffle it  


         % Calculate the number of trials
         ntrials = numel(condVector);

         % Make a vector to record the response for each trial
         respMatrix = zeros(ntrials,3);

        %-------------------------TIME INFORMATION---------------------------%

        % Query the frame duration
        ifi = Screen('GetFlipInterval', window);


        % Presentation Time for the Gabor in seconds and frames
        presTimeSecs = 1;
        presTimeFrames = round(presTimeSecs / ifi);

        % Interstimulus interval time in seconds and frames
        isiTimeSecs = 0.5;
        isiTimeFrames = round(isiTimeSecs / ifi);


       % -------------------- KEYBORD INFORMATION ------------------------%

        escapekey=KbName('Escape');
        keyNotView=KbName('z'); % key not see
        keyView=kbName('m'); % key to see


        %-----------------------------------------------------------------%
        %                      EXPERIMENTAL LOOP
        %-----------------------------------------------------------------%


        for trial = 1:ntrials

         
            % Get the Gabor contrast and freq for this trial 
            contrast= condVector(trial);
         
            if trial==1

                % Change the blend function to draw an antialiased fixation point
                % in the centre of the screen
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

                % Display fixation cross in the center of the screen and wait for
                % keyboard key press to start countdown (5 to 1 with 0.5 sec interval)
                Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                Screen('Flip',window);% Flip to the screen
                KbWait; % wait for a key press

                % Display number "5" on top of the central cross
                Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                Screen('DrawText',window,'5',xCenter-20,yCenter-35,white);
                Screen('Flip',window);% Flip to the screen
                WaitSecs(0.5);

                % Display number "4" on top of the central cross
                Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                Screen('DrawText',window,'4',xCenter-20,yCenter-35,white);
                Screen('Flip',window);% Flip to the screen
                WaitSecs(0.5);

                 % Display number "3" on top of the central cross
                Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                Screen('DrawText',window,'3',xCenter-20,yCenter-35,white);
                Screen('Flip',window);% Flip to the screen
                WaitSecs(0.5);

                % Display number "2" on top of the central cross
                Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                Screen('DrawText',window,'2',xCenter-20,yCenter-35,white);
                Screen('Flip',window);% Flip to the screen
                WaitSecs(0.5);

                 % Display number "1" on top of the central cross
                Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                Screen('DrawText',window,'1',xCenter-20,yCenter-35,white);
                Screen('Flip',window);% Flip to the screen
                WaitSecs(0.5);
                
%                 %Display the central cross fixation alone
%                 Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
%                 Screen('Flip',window);% Flip to the screen
%                 WaitSecs(0.5);
            end


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
                     Screen('DrawTexture', window, gabortex, [], [], angle, [], [], ...
                          [], [], kPsychDontDoRotation, [phase+180, SF, sigma, contrast, aspectratio, 0, 0, 0]);

                    % Flip to the screen
                     Screen('Flip', window);
                     
              end

                 Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                 Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
                 % Flip to the screen
                 Screen('Flip', window);


            % Now we wait for a keyboard button signaling the observers response.
            % The left arrow key signals a "left" response and the right arrow key
            % a "right" response. You can also press escape if you want to exit the
            % program
            tStart = GetSecs;

            respToBeMade = true;

            while respToBeMade
                [keyIsDown,secs, keyCode] = KbCheck;
                if keyCode(escapekey)
                    ShowCursor;
                    sca;
                    return
                elseif keyCode(keyView)
                    respMatrix(trial,1) = trial;
                    respMatrix(trial,2) = contrast;
                    respMatrix(trial,3) = 1;
                    respToBeMade = false;
                elseif keyCode(keyNotView)
                    respMatrix(trial,1) = trial;
                    respMatrix(trial,2) = contrast;
                    respMatrix(trial,3) = 0;
                    respToBeMade = false;
                end  
            end
      
        end
    
    %---------------------------------------------------------------------%
    %                        GET AND SAVE DATA
    %---------------------------------------------------------------------%
  
    % save answers subjects
    nameFile = sprintf('%s_%s_TestAnswers_%s',NameSubject,SpatialFrequency,sky);
    NameFile = fullfile(pwd,'Results',nameFile)
    save(NameFile,'respMatrix');

    %---------------------------------------------------------------------%
    %                         CLOSE TEST
    %---------------------------------------------------------------------%
   
    Screen('Close',window);
    ShowCursor;
    Priority(0);
    
    
catch me

  % Close PTB Screen
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(me);

    % ---------------------- 

end