function [ response, time, model] = runStim( ptb, lcd, gabor, methodStruct )
%RUNSTIM run stim based on preset variables

% suppress chars on command window during stim.
ListenChar(2);

% load gamma-corrected CLUT (color look-up table) - variable
% "invertedCLUT".

load(fullfile(pwd,'Utils','luminance','invertedCLUT.mat'));

% Transform luminance required to rgb input.
rgbInput=luminanceToRgb(ptb.backgroundLum, lcd.pathToGreyData);% bits resolution - 8;

% --- PTB setup ---
Priority(2); % Set "real time priority level".
%[window,~]=Screen('OpenWindow', ptb.screenNumber); % Open PTB full-screen window.

%%%%%%%%% Be careful.%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1);

% Open a screen window.
[wScreen, windowRect]=Screen('OpenWindow',...
    ptb.screenNumber,...
    [round(rgbInput*255),round(rgbInput*255),round(rgbInput*255)],... % Background RGB values.
    [],...
    [],...
    [],...
    [],...
    0);

   %%%%%%%%% Be careful.%%%%%%%%%%
    Screen('Preference', 'SkipSyncTests', 1);


% --- START DISPLAY ---
try
    % MONITOR SETUP / Linearize monitor gamma.
    % upload inverse gamma function to screen - linearize lum.
    originalCLUT=Screen('LoadNormalizedGammaTable',...
        wScreen,...
        repmat(invertedCLUT, [3,1])' );
    
     % Screen debug.
    save('debug.mat','originalCLUT')
    
    
    % Define white.
    white=WhiteIndex(ptb.screenNumber); % required to display fixation cross
    % Define center of the screen.
    [sCenter.xCenter, sCenter.yCenter]=RectCenter(windowRect);
    
    % Get the size of the on screen window.
    [lcd.screenXpixels, lcd.screenYpixels]=Screen('WindowSize', wScreen);
    
    % Set the text size.
    Screen('TextSize', wScreen, 50);
    
    % Fixation cross.
    fCross=designFixationCross();
    
    % Hide cursor.
    HideCursor;
    
    % --- STIMULUS PARAMETER SETUP ---
    stim=stimulusDefinition(lcd, gabor, wScreen);
    
    disableNorm = [];
    preContrastMultiplier = [];
    
    % Build a procedural gabor texture - PTB3
    gabortex = CreateProceduralGabor(wScreen,...
        stim.gaborDimPix,...
        stim.gaborDimPix,...
        [],...
        [rgbInput,rgbInput,rgbInput,0.0],...
        disableNorm,...
        preContrastMultiplier);
    
    
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP
    %-----------------------------------------------------------------%
    
    
    % --- Stimuli presentation ----
    
    % Display fixation cross in the center of the screen and wait for
    % keyboard key press to start countdown (5 to 1 with 0.5
    % sec interval).
    DrawFormattedText(wScreen,...
        'Carregue em qualquer tecla para iniciar.',...
        'center',...
        'center',...
        white);
    Screen('Flip',wScreen); % Flip to the screen.
    KbStrokeWait;
    
    % Present countdown.
    for countDownIdx = 1:numel(stim.countDownVals)
        % Display number countDown.
        DrawFormattedText(wScreen,...
            stim.countDownVals{countDownIdx},...
            'center',...
            'center',...
            white);
        Screen('Flip',wScreen); % Flip to the screen.
        WaitSecs(1);
    end
    
    % --- Main loop ---
    
    time.start=GetSecs;
    trialIdx=0;
    
    while ~methodStruct.isComplete
        trialIdx=trialIdx+1;
        
        % Get next contrast based on the method selected.
        methodStruct=getNextTrial(methodStruct, trialIdx);
        
        fprintf('next trial contrast: %f. \n', methodStruct.contrastTrial)
        
        % Present fixation cross.
        
        % Chrono.
        time.fCrossPres(trialIdx)=GetSecs-time.start;
        
        % Change the blend function to draw an antialiased fixation
        % point in the centre of the screen.
        Screen('BlendFunction', wScreen, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        
        % Draw the fixation cross.
        Screen('DrawLines',...
            wScreen,...
            fCross.CrossCoords,...
            fCross.lineWidthPix,...
            white,...
            [sCenter.xCenter sCenter.yCenter]);
        
        % Flip to the screen.
        Screen('Flip', wScreen);
        
        % Wait until fixation cross period ends.
        WaitSecs( (time.fCrossPres(trialIdx)+stim.isiDurationSecs) - (GetSecs-time.start) );
        
        
        % Present Gabor.
        % Chrono.
        time.stimPres(trialIdx)=GetSecs-time.start;
        
        % Set the right blend function for drawing the gabors.
        Screen('BlendFunction', wScreen, 'GL_ONE', 'GL_ZERO');
        
        % Draw the Gabor.
        Screen('DrawTextures', wScreen, gabortex, [], [], gabor.angle, [], [], ...
            [], [], kPsychDontDoRotation, [gabor.phase+180, stim.spatFreq, stim.sigma, methodStruct.contrastTrial, gabor.aspectratio, 0, 0, 0]');
        
        % Flip to the screen.
        Screen('Flip', wScreen);
        
        % Wait until stim presentation period ends.
        WaitSecs( (time.stimPres(trialIdx)+stim.stimDurationSecs) - (GetSecs-time.start) );
        
        % Draw the fixation cross.
        Screen('DrawLines',...
            wScreen,...
            fCross.CrossCoords,...
            fCross.lineWidthPix,...
            white,...
            [sCenter.xCenter sCenter.yCenter]);
        
        % Flip to the screen.
        Screen('Flip', wScreen);
        
        % Now we wait for a keyboard button signaling the observers response.
        % The 'm' key signals a positive response
        %   (the participaant saw the stimuli)
        % and the 'z' key a negative response
        %   (the participant was not able to see the stimuli).
        % You can also press escape if you want to exit the program.
        
        hasResponse=false;
        
        while ~hasResponse
            % Check key pressed.
            [~,chronoKey,keyCode] = KbCheck;
            % Time stamp of the answer.
            time.respkeyPressed(trialIdx)=chronoKey-time.start;
            % If participant saw gabor, then.
            if keyCode(stim.keyView)
                
                hasResponse = true;
                % Save results.
                response(trialIdx,:) = [trialIdx,...
                    methodStruct.contrastTrial,...
                    1];
                
                % Update estimation models.
                methodStruct=updateEstimate(methodStruct,1);
                
                % Else, if participant did not saw gabor, then.
            elseif keyCode(stim.keyNotView)
                hasResponse = true;
                
                % Save results.
                response(trialIdx,:) = [trialIdx,...
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
    
    time.finished=GetSecs-time.start;
    
    fprintf('The experiment is finished.\n');
    fprintf('Closing setup.\n');
    
    
    % Display fixation cross in the center of the screen and wait for
    % keyboard key press to start countdown (5 to 1 with 0.5
    % sec interval).
    DrawFormattedText(wScreen,...
        'Finished. Processing results.',...
        'center',...
        'center',...
        white);
    Screen('Flip',wScreen); % Flip to the screen.
    
    pause(1);
    
    model=methodStruct.q;
    
    % Restore originalCLUT.
    load('debug.mat')
    Screen('LoadNormalizedGammatable', wScreen, originalCLUT);

    % Close PTB Screen.
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    
    % suppress chars on command window during stim.
    ListenChar(0);

    
    
catch me
    warning(me.message);
    
    % Restore originalCLUT.
    load('debug.mat')
    Screen('LoadNormalizedGammatable', wScreen, originalCLUT);

    % Close PTB Screen.
    Screen('CloseAll');
    ShowCursor;
    Priority(0);
    rethrow(me);
    
    % suppress chars on command window during stim.
    ListenChar(0);

    
end


end

