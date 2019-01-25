% initializationConstStim  Initializes the constant contrasts method
%   C = initializationConstStim() creates a structure with default values.
%
%   See also PTB, QUEST.
function [constStimStruct] = initializationConstStim()

constStimStruct=struct(); % Init struct.

constStimStruct.name="ConstantStimuli";

% Create a vector with values of contrast (10? samples).
constStimStruct.min=1;
constStimStruct.max=10;
constStimStruct.step=1;

constStimStruct.repeats=1;

% Create stimuli and shuffle.
constStimStruct.contrasts=constStimStruct.min:constStimStruct.step:constStimStruct.max;
constStimStruct.stimuliOrder = Shuffle(repmat(constStimStruct.contrasts, 1, constStimStruct.repeats));

if numel(constStimStruct.contrasts)~=10
    fprintf('[WARNING:] Number of contrast stimuli is not 10.\n')
end

constStimStruct.trialIdx=1; % First contrast Idx.
constStimStruct.init=constStimStruct.stimuliOrder(constStimStruct.trialIdx);
constStimStruct.lastIdx=constStimStruct.trialIdx; % handle for the last Idx showed.
constStimStruct.last=constStimStruct.init;

% --- Stopping criteria ----
% stopping handle.
constStimStruct.isComplete=0;
% Stopping criteria (total number of trials tried).
constStimStruct.nTrials=numel(constStimStruct.stimuliOrder);

end