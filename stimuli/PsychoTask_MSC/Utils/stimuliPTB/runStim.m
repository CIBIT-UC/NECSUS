function [  ] = runStim( ptb, lcd, gabor, quest )
%RUNSTIM run stim based on preset variables

% load gamma-corrected CLUT (color look-up table)
load('.\Utils\luminance\invertedCLUT.mat');

try
    % --- PTB setup ---
    Priority(2); % Set "real time priority level".    
    [window,~]=Screen('OpenWindow', ptb.whichScreen); % Open PTB full-screen window.
    
    % MONITOR SETUP / Linearize monitor gamma
    linearCLUT=Screen('LoadNormalizedGammaTable',window,inverseGammaTable); % upload inverse gamma function to screen - linearize lum.
    normlzInput=luminanceToRgb(ptb.backgroundLum);
    
    % Define white.
    white=WhiteIndex(ptb.screenNumber); % required to display fixation cross
    
    % --- START DISPLAY ---
    
    % Open an on screen window
    [window, windowRect]=Screen('OpenWindow',...
        ptb.screenNumber,...
        [normlzInput,normlzInput,normlzInput],... % Background RGB values.
        [],[],[],[],0);
    
    % Get the size of the on screen window
    [lcd.screenXpixels, lcd.screenYpixels]=Screen('WindowSize', window);
    % Set the text size
    Screen('TextSize', window, 50);
    
    % Fixation cross
    fCross=designFixationCross(windowRect);
    
    HideCursor;
    
    % --- STIMULUS PARAMETER SETUP ---
    stim=stimulusDefinition(lcd, gabor, window);

    % Build a procedural gabor texture - PTB3
    gabor.gabortex = CreateProceduralGabor(window,...
        stim.gaborDimPix,...
        stim.gaborDimPix,...
        0,...
        [normlzInput,normlzInput,normlzInput,...
        0.0]);
   
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP
    %-----------------------------------------------------------------%
    
    % Stopping criteria var.
    sCrit = 0;
    
    for trial = 1:nTrials
        
        if ~sCrit
            
            quest=getNextQuestTrial(quest);
            
            % fprintf('Value of QUEST %f and of the last sample %f.\n',QuestMean(q),last);
            
            if trial==1
                
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
                    [], [], kPsychDontDoRotation, [phase+180, spatFreq, sigma, quest.contrastTrial, aspectratio, 0, 0, 0]);
                
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
                    respMatrix(trial,:) = [trial,quest.contrastTrial ,1];

                    respToBeMade = false;
                    % Update the pdf
                    response=1;
                    quest.q=QuestUpdate(quest.q,quest.contrastTrial,response); % Add the new data (actual test intensity and observer response) to the database.
                    
                elseif keyCode(keyNotView)
                    respMatrix(trial,:) = [trial,quest.contrastTrial ,0];
                    
                    respToBeMade = false;
                    % Update the pdf
                    response=0;
                    quest.q=QuestUpdate(quest.q,quest.contrastTrial,response); % Add the new data (actual test intensity and observer response) to the database.
                    
                end
            end
            
        end
        
        last=quest.contrastTrial;
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

