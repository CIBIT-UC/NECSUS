%% Load data
load('runStim_dataTest.mat');

%%
[methodStruct] = initializationConstStim();

%%
Screen('Preference', 'SkipSyncTests', 1);
% ptb.screenNumber=0; 

[responseMatrix,timesLog]=runStim(ptb, lcd, gabor, methodStruct);


%% WTF
 % Draw the Gabor.
    Screen('DrawTexture',...
        wScreen,...
        gabortex, [], [], gabor.angle, [], [], ...
        [], [], kPsychDontDoRotation, [gabor.phase+180, gabor.desiredSF, stim.sigma, methodStruct.contrastTrial, gabor.aspectratio, 0, 0, 0]);

    % Flip to the screen.
    Screen('Flip', wScreen);m
  %
    
    
    gabortex = CreateProceduralGabor(wScreen, stim.gaborDimPix,...
        stim.gaborDimPix, 0,[0.5573 0.5573 0.5573 0.0]);
      
    Screen('DrawTextures', wScreen, gabortex, [], [], gabor.angle, [], [], ...
            [], [], kPsychDontDoRotation, [gabor.phase+180, gabor.desiredSF,...
            stim.sigma, 10, gabor.aspectratio, 0, 0, 0]');
        

         % Flip to the screen.
        Screen('Flip', wScreen);
        
