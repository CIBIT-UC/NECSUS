%GETNEXTCONSTTRIAL Summary of this function goes here
%   Detailed explanation goes here
function [ constStimStruct ] = getNextConstStimTrial(constStimStruct)

% Idx Increment.
constStimStruct.trialIdx=constStimStruct.trialIdx+1;

% Return and avoid repetition.
constStimStruct.contrastTrial=constStimStruct.stimuliOrder(constStimStruct.trialIdx);

% 
if ( (constStimStruct.trialIdx==constStimStruct.nTrials) )
    constStimStruct.isComplete=1;
end


end

