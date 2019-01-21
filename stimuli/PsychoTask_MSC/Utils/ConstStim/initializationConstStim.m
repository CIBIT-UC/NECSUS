% initializationConstStim  Initializes the constant contrasts method
%   C = initializationConstStim() creates a structure with default values.
%
%   See also PTB, QUEST.
function [constStimStruct] = initializationConstStim()

constStimStruct=struct(); %init struct

constStimStruct.name="ConstantStimuli";

% Create a vector with values of contrast (10? samples).
constStimStruct.min=2;
constStimStruct.max=4;
constStimStruct.step=2;

constStimStruct.repeats=1;

% Create stimuli and shuffle.
constStimStruct.contrasts=constStimStruct.min:constStimStruct.step:constStimStruct.max;
constStimStruct.stimuliOrder = Shuffle(repmat(constStimStruct.contrasts, 1, constStimStruct.repeats));

if numel(constStimStruct.contrasts)~=10
    fprintf('[WARNING:] Number of contrast stimuli is not 10.\n')
end

constStimStruct.initIdx=1; % First contrast Idx.
constStimStruct.lastIdx=constStimStruct.initIdx; % handle for the last Idx showed.

constStimStruct.nTrials=numel(constStimStruct.stimuliOrder);
end