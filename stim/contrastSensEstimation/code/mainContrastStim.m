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

% participant's code
PARTICIPANTNAME='testBruno';%sub-NECSUS-UC001%; 

METHOD='QUEST'; %'QUEST' | 'ConstantStimuli' | 'QUESTFSS'??
VIEWINGDISTANCE=40; %150 | 40 (debug)
SPATIALFREQ=10; % input('SF (3.5/10)?:','s'); % desired spatial frequency
HASGLARE=0; % input('glare/noglare?:','s'); % glare setup
BACKGROUNDLUM=20; % Luminance background required 20 cd/m2

% MR scanner or LCD
%pathToGreyData=fullfile(pwd,'Utils','luminance','rgblumGRAY10-Mar-2016.mat');
pathToGreyData=fullfile(pwd,'Utils','luminance','NecsusNolightGray-rgblum11-Dec-2018.mat');

% --- Make a vector to record/store the response for each trial ---
respMatrix = [];

% keyboard "normalization" of Escape key
KbName('UnifyKeyNames');

% --- LCD monitor ---
lcd=lcdInfo(VIEWINGDISTANCE, pathToGreyData);

% --- GABOR INFORMATION ---
gabor=gaborInfo(SPATIALFREQ);


%% INITIALIZE

% --- init method struct ---
methodStruct=methodInitialization(METHOD);


%% STIMULI presentation

% -------- PTB init ---------
syncTrick(); % Run sync trick proposed by PTB dev.

% Get the screen numbers
ptb.screens=Screen('Screens');

% Draw to the external screen if avaliable
ptb.screenNumber=0;

ptb.backgroundLum=BACKGROUNDLUM;

%% RUN stimuli

[responseMatrix,timesLog]=runStim(ptb, lcd, gabor, methodStruct);

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

