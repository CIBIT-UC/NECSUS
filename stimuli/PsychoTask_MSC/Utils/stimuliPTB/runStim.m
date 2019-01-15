function [  ] = runStim( ptb, lcd, gabor, quest )
%RUNSTIM run stim based on preset variables

% load gamma-corrected CLUT (color look-up table)
load('.\Utils\luminance\invertedCLUT.mat');

try
    % --- PTB setup ---
    Priority(2); % Set "real time priority level".    
    [window,~]=Screen('OpenWindow', ptb.whichScreen); % Open PTB full-screen window.
    
    % --- MONITOR SETUP / Linearize monitor gamma ---
    linearCLUT=Screen('LoadNormalizedGammaTable',window,inverseGammaTable); % upload inverse gamma function to screen - linearize lum.
    normlzInput=luminanceToRgb(ptb.backgroundLum);
    
    % Define white.
    white=WhiteIndex(ptb.screenNumber); % required to display fixation cross
    
    
    % --- START DISPLAY ---
    
    % Open an on screen window
    [window, windowRect]=Screen('OpenWindow', screenNumber,[normlzInput,normlzInput,normlzInput],[],[],[],[],0);
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels]=Screen('WindowSize', window);
    % Set the text size
    Screen('TextSize', window, 50);
    
    
    % --- PARAMETER SETUP ---
    
    % --- GABOR INFO ---
    
    % Get Spatial Frequency (cycles Per Pixel) and  gabor dimensions
    [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);
    [gaborDimPix] = getGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree);
    
    % Sigma of Gaussian
    sigma = gaborDimPix /7;
    
    % Build a procedural gabor texture
    gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[normlzInput,normlzInput,normlzInput, 0.0]);
    
    
    % Fixation cross
    
    % Get the centre coordinate of the window
    [xCenter, yCenter]=RectCenter(windowRect);
    HideCursor;
    
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
    presTimeSecs = 0.5; %500msec
    presTimeFrames = round(presTimeSecs / ifi);
    
    % Interstimulus interval time in seconds and frames
    isiTimeSecs = 1; %1000msec
    isiTimeFrames = round(isiTimeSecs / ifi);
    
    
    % -------------------- KEYBORD INFORMATION ------------------------%
    
    escapekey=KbName('Escape');
    keyNotView=KbName('z'); % key not see
    keyView=KbName('m'); % key to see
    
    
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP
    %-----------------------------------------------------------------%
    
    countDownVals={'1','2','3'};
    
    sCrit = 0;
    
    for trial = 1:nTrials
        
        t=QuestMean(q);
        sd=QuestSd(q);
        fprintf('Value of QUEST mean %f and sd %f.\n',t,sd);
        
        % set stopping criteria
        if sd < deltInt
            sCrit = 1;
            break,
        end
        
        if ~sCrit
            % Get the Gabor contrast
            % tTest=QuestQuantile(q);
            % tTest=QuestMean(q)		% Recommended by King-Smith et al. (1994)
            % tTest=QuestMode(q);		% Recommended by Watson & Pelli (1983)
            
            [~,sortdIdxs]=sort(abs(QuestMean(q)-CSFScale));
            %[~,idx]=min(abs(QuestMean(q)-CSFScale));
            
            idx=sortdIdxs(1);
            
            if CSFScale(sortdIdxs(1))==last
                idx=sortdIdxs(2);
            end
            
            fprintf('Next contrast test %f.\n', CSFScale(idx) );
            
            tTest=CSFScale(idx);
            
            % fprintf('Value of QUEST %f and of the last sample %f.\n',QuestMean(q),last);
            
            if trial==1
                tTest=init;
                
                % Change the blend function to draw an antialiased fixation point
                % in the centre of the screen
                Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
                
                % Display fixation cross in the center of the screen and wait for
                % keyboard key press to start countdown (5 to 1 with 0.5 sec interval)
                DrawFormattedText(window,'press key.','center','center',white);
                Screen('Flip',window);% Flip to the screen
                KbStrokeWait;
                
                for countDown = 0:numel(countDownVals)-1
                    % Display number countDown
                    DrawFormattedText(window,countDownVals{numel(countDownVals)-countDown},'center','center',white);
                    Screen('Flip',window);% Flip to the screen
                    WaitSecs(1);
                    
                end
                
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
                    [], [], kPsychDontDoRotation, [phase+180, SF, sigma, tTest, aspectratio, 0, 0, 0]);
                
                % Flip to the screen
                Screen('Flip', window);
                
            end
            
            Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
            % Flip to the screen
            Screen('Flip', window);
            
            
            % Now we wait for a keyboard button signaling the observers response.
            % The 'm' key signals a positive response
            %   (the participaant saw the stimuli)
            % and the 'z' key a negative response
            %   (the participant was not able to see the stimuli).
            % You can also press escape if you want to exit the program.
            
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
                    respMatrix(trial,2) = tTest;
                    respMatrix(trial,3) = 1;
                    respToBeMade = false;
                    % Update the pdf
                    response=1;
                    q=QuestUpdate(q,tTest,response); % Add the new data (actual test intensity and observer response) to the database.
                    
                elseif keyCode(keyNotView)
                    respMatrix(trial,1) = trial;
                    respMatrix(trial,2) = tTest;
                    respMatrix(trial,3) = 0;
                    respToBeMade = false;
                    % Update the pdf
                    response=0;
                    q=QuestUpdate(q,tTest,response); % Add the new data (actual test intensity and observer response) to the database.
                    
                end
            end
            
        end
        
        last=tTest;
        % fprintf('Value of QUEST %f and of the last sample %f.\n',QuestMean(q),last);
    end
    
    Screen('Close',window);
    ShowCursor;
    Priority(0);
    
catch me
    warning(me.message);
    % Close PTB Screen
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(me);
    
    % ----------------------
    
end


end

