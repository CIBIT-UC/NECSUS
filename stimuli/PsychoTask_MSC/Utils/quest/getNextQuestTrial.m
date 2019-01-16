function [ contrastTrial ] = getNextQuestTrial( quest )
%GETNEXTQUESTTRIAL Summary of this function goes here
%   Detailed explanation goes here


% Prob function mean and std.
t=QuestMean(quest.q);
sd=QuestSd(quest.q);

fprintf('Value of QUEST mean %f and sd %f.\n',t,sd);

% Get the Gabor contrast
% tTest=QuestQuantile(q);
% tTest=QuestMean(q)		% Recommended by King-Smith et al. (1994)
% tTest=QuestMode(q);		% Recommended by Watson & Pelli (1983)

[~,sortdIdxs]=sort( abs( t-quest.CsfScale ) );
idx=sortdIdxs(1);

if quest.CsfScale(sortdIdxs(1))==quest.last
    idx=sortdIdxs(2);
end

fprintf('Next contrast test %f.\n', quest.CsfScale(idx) );

% Return and avoid repetition.
contrastTrial=quest.CsfScale(idx);


end

