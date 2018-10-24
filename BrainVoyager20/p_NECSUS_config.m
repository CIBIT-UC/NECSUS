%% BRAINVOYAGER creation of the config file
% Script that created the configuration variable
% Requires -

% Version 1.0
% - Overall restructure

% Author: Bruno Direito (2018)

%% configuration and presets
datasetConfigs = struct();

% participant ID
datasetConfigs.subjects = {
    'sub-01', 'sub-02', 'sub-03'
    };

% anat or func (according to BIDS structure)
datasetConfigs.folders = {  
    'anat','func','func',...
    'func','func','func',...
    'anat','func','func'
    };

% run description (and folder name)
datasetConfigs.subfolders = {
    'MPRAGE_p2_1mm_iso_run1',...
    'retinotopia_8bar_Run1',...
    'retinotopia_8bar_Run2',...
    'retinotopia_8bar_Run3',...
    'Glare_Run1',...
    'Glare_Run2',...
    'MPRAGE_p2_1mm_iso_run2',...
    'NoGlare_Run1',...
    'NoGlare_Run2',...
    };

% ------------ TODO ------------------
% datasetConfigs.prtPrefix = {'DanielaNF_nBackTask315v1back','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v'};

% complete path to run
for i = 1:numel(datasetConfigs.folders)
    % create path to data
    datasetConfigs.runs{i} = fullfile(datasetConfigs.folders{i}, datasetConfigs.subfolders{i});
end

%% MRI data specifications per run
% volumes per run
datasetConfigs.volumes = [176, 180, 180, 180, 177, 177, 176, 177, 177];
% fMRI repetition time
datasetConfigs.TR = 2000;

%% processed data destination folders
datasetConfigs.path = 'C:\Users\Bruno\Desktop\NECSUS\source_code\datastructure\';
datasetConfigs.project_name = 'necsus';
datasetConfigs.analysis_path = 'ANALYSIS';

%% save config file
save('Configs_NECSUS.mat','datasetConfigs')

clear i datasetConfigs