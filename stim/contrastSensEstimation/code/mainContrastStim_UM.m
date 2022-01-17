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
PARTICIPANTNAME="Glaretest";%TODO%; % e.g. sub-NECSUS-UC001%; 
VIEWINGDISTANCE=150;% | 40 (debug)


METHOD='QUEST'; %'QUEST' | 'ConstantStimuli' | 'QUESTFSS'??
SPATIALFREQ=10; % input('SF (3.5/10)?:','s'); % desired spatial frequency
HASGLARE=1; % input('glare/noglare?:','s'); % glare setup
BACKGROUNDLUM=20; % Luminance background required 20 cd/m2

% MR scanner or LCD

% ::: TODO :::
% --- Change for UM RGB luminance scale --- %
pathToGreyData=fullfile(pwd,'Utils','luminance','NecsusNolightGray-rgblum11-Dec-2018.mat');
% ::: TODO :::


% --- Make a vector to record/store the response for each trial ---
respMatrix = [];

% keyboard "normalization" of Escape key
KbName('UnifyKeyNames');

% --- LCD monitor ---
lcd=lcdInfo(VIEWINGDISTANCE, pathToGreyData);

% --- GABOR INFORMATION ---
gabor=gaborInfo(SPATIALFREQ);

% --- Glare INFORMATION ---
glare=glareInfo();


%% INITIALIZE

% --- init method struct ---
methodStruct=methodInitialization(METHOD);


%% STIMULI presentation

% -------- PTB init ---------
syncTrick(); % Run sync trick proposed by PTB dev.
% Screen('Preference', 'SkipSyncTests', 1);

% Get the screen numbers
ptb.screens=Screen('Screens');

% Draw to the external screen if avaliable
% ::: TODO :::
% --- To be confirmed in UM setup --- %
ptb.screenNumber=2;
% ::: TODO :::

ptb.backgroundLum=BACKGROUNDLUM;

ptb.hasGlare=HASGLARE;

%% RUN stimuli

[responseMatrix,timesLog,model]=runStim_UM(ptb, lcd, gabor, glare, methodStruct);

%% Results analysis

% --- Threshold estimation ---
[results]=computeThreshold(responseMatrix);
% data regarding method.
results.method=METHOD;
results.SPATIALFREQ=SPATIALFREQ; 
results.HASGLARE=HASGLARE; 
results.BACKGROUNDLUM=BACKGROUNDLUM; 

%%
% figure, plot(1:numel(model.pdf), model.pdf);
% 
% %%
% 
% figure, plot(model.i);
%%
% % % 
% % % betaEstimate=QuestBetaAnalysis(model);
% % % 
% % % %%
% % % intensityT=QuestQuantile(model,.5);
% % % intensityNT=QuestQuantile(model,.75);
% % % 
% % % sd=QuestSd(model);
% % % 
% % % %% Save data
% % % 
% % % % % save responseMatrix
% % % responseFileName=sprintf('%s_%s_%s_%i_answers',PARTICIPANTNAME,string(SPATIALFREQ),METHOD,HASGLARE);
% % % responseFilePathName=fullfile(pwd,'Answers',[responseFileName '.mat']);
% % % save(responseFilePathName,'responseMatrix','timesLog', 'model');
% % % % 
% % % % % Save Results.
% % % resultsFileName=sprintf('%s_%s_%s_%i_results',PARTICIPANTNAME,string(SPATIALFREQ),METHOD,HASGLARE);
% % % resultsFilePathName=fullfile(pwd,'Results',[resultsFileName '.mat']);
% % % save(resultsFilePathName,'results', 'intensityNT', 'intensityT', 'model');
% % % 
% % % %% 

