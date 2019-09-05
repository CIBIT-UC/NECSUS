%% BRAINVOYAGER creation of the config file
% Script that created the configuration variable
% Requires -

% Version 1.0
% - Overall restructure

%% configuration and presets
datasetConfigs = struct();

% Participant ID.
datasetConfigs.subjects = {
    'sub-NECSUS-UC001', 'sub-NECSUS-UC002', 'sub-NECSUS-UC003',...
    'sub-NECSUS-UC004'
    };

% Session ID.
datasetConfigs.sessions = {
    'ses-01', 'ses-02'
    };

% Anat or func (according to BIDS structure).
datasetConfigs.dataTypes = {
    'anat','func'
    };

% Run description (and folder name).
datasetConfigs.task = {
    'T1w',...
    'retinotopia-8bar',...
    'glare',...
    'noglare',...
    };

% Volumes per run.
datasetConfigs.volumes=[176, 180, 177, 177];

% Total number of runs.
datasetConfigs.nRuns=9;

% fMRI repetition time
datasetConfigs.TR = 2000;

datasetConfigs.volsToSkip=6;

%% processed data destination folders
datasetConfigs.path = 'C:\Users\bdireito\Data\';
datasetConfigs.project_name = 'NECSUS';
datasetConfigs.analysis_path = 'ANALYSIS';


%% save config file
save('Configs_NECSUS.mat','datasetConfigs')

clear i datasetConfigs