function [logdata] = runStim(stimuli, scr, gabor)

% --- STIMULI PRESETS ----

% --- scr variable represents screen features. ---
% --- gabor variable represents the stimuli gabor features. ---


% % % Not pressed.
% % escapekeyPressed = 0;

% Allow (1) or not (0) responses during stimulation and fixation period
responsesDuringStim = 1;
responsesDuringFix = 1;

% Trick suggested by the PTB authors
syncTrick();

% Load gamma corrected scale for MR pojector
load(fullfile(pwd,'Utils','luminance','invertedCLUTMRscanner.mat'));


% Syncbox if DEBUG off.
if stimuli.syncbox
    syncBoxHandle=IOPort('OpenSerialPort', 'COM2', 'BaudRate=57600 DataBits=8 Parity=None StopBits=1 FlowControl=None');
    IOPort('Flush',syncBoxHandle);
end


try
    % Set "real time priority level"
    Priority(2)
    
    % luminance background required => 20 cd/m2
    % Transform luminance required to rgb input.
    rgbInput=luminanceToRgb(stimuli.backgroundLum);% bits resolution - 8;
    
        
    %  ---- START DISPLAY ----
    
    % SCREEN SETUP
    
    % Get the screen numbers
    screens = Screen('Screens');
    
    % Draw to the external screen if avaliable
    scr.screenNumber = max(screens);

    % Open an on screen window
    [window, windowRect] = Screen('OpenWindow',...
        scr.screenNumber,...
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
    scr.white = WhiteIndex(scr.screenNumber);
    
    % Get the size of the on screen window
    [scr.screenXpixels, scr.screenYpixels] = Screen('WindowSize', window);
    % screenXpixels=1024;
    % screenYpixels=768;
    
    % Fixation cross    
    % Get the centre coordinate of the window and create cross.
    [xCenter, yCenter]=RectCenter(windowRect);
    [fCross]=designFixationCross();
    
    HideCursor;
    
    % ---- PARAMETER SETUP ----
    
    % Gabor dimensions.
    [gaborDimPix]=getGaborDimPix(screen,...
        viewingDistance,...
        gaborDimDegree);
    
    % Sigma of Gaussian.
    sigma=gaborDimPix/5; 
    
    % Build a procedural gabor texture.
    gabortex=CreateProceduralGabor(window,...
        gaborDimPix,...
        gaborDimPix,...
        0,...
        [rgbInput rgbInput rgbInput 0.0]);
    
    
    % Stimuli presentation cycle.
    totalTrials=length(events);
    
    % Pre-allocate variables to store responses
    if responsesDuringStim
        % Create variable to store responses during stimulation periods
        logdata.responsesDuringStimulation = zeros(totalTrials,2);
        logdata.responsesDuringStimulation(:,1) = 5; % 5 = no answer
    end
    
    if responsesDuringFix
        % Create variable to store responses during fixation periods
        logdata.responsesDuringFixation = zeros(totalTrials,2);
        logdata.responsesDuringFixation(:,1) = 5; % 5 = no answer
    end
    
    
    switch iomethod
        
        % Keyboard answer.
        case 0 
            keyView=KbName('m'); % key to see
            keyNotView=KbName('z'); % key not see.
            
        % Lumina response box LU400 (A).
        case 1 
            response_box_handle = IOPort('OpenSerialPort','COM3');
            IOPort('Flush',response_box_handle);
            
            keyView = 50;
            keyNotView = 49;
    end
    
    %-----------------------------------------------------------------%
    %                      EXPERIMENTAL LOOP                          %
    %-----------------------------------------------------------------%
    
    
    for i = 1:totalTrials % experimental loop --> one interaction= stim+fix
        
        
        if i==1 %If it is the first trial
            
            Screen('FillRect',window,[rgbInput rgbInput rgbInput]);
            Screen('Flip',window);
            
            
            % syncbox is 'on' or 'off'?
            if syncbox
                [gotTrigger, logdata.triggerTimeStamp]=waitForTrigger(syncBoxHandle,1,1000);
                if gotTrigger
                    disp('Trigger OK! Starting stimulation...');
                else
                    disp('Absent trigger. Aborting...');
                    throw
                end
            else
                KbWait;
            end
            
            
            % Display fixation cross in the center of the screen and wait for
            % keyboard key press to start countdown (5 to 1 with 0.5 sec interval)
            Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
            Screen('Flip',window);% Flip to the screen
            
            % Present fixation cross for the pre-determined time
            waitUntil = GetSecs + parameters.block_isi;
            
            % Ensure that the first block (fixation) lasts until the end
            while GetSecs < waitUntil
                
                % Look for 'Esc' press
                [keyisdown, secs, keycode] = KbCheck;
                
                if keyisdown && keycode(escapekey)
                    
                    % Close PTB screen and connections
                    Screen('CloseAll');
                    IOPort('CloseAll');
                    pnet('closeall');
                    ShowCursor;
                    Priority(0);
                    
                    return
                    
                end
                
            end
        end
        
        
        %------------------------------------------------------%
        % if it is not the first block, start with stimulation %
        %------------------------------------------------------%
        
        % The contrast and spatial frequency values are retrivieved from
        % the protocols:
        
        contrast=events{i,2}; % contrast value
        
        desiredSF=events{i,4}; % spatial frequency desired
        
        % Get Spatial Frequency
        [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);
        
        %---------------------START DISPLAY------------------------------%
        
        % Display fixation cross in the center of the screen and wait for
        Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
        Screen('Flip',window);% Flip to the screen
        
        trial_duration=0;
        
        % Clean responses buffer - this means that the program saves the
        % first response but does not save following button presses within
        % the same block
        inputStim=0;
        
        
        %-------------- STIMULATION PART OF THE TRIAL (BLOCK)------------%
        
        t0=GetSecs;
        
        while trial_duration <= parameters.trial_duration
            
            
            % Draw the Gabor
            Screen('DrawTexture', window, gabortex, [], [], angle, [], [], ...
                [], [], kPsychDontDoRotation, [phase+180, SF, sigma, contrast, aspectratio, 0, 0, 0]);
            % Flip to the screen
            Screen('Flip', window);
            
            
            
            %-------- Look for button presses during stimulation-------- %
            
            
            % Escape %
            
            % Check if 'Escape' is pressed in keyboard
            [keyisdown, timestamp, keycode] = KbCheck;
            
            % If it was an 'Esc' press: abort program
            if keyisdown && keycode(escapekey)
                
                % Close PTB screen and connections
                Screen('CloseAll');
                IOPort('CloseAll');
                pnet('closeall');
                ShowCursor;
                Priority(0);
                
                % Launch window with warning of early end
                warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')
                
                return
                
            end
            
            % Responses %
            
            if debbugging == 0 && ... % keyboard
                    inputStim == 0 && ... % It is the first press
                    responsesDuringStim == 1 % Response during stimulation is allowed
                
                % Look for keyboard key press
                [keyisdown, timestamp, keycode] = KbCheck;
                if keyisdown == 1
                    key = find(keycode); % Get key identifier
                    inputStim = 1;
                    timeOfResponse = timestamp;
                    
                    if  key == keyView % Subject responded 'View'
                        
                        % Save time in logdata
                        logdata.responsesDuringStimulation(i,1) = 1;
                        logdata.responsesDuringStimulation(i,2) = timeOfResponse - t0;
                        
                        % Disable further button presses
                        inputStim = 1;
                        
                    elseif  key == keyNotView % Subject responded 'not view'
                        
                        logdata.responsesDuringStimulation(i,1) = 0;
                        % Save time in logdata
                        logdata.responsesDuringStimulation(i,2) = timeOfResponse - t0;
                        
                        % Disable further button presses
                        inputStim = 1;
                        
                    end
                    
                end
                
                
            elseif debbugging  == 1 && ... % Lumina response box
                    inputStim == 0 && ... % It is the first press
                    responsesDuringStim == 1 % Response during stimulation is allowed
                
                % Look for button press in response box
                [key, timestamp, errmsg] = IOPort('Read',response_box_handle);
                if ~isempty(key)
                    IOPort('Flush',response_box_handle);
                    timeOfResponse = timestamp;
                    
                    if  key == keyView % Subject responded 'View'
                        
                        % Save time in logdata
                        logdata.responsesDuringStimulation(i,1) = 1;
                        logdata.responsesDuringStimulation(i,2) = timeOfResponse - t0;
                        % Disable further button presses
                        inputStim = 1;
                        
                        
                    elseif  key == keyNotView % Subject responded 'not view'
                        
                        logdata.responsesDuringStimulation(i,1) = 0;
                        % Save time in logdata
                        logdata.responsesDuringStimulation(i,2) = timeOfResponse - t0;
                        
                        % Disable further button presses
                        inputStim = 1;
                        
                    end
                    
                end
                
            end
            
            % Trial Time Statements
            trial_duration = GetSecs - t0;
            
        end
        
        %---------------- FIXATION PART OF THE TRIAL (BLOCK)--------------%
        
        
        % Display fixation cross in the center of the screen and wait for
        Screen('DrawLines',window,CrossCoords,lineWidthPix,white,[xCenter yCenter]);
        Screen('Flip',window);% Flip to the screen
        
        % Clean responses buffer - this means that the program saves the
        % first response but not following button presses within the same
        % block
        inputFix = 0;
        
        
        % Ensure the fixation lasts until the end of the pre-determined
        % inter stimulus interval for the k-th block: 'event{k,3}'
        t0 = GetSecs;
        waitUntil = t0 + events{i,3};
        
        while GetSecs < waitUntil
            
            %-----------------------------------------%
            % Look for button presses during fixation %
            %-----------------------------------------%
            
            %--------%
            % Escape %
            %--------%
            % Check if 'Escape' is pressed in keyboard
            [keyisdown, timestamp, keycode] = KbCheck;
            
            
            % If it was an 'Esc' press: abort program
            if keyisdown && keycode(escapekey)
                
                % Close PTB screen and connections
                Screen('CloseAll');
                IOPort('CloseAll');
                pnet('closeall');
                ShowCursor;
                Priority(0);
                
                % Launch window with warning of early end
                warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')
                
                return
                
            end
            
            % Responses %
            
            if debbugging == 0 && ... % keyboard
                    inputFix == 0 && ... % It is the first press
                    responsesDuringFix == 1 % Response during stimulation is allowed
                
                % Look for keyboard key press
                [keyisdown, timestamp, keycode] = KbCheck;
                if keyisdown == 1
                    key = find(keycode); % Get key identifier
                    inputFix = 1;
                    timeOfResponse = timestamp;
                    
                    % Decode which was the response %
                    
                    if key == keyView % Subject responded 'View'
                        
                        logdata.responsesDuringFixation(i,1) = 1;
                        % Save time in logdata
                        logdata.responsesDuringFixation(i,2) = timeOfResponse - t0;
                        % Disable further button presses
                        inputFix = 1;
                        
                    elseif key == keyNotView  % Subject responded 'left'
                        
                        logdata.responsesDuringFixation(i,1) = 0;
                        % Save time in logdata
                        logdata.responsesDuringFixation(i,2) = timeOfResponse - t0;
                        % Disable further button presses
                        inputFix = 1;
                        
                    end
                    
                end
                
            elseif debbugging  == 1 && ... % Lumina response box
                    inputFix == 0 && ... % It is the first press
                    responsesDuringFix == 1 % Response during stimulation is allowed
                
                % Look for button press in response box
                [key, timestamp, errmsg] = IOPort('Read',response_box_handle);
                if ~isempty(key)
                    IOPort('Flush',response_box_handle);
                    timeOfResponse = timestamp;
                    
                    % Decode which was the response %
                    
                    if key == keyView % Subject responded 'View'
                        
                        logdata.responsesDuringFixation(i,1) = 1;
                        % Save time in logdata
                        logdata.responsesDuringFixation(i,2) = timeOfResponse - t0;
                        % Disable further button presses
                        inputFix = 1;
                        
                    elseif key == keyNotView  % Subject responded 'left'
                        
                        logdata.responsesDuringFixation(i,1) = 0;
                        % Save time in logdata
                        logdata.responsesDuringFixation(i,2) = timeOfResponse - t0;
                        % Disable further button presses
                        inputFix = 1;
                    end
                    
                end
                
            end
            
            
        end
        
    end % end of block (trial) loop
    
    % Close PTB Screen and connections
    Screen('CloseAll');
    IOPort('CloseAll');
    pnet('closeall');
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



