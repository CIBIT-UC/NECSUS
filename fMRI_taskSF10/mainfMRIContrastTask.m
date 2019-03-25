%% INIT

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
sca;

clear all;
close all;
clc;

% --- addpath to required folders ---
% addpath('Results');
% addpath('Answers');

addpath(genpath('Utils'));
addpath(genpath('Protocols'));

%% PRESETS

% ---- PARTICIPANT data ----

% Create participant variable with psychopsysics and meta data.
ID='sub-NECSUS-UC001';

NT=1;
GT=1;
GNT=1;

PARTICIPANT=setParticipant(ID, NT, GT, GNT);

% ---- CONDITIONS / STIMULI ----

% get the conditions for each participant
[conditions]=setConditions(PARTICIPANT);


% ---- PROTOCOL CREATION ----

% Get fMRI RUN protocol.
[pFilename, pPath]=uigetfile({'*.lospp','LoSpP Protocol (*.lospp)';}...
    ,'Open Protocol',...
    'Protocols/');

% Confirmation of fMRI PROTOCOL file for the EVENT-RELATED experiment
% returns an error.
if ( ~ischar(pPath) || ~ischar(pFilename) )
    errordlg('You must choose a file!','Error','modal');
    return
end

% Path for the file and load the experiment parameters.
locationFile=strcat(pPath,pFilename);
load(locationFile,'-mat','chaos','nrepeats','tr','tr_factor');

% Protocol name.
[~,pName,~]=fileparts(pFilename);

% Create the complete protocol with the subject-specific contrast values.
stimuliPrt=createProtocol(chaos,...
    nrepeats,...
    tr,...
    tr_factor,...
    pName,...
    conditions,...
    Participant);

% Create text box with summary information about the experiment and wait
%   for mouse click to continue the program and enter the experiment
text = [protocolName,...
    'protocolName |',num2str(stimuliPrt.timecourse.total_volumes),...
    ' vols | ',...
    num2str(stimuliPrt.timecourse.total_time),...
    ' secs'];

uiwait(msgbox(text,'ContrastTask','modal'));

%% Run STIMULI 
% run experiment and return 'logdata' with responses
[logdata] = runStim(stimuliPrt.events, stimuliPrt.parameters);

% Asks for saving the data
saveData(Participant, stimuliPrt,logdata, protocolName);



