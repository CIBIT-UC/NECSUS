%% Load data
load('runStim_dataTest.mat');

%%
[methodStruct] = initializationConstStim();

m%%
Screen('Preference', 'SkipSyncTests', 1);
% ptb.screenNumber=0;

[responseMatrix,timesLog]=runStim(ptb, lcd, gabor, methodStruct);


