%% INIT

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

clear all;
close all;
clc;

% --- addpath to required folders ---
addpath('Results');
addpath('Answers');

addpath(genpath('Utils'));

%% PRESETS

PARTICIPANTNAME=input('Participant Code:','s'); % participant's code

METHOD='QUEST'; %'QUEST' | 'ConstantStimuli' | 'QUESTFSS'??
VIEWINGDISTANCE=150; %150 | 40 (debug)
SPATIALFREQ=10; % input('SF (3.5/10)?:','s'); % desired spatial frequency
HASGLARE=0; % input('glare/noglare?:','s'); % glare setup
BACKGROUNDLUM=20; % Luminance background required 20 cd/m2

% --- Make a vector to record/store the response for each trial ---
respMatrix = [];

% keyboard "normalization" of Escape key
KbName('UnifyKeyNames');

% --- LCD monitor ---
lcd=lcdInfo(VIEWINGDISTANCE);

% --- GABOR INFORMATION ---
gabor=gaborInfo(SPATIALFREQ);

% --- RESPONSE BOX at MRScanner
S.RSPBOX=1;

%% INITIALIZE

% --- init method struct ---
methodStruct=methodInitialization(METHOD);

%% --- Open COM port for the Response Box
if S.RSPBOX
    S.response_box_handle = IOPort('OpenSerialPort','COM3');
    IOPort('Purge',S.response_box_handle);
end


%% STIMULI presentation

% -------- PTB init ---------
syncTrick(); % Run sync trick proposed by PTB dev.

% Get the screen numbers
ptb.screens=Screen('Screens');

% Draw to the external screen if avaliable
ptb.screenNumber=2;% max(ptb.screens);

ptb.backgroundLum=BACKGROUNDLUM;

%% RUN stimuli

[responseMatrix,timesLog]=runStimMR(ptb, lcd, gabor, methodStruct, S);

%% Results analysis

% --- Threshold estimation ---
[results]=computeThreshold(responseMatrix);
% data regarding method.
results.method=METHOD;
results.SPATIALFREQ=SPATIALFREQ; 
results.HASGLARE=HASGLARE; 
results.BACKGROUNDLUM=BACKGROUNDLUM; 

%% Save data

% save responseMatrix
responseFileName=sprintf('%s_%s_%s_%i_answers',PARTICIPANTNAME,string(SPATIALFREQ),METHOD,HASGLARE);
responseFilePathName=fullfile(pwd,'Answers',[responseFileName '.mat']);
save(responseFilePathName,'responseMatrix','timesLog');

% Save Results.
resultsFileName=sprintf('%s_%s_%s_%i_results',PARTICIPANTNAME,string(SPATIALFREQ),METHOD,HASGLARE);
resultsFilePathName=fullfile(pwd,'Results',[resultsFileName '.mat']);
save(resultsFilePathName,'results');

