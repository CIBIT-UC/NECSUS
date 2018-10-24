%% retinotopy
datasetConfigs = struct();
datasetConfigs.subjects = {'sub-01', 'sub-02', 'sub-03'};
datasetConfigs.folders = {'anat',...
    'func',...
    'func',...
    'func',...
    };
datasetConfigs.subfolders = {'MPRAGE_p2_1mm_iso_run1',...
    'retinotopia_8bar_Run1',...
    'retinotopia_8bar_Run2',...
    'retinotopia_8bar_Run3',...
    };

for i = 1:numel(datasetConfigs.folders)
    % create path to data
    datasetConfigs.runs{i} = fullfile(datasetConfigs.folders{i}, datasetConfigs.subfolders{i});
end


datasetConfigs.volumes_func_to_skip = 6;
datasetConfigs.volumes_per_run = [176, 180, 180, 180];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {};
datasetConfigs.root_dir = 'C:\Users\Bruno\Desktop\NECSUS\source_code\datastructure\'; %path
datasetConfigs.project_name = 'necsus';

datasetConfigs.AnalysisPath = 'C:\Users\Bruno\Desktop\NECSUS\source_code\datastructure\necsus\ANALYSIS';

% datasetConfigs.shiftROI = true;


save('Configs_NECSUS_ret.mat','datasetConfigs')


%% contrast
datasetConfigs = struct();
datasetConfigs.subjects = {'sub-01', 'sub-02', 'sub-03'};
datasetConfigs.folders = {
    'func',...
    'func',...
    'anat',...
    'func',...
    'func',...
    };
datasetConfigs.subfolders = {  
    'Glare_Run1',...
    'Glare_Run2',...
    'MPRAGE_p2_1mm_iso_run2',...
    'NoGlare_Run1',...
    'NoGlare_Run2',...
    };

for i = 1:numel(datasetConfigs.folders)
    % create path to data
    datasetConfigs.runs{i} = fullfile(datasetConfigs.folders{i}, datasetConfigs.subfolders{i});
end


datasetConfigs.volumes_func_to_skip = 0;
datasetConfigs.volumes_per_run = [177, 177, 176, 177, 177];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {};
datasetConfigs.root_dir = 'C:\Users\Bruno\Desktop\NECSUS\source_code\datastructure\'; %path
datasetConfigs.project_name = 'necsus';

datasetConfigs.AnalysisPath = 'C:\Users\Bruno\Desktop\NECSUS\source_code\datastructure\necsus\ANALYSIS';

% datasetConfigs.shiftROI = true;


save('Configs_NECSUS_ret.mat','datasetConfigs')