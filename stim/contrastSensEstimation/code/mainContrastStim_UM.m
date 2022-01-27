%mainContrastStim_UM  script to init NECSUS stimulus - contrast detection.
%   mainContrastStim_UM
%
%   Example
%   mainContrastStim_UM
%
%   See also

% Author: Bruno Direito (bruno.direito@uc.pt)
% Coimbra Institute for Biomedical Imaging and Translational Research, University of Coimbra.
% Created: 2022-01-27; Last Revision: 2022-01-27

%% INIT
% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

% clear all variables and commanda window.
clear all;
close all;
clc;

%% Set path
% --- addpath to required folders ---
addpath('Results');
addpath('Answers');

addpath(genpath('Utils'));

%% PRESETS (INFORMATION per RUN)
HASGLARE        = 1; % input('glare/noglare?:','s'); % glare setup

VIEWINGDISTANCE = 150;%  | 40 (debug)

%% PRESETS (PARTICIPANT AND STUDY)

% participant's information.
PARTICIPANTNAME = "Glaretest"; % e.g. sub-NECSUS-UC001%; 

% NECSUS Variables.
METHOD          = 'QUEST'; %'QUEST' | 'ConstantStimuli' | 'QUESTFSS'
SPATIALFREQ     = 10; % input('SF (3.5/10)?:','s'); % desired spatial frequency
BACKGROUNDLUM   = 20; % Luminance background required 20 cd/m2

%% DISPLAY PARAMETERS

% ::: SITE specific :::
% --- Change for UM RGB luminance scale --- %
pathToGreyData  = fullfile(pwd,'Utils','luminance','NecsusNolightGray-rgblum11-Dec-2018.mat');
% ::: SITE specific :::

% --- LCD monitor ---
lcd             = lcdInfo(VIEWINGDISTANCE, pathToGreyData);


%% STIMULUS PARAMETERS
% --- GABOR INFORMATION ---
gabor               = gaborInfo(SPATIALFREQ);
% --- Glare INFORMATION ---
glare               = glareInfo();
% --- init method struct ---
methodStruct        = methodInitialization(METHOD);

% -------- PTB init ---------
syncTrick(); % Run sync trick proposed by PTB dev.
% Screen('Preference', 'SkipSyncTests', 1);

% Get the screen numbers
ptb.screens         = Screen('Screens');

% Draw to the external screen if avaliable
% ::: SITE specific :::
% --- To be confirmed in UM setup --- %
ptb.screenNumber    = 1;
% ::: SITE specific :::

ptb.backgroundLum   = BACKGROUNDLUM;
ptb.hasGlare        = HASGLARE;

%% RUN stimuli
[responseMatrix, timesLog, model] =...
    runStim_UM(ptb, lcd, gabor, glare, methodStruct);

%% Results analysis

% --- Threshold estimation ---
[results]               = computeThreshold(responseMatrix);
% data regarding method.
results.method          = METHOD;
results.SPATIALFREQ     = SPATIALFREQ; 
results.HASGLARE        = HASGLARE; 
results.BACKGROUNDLUM   = BACKGROUNDLUM; 

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

