%%% ========= BRAIN VOYAGER SCRIPT ========= %%%
%%% ======== Analysis MultiSubject ========= %%%
%%% ======================================== %%%

%% Configuration
clear, clc;

% Add folders to path
addpath('utils');

% Settings Structure
configs = struct();

% Add data folder
% datafolder = 'L:\DATA_PilotsAutistic_Mac';

% addpath(datafolder);
% configs.dataRoot = fullfile(datafolder);

% Initialize COM
configs.bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');

%% Initalization and Subject Selection
% load('Configs_VP_AdaptationCheck_Final.mat')
load('Configs_VP_Hysteresis_Final.mat')
% load('Configs_Carlos_Phonos.mat')

% Subject Name and Folder Name
subjectname = datasetConfigs.subjects{1};

configs.dataRoot = datasetConfigs.path;

configs.filesSignature = subjectname;
configs.subjectName = subjectname;

configs.dataRootSubject = fullfile(configs.dataRoot, configs.subjectName);
configs.dataRootAnalyses = fullfile(configs.dataRoot, 'ANALYSIS');

%% MDM
vmrFile = dir( fullfile( configs.dataRootSubject,...
    'anatomical','PROJECT', '*TAL.vmr' ) );

configs.vmrPathAndName = fullfile( configs.dataRootSubject,...
    'anatomical', 'PROJECT', vmrFile.name );

configs.pathVTC = fullfile(configs.dataRootAnalyses, 'VTC-data');
configs.pathMDM = fullfile(configs.dataRootAnalyses, 'MDM-data');
configs.pathGLM = fullfile(configs.dataRootAnalyses, 'GLM-data');

if exist(configs.pathMDM,'dir') ~= 7
    mkdir(configs.pathMDM);
end
if exist(configs.pathGLM,'dir') ~= 7
    mkdir(configs.pathGLM);
end

% % Open .vmr Project
vmrTalProject = configs.bvqx.OpenDocument( configs.vmrPathAndName );

vmrTalProject.ClearMultiStudyGLMDefinition;

% % Select .sdm file to process
[fileNameSDM, pathNameSDM] = uigetfile( ...
    {'*.sdm','sdm data files (*.sdm)'}, ...
    'Please select the appropriate design matrix files', configs.dataRootAnalyses, 'MultiSelect', 'on');
sdmFiles = [pathNameSDM fileNameSDM];

% create the multi-study design matrix
[fileNameVTC, pathNameVTC] = uigetfile( ...
    {'*.vtc','vtc data files (*.vtc)'}, ...
    'Please select the appropriate VTC files', configs.dataRootAnalyses, 'MultiSelect', 'on');
vtcFiles = [pathNameVTC fileNameVTC];

prefix_MDM = fliplr(strtok(fliplr(pathNameVTC),'\'));

switch fileNameSDM{1}(end-7:end)
    case '3DMC_SPK.sdm'
        prefix_SDM = '_3DMC_SPK';
    otherwise
        prefix_SDM = '';
end

for i = 1:size(fileNameSDM, 2)
    vmrTalProject.AddStudyAndDesignMatrix( [ pathNameVTC fileNameVTC{i} ],...
        [ pathNameSDM fileNameSDM{i} ] );
end

VTCsmoothed = strcmp(vtcFiles{1,2}(end-5:end-4) , 'mm');

if VTCsmoothed %If VTC are Smoothed
    prefix_VTC = '_Smoothed';
else
    prefix_VTC = '';
end

vmrTalProject.ZTransformStudies = 0;
vmrTalProject.PSCTransformStudies = 1;
vmrTalProject.CorrectForSerialCorrelations = 1;

vmrTalProject.SaveMultiStudyGLMDefinitionFile(fullfile(configs.pathMDM, [prefix_MDM prefix_VTC prefix_SDM '.mdm']));
vmrTalProject.LoadMultiStudyGLMDefinitionFile(fullfile(configs.pathMDM, [prefix_MDM prefix_VTC prefix_SDM '.mdm']));

% GLM
% vmrTalProject.ComputeMultiStudyGLM;
% vmrTalProject.SaveGLM(fullfile(configs.pathGLM, [prefix_MDM prefix_VTC prefix_SDM '.glm']));

% RFX GLM
% vmrTalProject.SeparationOfSubjectPredictors = 1;
% vmrTalProject.ComputeRFXGLM;
% vmrTalProject.SaveGLM(fullfile(configs.pathGLM, [prefix_MDM prefix_VTC prefix_SDM '_RFX' '.glm']));

%% Completed
configs.bvqx.delete;
disp('Group Analysis Completed.')