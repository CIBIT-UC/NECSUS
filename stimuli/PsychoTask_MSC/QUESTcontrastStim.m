%% --------------------------------INIT-------------------------------------

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

clear all;
close all;
clc;

%% -------------------------------PRESETS-----------------------------------

% --- addpath to required folders ---
addpath('Thresholds');
addpath('Results');
addpath(genpath('Common'));

nSubj='testbruno'; % input('Name:','s');   % participant's name
spatFreq=10;                % input('SF (3.5/10)?:','s'); % desired spatial frequency
sky='noglare';               % input('glare/noglare?:','s'); % glare setup

% keyboard "normalization" of Escape key
KbName('UnifyKeyNames');

% --- Quest threshold estimation ---
getSecsFunction='GetSecs';

estMean=6.2980;
estStd=4.3992;

nTrials=30;

% Make a vector to record/store the response for each trial
respMatrix = zeros(nTrials,3);

% --- Stimuli init ---

%-------------------------GABOR INFORMATION---------------------------%

screenHeight=25.9; % Screen height (cm)34.7; %
screenWidth=54.6; % Screen width (cm)
viewingDistance=40; %150; % Viewing Distance (cm)
gaborDimDegree=12; %750; % Dimension of the region where will draw the Gabor in pixels

phase=0; % spatial phase
angle=0; %the optional orientation angle in degrees (0-360)
aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
desiredSF=spatFreq; % Desired Spatial Frequency in cpd.


%% ----------------------------INITIALIZE----------------------------------

% --- QUEST init ---

%animate=input('Do you want so see a live animated plot of the shrinking pdf? (y/n) [y]:','s');
%animate=~streq(lower(animate),'n');
animate=1;

% Provide our prior knowledge to QuestCreate, and receive the data struct "q".
tGuess=estMean;
tGuessSd=estStd;

pThreshold=0.82;
beta=3.5;
delta=0.05;
gamma=0.5;
grain=0.05;
dim=250;
plotIt=1;

%q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma);
q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma,grain,dim);

q.normalizePdf=1; % This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.

%% -------- PTB init ---------

% Trick suggested by the PTB authors to avoid synchronization/calibration
% problems
figure(1);
plot(sin(0:0.1:3.14));
% Close figure with sin plot (PTB authors trick for synchronization)
close Figure 1

% Get the screen numbers
screens=Screen('Screens');

% Draw to the external screen if avaliable
screenNumber=max(screens);


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
    
    % define white.
    white=WhiteIndex(screenNumber); % required to display fixation cross
    
    %  ----------------------- START DISPLAY ------------------------------
    
    % Open an on screen window
    [window, windowRect]=Screen('OpenWindow', screenNumber,[Rb,Gb,Bb],[], [], [], [], 0);
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels]=Screen('WindowSize', window);
    % Set the text size
    Screen('TextSize', window, 50);
    
    
    %------------------------ PARAMETER SETUP------------------------------
    
    % --- GABOR INFO ---
    
    % Get Spatial Frequency (cycles Per Pixel) and  gabor dimensions
    [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF);
    [gaborDimPix] = getGaborDimPix(screenWidth,screenXpixels,viewingDistance,gaborDimDegree);
    
    % Sigma of Gaussian
    sigma = gaborDimPix /7;
    
    % Build a procedural gabor texture
    gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, 0,[0.5573 0.5573 0.5573 0.0]);
    
    
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
    
    for trial = 1:nTrials
        
        % Get the Gabor contrast
        % tTest=QuestQuantile(q);
        tTest=QuestMean(q)		% Recommended by King-Smith et al. (1994)
        % tTest=QuestMode(q);		% Recommended by Watson & Pelli (1983)
        
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
                q=QuestUpdate(q,tTest,response); % Add the new datum (actual test intensity and observer response) to the database.
                
%                 if animate
%                     figure(2)
%                     plot(q.x+q.tGuess,q.pdf)
%                     %xlim(xl);
%                     title('Posterior PDF');
%                     hold on
%                 end
                
            elseif keyCode(keyNotView)
                respMatrix(trial,1) = trial;
                respMatrix(trial,2) = tTest;
                respMatrix(trial,3) = 0;
                respToBeMade = false;
                % Update the pdf
                response=0;
                q=QuestUpdate(q,tTest,response);
                
%                 if animate
%                     figure(2)
%                     plot(q.x+q.tGuess,q.pdf)
%                     %xlim(xl);
%                     title('Posterior PDF');
%                     hold on
%                 end

            end
        end
        
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


%%
%
%
%
% %% run stimuli loop - n trials.
% % On each trial we ask Quest to recommend an intensity and we call QuestUpdate to save the result in q.
%
% wrongRight={'n','y'};
% timeZero=eval(getSecsFunction);
% for k=1:nTrials
%     % Get recommended level.  Choose your favorite algorithm.
%     tTest=QuestQuantile(q);	% Recommended by Pelli (1987), and still our favorite.
%     % 	tTest=QuestMean(q);		% Recommended by King-Smith et al. (1994)
%     % 	tTest=QuestMode(q);		% Recommended by Watson & Pelli (1983)
%
%     % We are free to test any intensity we like, not necessarily what Quest suggested.
%     % 	tTest=min(-0.05,max(-3,tTest)); % Restrict to range of log contrasts that our equipment can produce.
%
%     % Simulate a trial
%     timeSplit=eval(getSecsFunction); % Omit simulation and printing from the timing measurements.
%     if animate
%         figure(1);
%         response=QuestSimulate(q,tTest,tActual,2);
%         title('Actual psychometric function, and the points tested.')
%         xl=xlim;
%     else
%         response=QuestSimulate(q,tTest,tActual);
%     end
%     fprintf('Trial %3d at %5.2f is %s\n',k,tTest,char(wrongRight(response+1)));
%     timeZero=timeZero+eval(getSecsFunction)-timeSplit;
%
%     % Update the pdf
%     q=QuestUpdate(q,tTest,response); % Add the new datum (actual test intensity and observer response) to the database.
%     if animate
%         figure(2)
%         plot(q.x+q.tGuess,q.pdf)
%         xlim(xl);
%         title('Posterior PDF');
%         hold on
%     end
% end



%% --- Results eval ---
% Print results of timing.
% % % fprintf('%.0f ms/trial\n',1000*(eval(getSecsFunction)-timeZero)/nTrials);

% Ask Quest for the final estimate of threshold.
t=QuestMean(q);		% Recommended by Pelli (1989) and King-Smith et al. (1994). Still our favorite.
sd=QuestSd(q);
fprintf('Final threshold estimate (mean+-sd) is %.2f +- %.2f\n',t,sd);
t=QuestMode(q);	% Similar and preferable to the maximum likelihood recommended by Watson & Pelli (1983).
fprintf('Mode threshold estimate is %4.2f\n',t);
% % % fprintf('\nYou set the true threshold to %.2f.\n',tActual);
fprintf('Quest knew only your guess: %.2f +- %.2f.\n',tGuess,tGuessSd);



%----------------------------------------------------------------------%
%                        GET AND SAVE DATA
%----------------------------------------------------------------------%

% save answers subjects
fileName = sprintf('%s_%i_TestAnswers_%s',nSubj,spatFreq,sky);
fileNamePath = fullfile(pwd,'Results',[fileName '.mat']);
save(fileNamePath,'respMatrix', 't', 'sd');

% % % % get and save thresholds
% % % [T,NT] = getThreshold(respMatrix,numRepeats,fileName);
% % % fileNamePath = fullfile(pwd,'Thresholds',[fileName '_thresholds.mat']);
% % % Thresholds=dataset(T,NT);
% % % save(fileNamePath,'Thresholds');



% % % %%
% % % figure(1),
% % % 
% % % plot(q.intensity(1:nTrials) , q.response(1:nTrials), 'og')
% % % 
% % % plot(q.x2 , q.p2, 'b', ...
% % %        t(positive) , interp1(q.x2,q.p2,t(positive)), pcol, ...
% % %        t(negative) , interp1(q.x2,q.p2,t(negative)), 'or')
% % % 
% % % plot(q.x2 , q.p2, 'b', ...
% % %        t(positive) , interp1(q.x2,q.p2,t(positive)), pcol, ...
% % %        t(negative) , interp1(q.x2,q.p2,t(negative)), 'or', ...
% % %        tActual, interp1(q.x2 + tActual,q.p2,tActual), 'x', ...
% % %        tc + tActual, interp1(q.x2,q.p2,tc), col{response + 1});

