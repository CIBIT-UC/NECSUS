%% INIT

% close any open connection or PTB screen
IOPort('Close All');
Screen('Close All');
pnet('closeall');
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
NT=1; % Near Threshold without GLARE.
GT=1; % Threshold with GLARE.
GNT=1; % Near Threshold with GLARE.
PARTICIPANT=setParticipant(ID, NT, GT, GNT);

VIEWINGDISTANCE=156.5; % 40; debug
SPATIALFREQ=10;


% ---- CONDITIONS / STIMULI ----

DEBUG=1;
BACKGROUNDLUM=20;

% get the conditions for each participant
[conditions]=setConditions(PARTICIPANT);

% --- LCD monitor ---
scr=scrInfo(VIEWINGDISTANCE);

% --- GABOR INFORMATION ---
gabor=gaborInfo(SPATIALFREQ);


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

% --- PREPARATION ---

if DEBUG
    % input hack (for debugging)
    stimuliPrt.iomethod=0; % 0-keyboard | 1-lumina response
    % Turn on (1) or off (0) synchrony with scanner console
    stimuliPrt.syncbox=0;
else
    stimuliPrt.iomethod=1;
    stimuliPrt.syncbox=1;
end

% Keyboard "normalization" of Escape key.
KbName('UnifyKeyNames');
stimuliPrt.escapekey = KbName('Escape');
% BackgroundLum definiton of variable - bg color.
stimuli.backgroundLum=BACKGROUNDLUM;


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
[logdata] = runStim(stimuliPrt);

%% Save data
% Asks for saving the data
saveData(Participant, stimuliPrt,logdata, protocolName);



