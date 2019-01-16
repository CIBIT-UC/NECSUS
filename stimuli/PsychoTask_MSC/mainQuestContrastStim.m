%% --------------------------------INIT-------------------------------------

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

clear all;
close all;
clc;

% --- addpath to required folders ---
addpath('Thresholds');
addpath('Results');

addpath(genpath('Utils'));

%% -------------------------------PRESETS-----------------------------------

PARTICIPANTNAME=input('Name:','s'); % participant's name

SPATIALFREQ=10; % input('SF (3.5/10)?:','s'); % desired spatial frequency
HASGLARE=1; % input('glare/noglare?:','s'); % glare setup
BACKGROUNDLUM=20; % Luminance background required 20 cd/m2

% --- Make a vector to record/store the response for each trial ---
respMatrix = [];

% keyboard "normalization" of Escape key
KbName('UnifyKeyNames');

% --- LCD monitor ---
lcd=lcdInfo();

% --- GABOR INFORMATION ---
gabor=gaborInfo(SPATIALFREQ);


%% ----------------------------INITIALIZE----------------------------------

% --- QUEST ---

% --- Quest threshold estimation ---
quest=initializationQuest();

% % Provide our prior knowledge to QuestCreate, and receive the data struct "q".
% tGuess=quest.estMean;
% tGuessSd=quest.estStd;

%q=QuestCreate(tGuess,tGuessSd,pThreshold,beta,delta,gamma, grain, dim);
quest.q=QuestCreate(quest.estMean,...
    quest.estStd,...
    quest.pThreshold,...
    quest.beta,...
    quest.delta,...
    quest.gamma,...
    quest.grain,...
    quest.dim);

% This adds a few ms per call to QuestUpdate, but otherwise the pdf will underflow after about 1000 trials.
quest.q.normalizePdf=1;

%% STIMULI presentation

% -------- PTB init ---------
syncTrick(); % Run sync trick proposed by PTB dev.

% Get the screen numbers
ptb.screens=Screen('Screens');

% Draw to the external screen if avaliable
ptb.screenNumber=max(ptb.screens);

ptb.backgroundLum=BACKGROUNDLUM;

runStim(ptb, lcd, gabor, quest);


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
fileName = sprintf('%s_%i_TestAnswers_%s',PARTICIPANTNAME,spatialFreq,sky);
fileNamePath = fullfile(pwd,'ResultsQUEST',[fileName '.mat']);
save(fileNamePath,'respMatrix', 't', 'sd');

% get and save thresholds
[T,NT] = getThresholdQUEST(respMatrix,fileName);
fileNamePath = fullfile(pwd,'ThresholdsQUEST',[fileName '_thresholds.mat']);
Thresholds=dataset(T,NT);
save(fileNamePath,'Thresholds');



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

