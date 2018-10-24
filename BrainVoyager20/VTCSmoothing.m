%% Configuration
clear, clc;

% Add folders to path
addpath('utils');

% Settings Structure
configs = struct();

% Add data folder
load('Configs_VP_AdaptationCheck_Final.mat')
% load('Configs_VP_Hysteresis_Final.mat')

configs.dataRoot = datasetConfigs.path;

% Initialize COM
configs.bvqx = actxserver('BrainVoyagerQX.BrainVoyagerQXScriptAccess.1');
  
%% Spatial smoothing of VTC files

configs.dataRootAnalysis = fullfile(configs.dataRoot, 'ANALYSIS');

% Load .vmr
[FileName,PathName] = uigetfile('*.vmr', 'Please select the VMR file ', configs.dataRoot);
vmr = configs.bvqx.OpenDocument([PathName FileName]);

% select vtc
[fileNameVTC, pathNameVTC] = uigetfile( ...
    {'*.vtc','vtc data files (*.vtc)'}, ...
    'Please select the appropriate VTC files', configs.dataRootAnalysis, 'MultiSelect', 'on');

for i = 1:size(fileNameVTC, 2)
    
    vmr.LinkVTC ( [ pathNameVTC fileNameVTC{i} ] );
    
    % now smooth VTC with a kernel of 6 mm:
    vmr.SpatialGaussianSmoothing(6, 'mm' ); % FWHM value and unit (’mm’ or ’vx’)
    disp(['Name of spatially smoothed VTC file: ' vmr.FileNameOfCurrentVTC]);
    
end

%% Completed
configs.bvqx.delete;