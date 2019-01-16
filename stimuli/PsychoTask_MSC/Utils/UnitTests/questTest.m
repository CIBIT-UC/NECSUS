
clear all
close all


%% --- QUEST ---

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


%% get next trial
getNextQuestTrial(quest)

%% update algorithm


% -----------------TODO---------------------
updateQuestEstimate(quest, contrastTrial, response)






