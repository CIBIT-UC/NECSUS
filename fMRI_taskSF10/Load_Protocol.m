function [logdata] = Load_Protocol(events,parameters)

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
pnet('closeall');
sca;

parameters.block_isi=8;

% input hack (for debugging)
debbugging=1; % 0-keyboard | 1-lumina response

% Keyboard "normalization" of Escape key
KbName('UnifyKeyNames');
escapekey = KbName('Escape');

% Turn on (1) or off (0) synchrony with scanner console
syncbox = 0;


% Allow (1) or not (0) responses during stimulation and fixation period
responsesDuringStim = 1;
responsesDuringFix = 1;

% This variable will become 1 if 'Esc' is pressed
key_esc_p = 0;

% Trick suggested by the PTB authors to avoid synchronization/calibration
% problems
figure(1)
plot(sin(0:0.1:3.14));
% Close figure with sin plot (PTB authors trick for synchronization)
close Figure 1



    try
        % Set "real time priority level"
        Priority(2)


        % --------------------------COLOR SETUP--------------------------------

        % Get the screen numbers
        screens = Screen('Screens');
        % Draw to the external screen if avaliable
        screenNumber = max(screens);
        
        
        % luminance background required => 20 cd/m2
        % bit resolution =>8
        % get background RGB from grey monitor luminance responce
        [lum_obtained,Rb,Gb,Bb]=lum_match_RGBfinder(20,8);
        % define black.
        
        % define white.
        white = WhiteIndex(screenNumber);  


        %  ----------------------- START DISPLAY ------------------------------

  
        % Open an on screen window
        [window, windowRect] = Screen('OpenWindow', screenNumber,[Rb,Gb,Bb]);
        % Get the size of the on screen window
        [screenXpixels, screenYpixels] = Screen('WindowSize', window);
%          screenXpixels=1024;
%          screenYpixels=768;
        % Set the text size
        HideCursor;
        
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

        screenHeight = 39.5; %15;%25.9; % Screen height (cm)
        screenWidth = 70; %20; % Screen width (cm)
        viewingDistance = 156.5; % Viewing Distance (cm)
        gaborDimDegree =12; %750; % Dimension of the region where will draw the Gabor in pixels
        phase=0; % spatial phase
        angle = 0; %the optional orientation angle in degrees (0-360)
        aspectratio = 1.0; % Defines the aspect ratio of the hull of the gabor
        
        
        % get Gabor dimensions
        [gaborDimPix] = getGaborDimPix(screenHeight,screenYpixels,viewingDistance,gaborDimDegree);
        sigma = gaborDimPix /5; % Sigma of Gaussian
        % Build a procedural gabor texture
        gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[0.5573 0.5573 0.5573 0.0]);
        
        % Stimuli presentation cycle
        trial = length(events);
    
        % pre-allocate variables to store responses
        if responsesDuringStim
            % Create variable to store responses during stimulation periods
            logdata.responsesDuringStimulation = zeros(trial,2);
            logdata.responsesDuringStimulation(:,1) = 5; % 5 = no answer
        end

        if responsesDuringFix
            % Create variable to store responses during fixation periods
            logdata.responsesDuringFixation = zeros(trial,2);
            logdata.responsesDuringFixation(:,1) = 5; % 5 = no answer
        end
        
        
    % syncbox
    if syncbox
        syncbox_handle = IOPort('OpenSerialPort', 'COM2', 'BaudRate=57600 DataBits=8 Parity=None StopBits=1 FlowControl=None');
        IOPort('Flush',syncbox_handle);
    end
    
    switch debbugging
        
        case 0 % keyboard answer
            
            keyView=KbName('m'); % key to see
            keyNotView=KbName('z'); % key not se
            
        case 1 % lumina response box LU400 (A)
            
            response_box_handle = IOPort('OpenSerialPort','COM3');
            IOPort('Flush',response_box_handle);
            
            keyView = 50;
            keyNotView = 49;
            
    end
    
      %-----------------------------------------------------------------%
      %                      EXPERIMENTAL LOOP                          %
      %-----------------------------------------------------------------%


    for i = 1:trial % experimental loop --> one interaction= stim+fix
    
        
            if i==1 %If it is the first trial 
              
                Screen('FillRect',window,[Rb Gb Bb]);
                Screen('Flip',window);
                
                
                % syncbox is 'on' or 'off'?
                if syncbox
                    [gotTrigger, logdata.triggerTimeStamp] = waitForTrigger(syncbox_handle,1,1000);
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



