function [ response, time ] = runStim( ptb, lcd, gabor, methodStruct )
%RUNSTIM run stim based on preset variables

% load gamma-corrected CLUT (color look-up table) - variable
% "invertedCLUT".

load(fullfile(pwd,'Utils','luminance','invertedCLUT.mat'));

try
    
    % Transform luminance required to rgb input.
    rgbInput=luminanceToRgb(ptb.backgroundLum) 
    
    % --- PTB setup ---
    Priority(2); % Set "real time priority level".
    %[window,~]=Screen('OpenWindow', ptb.screenNumber); % Open PTB full-screen window.
    

    
    % --- START DISPLAY ---
    
    % Open a screen window.
    [window, windowRect]=Screen('OpenWindow',...
        ptb.screenNumber,...
        [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)],... % Background RGB values.
        [],...
        [],...
        [],...
        [],...
        0);
    
    % MONITOR SETUP / Linearize monitor gamma.
    % upload inverse gamma function to screen - linearize lum.
    originalCLUT=Screen('LoadNormalizedGammaTable',...
        window,...
        repmat(invertedCLUT, [3,1])' ); 
    
    
    % Define white.
    white=WhiteIndex(ptb.screenNumber); % required to display fixation cross
    % Define center of the screen.
    [sCenter.xCenter, sCenter.yCenter]=RectCenter(windowRect);
    
    % Get the size of the on screen window.
    [lcd.screenXpixels, lcd.screenYpixels]=Screen('WindowSize', window);
    
    % Set the text size.
    Screen('TextSize', window, 50);
    
    % Fixation cross.
    fCross=designFixationCross();
    
    % Hide cursor.
    HideCursor;
    
    % --- STIMULUS PARAMETER SETUP ---
    stim=stimulusDefinition(lcd, gabor, window);
    
    % Build a procedural gabor texture - PTB3
    gabor.gabortex = CreateProceduralGabor(window,...
        stim.gaborDimPix,...
        stim.gaborDimPix,...
        0,...
        [rgbInput,rgbInput,rgbInput,0.0]);
    
    
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP
    %-----------------------------------------------------------------%
    
    
    % --- Stimuli presentation ----
    
    % Display fixation cross in the center of the screen and wait for
    % keyboard key press to start countdown (5 to 1 with 0.5
    % sec interval).
    DrawFormattedText(window,'press any key.','center','center',white);
    Screen('Flip',window); % Flip to the screen.
    KbStrokeWait;
    
    % Present countdown.
    for countDownIdx = 1:numel(stim.countDownVals)
        % Display number countDown.
        DrawFormattedText(window,...
            stim.countDownVals{countDownIdx},...
            'center',...
            'center',...
            white);
        Screen('Flip',window); % Flip to the screen.
        WaitSecs(1);
    end
    
    % --- Main loop ---
    
    while ~methodStruct.isComplete
        
        % Get next contrast based on the method selected.
        methodStruct=getNextTrial(methodStruct);
        
        % Present fixation cross.
        
        % Chrono.
        time.fCrossPres(methodStruct.trialIdx)=GetSecs;
        
        % Change the blend function to draw an antialiased fixation
        % point in the centre of the screen.
        Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

        % Draw the fixation cross.
        Screen('DrawLines',...
            window,...
            fCross.CrossCoords,...
            fCross.lineWidthPix,...
            white,...
            [sCenter.xCenter sCenter.yCenter]);
        
        % Flip to the screen.
        Screen('Flip', window);
        
        % Wait until fixation cross period ends.
        WaitSecs( (time.fCrossPres(methodStruct.trialIdx)+stim.isiDurationSecs) - GetSecs );
                
        
        % Present Gabor.
        % Chrono.
        time.stimPres(methodStruct.trialIdx)=GetSecs;
       
        % Set the right blend function for drawing the gabors.
        Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');

        % Draw the Gabor.
        Screen('DrawTexture', window, gabor.gabortex, [], [], gabor.angle, [], [], ...
            [], [], kPsychDontDoRotation, [gabor.phase+180, gabor.desiredSF, stim.sigma, methodStruct.contrastTrial, gabor.aspectratio, 0, 0, 0]);
       
        % Flip to the screen.
        Screen('Flip', window);
        
        % Wait until stim presentation period ends.
        WaitSecs( (time.fCrossPres(methodStruct.trialIdx)+stim.stimDurationSecs) - GetSecs );
             
        % Now we wait for a keyboard button signaling the observers response.
        % The 'm' key signals a positive response
        %   (the participaant saw the stimuli)
        % and the 'z' key a negative response
        %   (the participant was not able to see the stimuli).
        % You can also press escape if you want to exit the program.
             
        hasResponse=false;
        
        while ~hasResponse
            % Check key pressed.
            [~,time.respkeyPressed(methodStruct.trialIdx),keyCode] = KbCheck;
            
            % If participant saw gabor, then.
            if keyCode(stim.keyView)
                
                hasResponse = true;
                % Save results.
                response(methodStruct.trialIdx,:) = [methodStruct.trialIdx,...
                    methodStruct.contrastTrial,...
                    1];
                
                % Update estimation models.
                methodStruct=updateEstimate(methodStruct,1); 
               
            % Else, if participant did not saw gabor, then.  
            elseif keyCode(stim.keyNotView)
                hasResponse = true;
                
                % Save results.
                response(methodStruct.trialIdx,:) = [methodStruct.trialIdx,...
                    methodStruct.contrastTrial,...
                    0];
                % Update estimation models.
             	methodStruct=updateEstimate(methodStruct,0); 
                
            % Exit program if escape key is pressed.
            elseif keyCode(stim.escapekey) 
                hasResponse = true;
                methodStruct.isComplete=1;
                fprintf('The participant pressed the escape key.\n');
                break;
                
            end
        end
        
        methodStruct.last=methodStruct.contrastTrial;
        % fprintf('Value of QUEST %f and of the last sample %f.\n',QuestMean(q),last);
    end
    
    fprintf('The experiment is finished.\n');
    fprintf('Closing setup.\n');
    % Restore originalCLUT.
    Screen('LoadNormalizedGammatable', window, originalCLUT);
    % Close PTB Screen.
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    
    
    
catch me
    warning(me.message);
    % Restore originalCLUT.
    Screen('LoadNormalizedGammatable', window, originalCLUT);
    % Close PTB Screen.
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(me);
    
end


end

