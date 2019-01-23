function [ questStruct ] = getNextQuestTrial( questStruct )
%GETNEXTQUESTTRIAL Summary of this function goes here
%   Detailed explanation goes here


% Prob function mean and std.
t=QuestMean(questStruct.q);
sd=QuestSd(questStruct.q);

fprintf('Value of QUEST mean %f and sd %f.\n',t,sd);

% Get the Gabor contrast
% tTest=QuestQuantile(q);
% tTest=QuestMean(q)		% Recommended by King-Smith et al. (1994)
% tTest=QuestMode(q);		% Recommended by Watson & Pelli (1983)

[~,sortdIdxs]=sort( abs( t-questStruct.CsfScale ) );
idx=sortdIdxs(1);

if questStruct.CsfScale(sortdIdxs(1))==questStruct.last
    idx=sortdIdxs(2);
end

fprintf('Next contrast test %f.\n', questStruct.CsfScale(idx) );

% Return and avoid repetition.
questStruct.contrastTrial=questStruct.CsfScale(idx);

questStruct.trialIdx=questStruct.trialIdx+1;

if ( (questStruct.trialIdx==questStruct.nTrials) || (sd<questStruct.sCrit) )
    questStruct.isComplete=1;
end


end


