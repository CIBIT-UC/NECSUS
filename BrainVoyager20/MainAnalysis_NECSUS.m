%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------BRAINVOYAGER fMRI DATA ANALYSIS---------------------%
%-------------------------------Version 3.2-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ______________________________________________________________________
% |                                                                      |%
% | Authors: Bruno Direito, Alexandre Sayal (2017)                       |%
% |                                                                      |%
% |            !!!!! Remember to install COM Functionality !!!!!         |%
% |            !!!!! Remember to install NeuroElf          !!!!!         |%
% |______________________________________________________________________|%
%
% Version 3.2
% - createFolderStrcture compares the given subject name with the first DCM
% file header
% Version 3.1
% - Allow BBR coregistration
% Version 3.0
% - Optimisation for BrainVoyager 20.6
% - Automatically find the first anatomical file
% - Allow for MNI transformation
% - Perform automatic Coregistration
% - Conditional file paths optimisation
% Version 2.3
% - createFolderStructure allows for files in .dcm instead of .ima
% - sliceVector now allows for different number of slices in different
% functional runs (motion correction will fail later)
% Version 2.2
% - createFolderStructure now investigates the existence of two anatomical
% runs and two localiser runs. Also does not proceed if too many files are
% found
% - the six motion-related confounds are now normalised between -1 and 1
% Version 2.1.3
% - Add feature: different run sequence between subjects of the same
% experiment
% Version 2.1.2
% - Add Constant predictor to SDM (necessary for scripting VOI-GLM)
% Version 2.1.1
% - Debugged alignRun index calculation
% Version 2.1
% - Improved detSliceOrder function to account for all types
% - Now possible to perform TAL and Native analysis
% Version 2.0
% - Overall restructure

%% Clear Command Window / Clear Workspace / Close / Add Paths
clear , clc , close all;

addpath functions utils

%% ============================= Settings ============================== %%

% load('Configs_VP_AdaptationCheck_Final.mat')
% load('Configs_VP_Hysteresis_Final.mat')
% load('Configs_VP_Hysteresis_MNI.mat')
% load('Configs_Carlos_Phonos.mat')
% load('Configs_Carlos_PhD.mat')
% load('Configs_BioMotion.mat')

load('Configs_NECSUS_ret.mat')

%% ============================= Settings ============================== %%
subjectName = 'sub-01';  % Subject name
performIIHC = 0;              % Automatic IIHC
performATAL = 0;              % Automatic TAL Transformation
performAMNI = 0;              % Automatic MNI Transformation
performMTAL = 1;              % Manual TAL Transformation
motionParameters = 1;         % Include motion parameters in SDM
spikeThreshold = 0.25;        % Spike Threshold
alignRun = '';      % Run to align motion correction
performBBR = 1;               % Use BBR coregistration
%=========================================================================%

subjectIndex = find(not(cellfun('isempty', strfind(datasetConfigs.subjects, subjectName))));

if isempty(subjectIndex)
    error('Invalid Subject Name')
end

datasetConfigs.raw_dicom_path = 'C:\Users\Bruno\Desktop\NECSUS\data\Raw\ALZIRAQUATORZE';
datasetConfigs.subject_code = subjectName;

% % % --- Select Run Sequence
% % datasetConfigs.runs = datasetConfigs.runs{subjectIndex};
% % datasetConfigs.volumes = datasetConfigs.volumes{subjectIndex};
% % datasetConfigs.prtPrefix = datasetConfigs.prtPrefix{subjectIndex};

%% -- Create Folder Structure
[ success ] =  createDICOM_folder_struct( datasetConfigs );

assert(success,'Folder creation aborted.');
clear dataPath dataTBV;

%% -- Initialize

configs = struct(); % Settings Structure

configs.dataRoot = fullfile ( datasetConfigs.root_dir, datasetConfigs.project_name );
addpath(configs.dataRoot);

% Initialize COM
configs.bvqx = actxserver('BrainVoyager.BrainVoyagerScriptAccess.1');

% Subject Name and Folder Name
configs.filesSignature = datasetConfigs.subjects{subjectIndex};
configs.subjectName = datasetConfigs.subjects{subjectIndex};

configs.dataRootSubject = fullfile(configs.dataRoot, configs.subjectName);

configs.firstFunctRunIdx = [];
configs.firstFunctRunName = [];

configs.IIHC = performIIHC;
configs.ATAL = performATAL;
configs.AMNI = performAMNI;
configs.MTAL = performMTAL;
configs.alignRun = alignRun;
configs.BBR = performBBR;

configs.vol_to_skip =  datasetConfigs.volumes_func_to_skip;

% Account for user error
if configs.ATAL && configs.MTAL
    configs.ATAL = false;
end
if configs.AMNI && ~configs.IIHC
    configs.IIHC = true;
end
if configs.AMNI && (configs.ATAL || configs.MTAL)
    configs.ATAL = false;
    configs.MTAL = false;
end

functFiles = [];
clear performIIHC performATAL performAMNI performMTAL

%% -- Anatomical Project Creation

% -----
% Check for multiple anatomical runs
% -----

vmr_num = 1;

configs.anatRun = [];


% Iterate through all runs in config.
for run_idx = 1:numel(datasetConfigs.runs)   
    
    % Check if run is anatomical
    if datasetConfigs.folders{run_idx} == 'anat'       
        configs.anatRun = run_idx; 
        configs.anatRunIdx = run_idx; 
        configs.anatRunName = datasetConfigs.runs{run_idx};   
    end
end

% % if numel( configs.anat_runs ) > 1 
% %    fprint ("-- too many anat runs. Please check selection. \n") 
% %     
% % end


%%
% Iterate through all runs in config.
for run_idx = 1:numel(configs.anatRun)
    
    % anat runs: anat_runs(run_idx)
    
    % Check for .IMA files
    anatFiles = dir( fullfile( configs.dataRoot, ...
        configs.subjectName, ...
        datasetConfigs.runs{configs.anatRun}, ...
        'DATA', ...
        '*.IMA' ) );
    
    % If previously renamed do nothing
    if ~isempty(anatFiles)
        renameDirectoryDcm( fullfile( configs.dataRoot, ...
            configs.subjectName, ...
            datasetConfigs.runs{configs.anatRun(run_idx)}, ...
            'DATA', ...
            anatFiles(1).name ) );
    end
    
    % Create VMR project
    kInputBool = false;
    while ~kInputBool
        configs.vmrProject = createVmrProject( configs, datasetConfigs.runs{configs.anatRun(run_idx)}, vmr_num );
        
        vmr_num = vmr_num + 1;
        
        if configs.ATAL
            disp('---> Check automatic TAL Transformation!')
            
            kInput = input('---> Continue (Y), Repeat (N) or Perform Manually (M)?', 's');
            switch lower(kInput)
                case 'y'
                    kInputBool = true;
                case 'm'
                    kInputBool = true;
                    disp('---> Press Enter when done.');
                    pause;
                    configs.ATAL = false;
                    configs.MTAL = true;
                otherwise
                    disp('---> Repeating...')
            end
        elseif configs.MTAL
            kInputBool = true;
            disp('---> Perform Manual Talairach Transformation.');
            disp('---> Press Enter when done.');
            pause;
        else % Native | IIHC | MNI transformations
            kInputBool = true;
        end
    end
    
    configs.anatRun = datasetConfigs.runs{configs.anatRun(run_idx)};
    
end

%% -- Functional Project Preparation

% -----
% Check for multiple functional runs
% -----

functionalRuns = datasetConfigs.subfolders(find(strcmp (datasetConfigs.folders,'func')))';

 
% % functionalRuns = ( dir ( fullfile( configs.dataRootSubject, 'func' ) ) );
% % idx_f = [functionalRuns(:).isdir]; %# returns logical vector
% % functionalRuns = {functionalRuns(idx_f).name}';
% % functionalRuns(ismember(functionalRuns,{'.','..'})) = [];

numFunctionalRuns = length( functionalRuns );



%% -- Functional Project Creation
sliceVector = cell(numFunctionalRuns);

for f = 1 : numFunctionalRuns
    
 
    % Rename DICOM
    functFiles = dir( fullfile( configs.dataRoot, ...
        configs.subjectName, ...
        'func', ...
        functionalRuns{f}, ...
        'DATA', ...
        '*.IMA' ) );
    
    if ~isempty(functFiles) % If previously renamed do nothing
        
        renameDirectoryDcm( fullfile( configs.dataRoot, ...
            configs.subjectName, ...
            'func', ...
            functionalRuns{f}, ...
            'DATA', ...
            functFiles(1).name ) );
        
    end
    
    % Create .fmr project and link .prt
    [~ , sliceVector{f}] = createFmrProject( configs, fullfile('func', functionalRuns{f}) );
    
end

save(fullfile(configs.dataRoot,configs.subjectName,'sliceVector.mat'),'sliceVector');

disp ('Project Creation Finished Successfully.')

%% -- Preprocessing Functional Data

% -- Manually set align run
if ~exist('sliceVector','var')
    load(fullfile(configs.dataRoot,configs.subjectName,'sliceVector.mat'));
end

%%

% Identify alignment run - If none, please select.
if numel(configs.alignRun) ~= 1
    fprintf('No alignment run selected. Please select the first functional run. \n');
    AlignRunName = uigetdir(fullfile( configs.dataRoot, ...
            configs.subjectName, ...
            'func'));
end

[~, configs.alignRun] = fileparts(AlignRunName);

%%
configs.firstFunctRunIdx = find( strcmp(  functionalRuns , configs.alignRun )) ;
AlignRunsIdx = configs.firstFunctRunIdx;

configs.firstFunctRunName = functionalRuns{ configs.firstFunctRunIdx };

[~ , sliceTypePath] = preprocessFirstFmrProject( configs, ...
    functionalRuns{configs.firstFunctRunIdx} , ...
    sliceVector{configs.firstFunctRunIdx} );

save(fullfile(configs.dataRoot,configs.subjectName,'sliceTypePath.mat'),'sliceTypePath');

   
%% Rest of the runs
for f = 1 : numFunctionalRuns

    if ~(AlignRunsIdx == f)  
        preprocessFmrProject( configs, functionalRuns{f} , sliceVector{f} );
    end
end

disp ('Preprocessing Finished Successfully.')

%% -- Coregistration and VTC file Preparation

if ~exist('sliceTypePath','var')
    load(fullfile(configs.dataRoot,configs.subjectName,'sliceTypePath.mat'));
end

%% -- Coregistration and VTC file

[ configs , vmrProject ] = parametersVTCCreation( configs , datasetConfigs , sliceTypePath );

%%

for f = 1 : numFunctionalRuns
    
    vtcConfigs = parametersVTCRun( configs , functionalRuns , f , sliceTypePath );
    
    % Create vtc
    createVtcProject( configs, vtcConfigs, vmrProject, functionalRuns{f} )
    
end

disp('VTC files created successfully.')

%% -- SDM and GLM
if configs.ATAL || configs.MTAL
    stringvmr = 'TAL';
elseif configs.AMNI
    stringvmr = 'MNI';
else
    stringvmr = '';
end

vmrFile = dir( fullfile( configs.dataRootSubject,datasetConfigs.runs{configs.anatRunIdx}, 'PROJECT', ['*' stringvmr '.vmr'] ) );

configs.vmrPathAndName = fullfile( vmrFile.folder, vmrFile.name );

vmrProject = configs.bvqx.OpenDocument( configs.vmrPathAndName );

for f = 1 : numFunctionalRuns
    selected_run_name = functionalRuns{f};
    selected_run_name = strrep(selected_run_name,'_','-');
    
    
    if configs.ATAL || configs.MTAL
        stringvtc = '_TAL';
    elseif configs.AMNI
        stringvtc = '_MNI'; 
    else
        stringvtc = '_NATIVE';
    end
    
    success = vmrProject.LinkVTC( fullfile(configs.dataRootSubject,...
        'func', functionalRuns{f} ,'PROJECT','ANALYSIS',...
        [subjectName '_' selected_run_name '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c' stringvtc '.vtc']));
    
    SdmGlmFolder = fullfile(configs.dataRootSubject,...
        'func', functionalRuns{f} ,'PROJECT','ANALYSIS');
    
    n_vols = vmrProject.NrOfVolumes;
    
    vmrProject.ClearDesignMatrix;
    
    % Link stimulation protocol
    

    if exist(vmrProject.StimulationProtocolFile)
        prtFile = xff(vmrProject.StimulationProtocolFile);
    else
        fprintf('No .prt file found. Please select the corresponding prt file - %s . \n', functionalRuns{f});
        [prtFilePath, prtFolder] = uigetfile('*.prt',['Protocol for run' functionalRuns{f}],fullfile( configs.dataRoot));
        
        vmrProject.LinkStimulationProtocol(fullfile(prtFolder, prtFilePath)); % only filename, not pathname
        
        prtFile = xff (fullfile(prtFolder, prtFilePath));
    end
    
    
    configs.conditions = prtFile.ConditionNames;
    prtFile.ClearObject;
    
    for p = 1:length(configs.conditions)
        
        conditionName = configs.conditions{p};
        if conditionName (end) == ' '
            conditionName (end) = [];
        end
        
        %         if ~strcmpi(conditionName,'baseline') % Exclude rest condition
        
        vmrProject.AddPredictor(conditionName);
        
        vmrProject.SetPredictorValuesFromCondition(...
            conditionName,...
            conditionName,...
            1.0);
        
        vmrProject.ApplyHemodynamicResponseFunctionToPredictor(conditionName);
        %             vmrProject.ScalePredictorValues(conditionName,1.0,false);
        %         end
    end
    
    vmrProject.SDMContainsConstantPredictor = true;
    
    % Add motion parameters and spikes as confounds
    if motionParameters
        
        vmrProject.FirstConfoundPredictorOfSDM = p + 1;
        
        motionSDMpath = fullfile(configs.dataRootSubject, 'func', functionalRuns{f},'PROJECT','PROCESSING');
        motionSDMname = dir(fullfile(motionSDMpath,'*3DMC.sdm'));
        
        motionSDM = xff(fullfile(motionSDMpath,motionSDMname.name));
        
        % Detrend and z-normalize motion parameters
        detrendNormMotion = zscore(detrend(motionSDM.SDMMatrix));
        
        for i=1:6
            
            aux_detrendNormMotion = normalize_var(detrendNormMotion(:,i),-1,1); % Normalise between -1 and 1
            
            vmrProject.AddPredictor([motionSDM.PredictorNames{i} ' Detrended']);
            
            for j = 1:n_vols
                vmrProject.SetPredictorValues([motionSDM.PredictorNames{i} ' Detrended'],j,j,aux_detrendNormMotion(j));
            end
            
            %             vmrProject.ScalePredictorValues([motionSDM.PredictorNames{i} ' Detrended'],1.0,false);
            
        end
        
        [ spikeIndexes ] = spikeDetection( motionSDM , spikeThreshold );
        
        for i = 1:length(spikeIndexes)
            
            vmrProject.AddPredictor(['Spike ' num2str(spikeIndexes(i))]);
            
            for j = 1:n_vols
                if j == spikeIndexes(i)
                    value = 1;
                else
                    value = 0;
                end
                vmrProject.SetPredictorValues(['Spike ' num2str(spikeIndexes(i))],j,j,value);
            end
            
        end
        
        % -- Add Constant Predictor
        vmrProject.AddPredictor('Constant');
        vmrProject.SetPredictorValues('Constant', 1, vmrProject.NrOfVolumes, 1.0);
        
        % Save SDM
        sdmPathName = fullfile( SdmGlmFolder,[ configs.filesSignature '_3DMC_SPK.sdm' ] );
        vmrProject.SaveSingleStudyGLMDesignMatrix( sdmPathName );
        
        disp('SDM created (with motion parameters and spikes as confounds).');
        
    else
        vmrProject.FirstConfoundPredictorOfSDM = p + 1;
        
        % -- Add Constant Predictor
        vmrProject.AddPredictor('Constant');
        vmrProject.SetPredictorValues('Constant', 1, vmrProject.NrOfVolumes, 1.0);
        
        % Save SDM
        sdmPathName = fullfile( SdmGlmFolder,[ configs.filesSignature '.sdm' ] );
        vmrProject.SaveSingleStudyGLMDesignMatrix( sdmPathName );
        
        disp('SDM created.');
    end
    
    if ~exist(fullfile(datasetConfigs.AnalysisPath,'SDM-data',functionalRuns{f}),'dir')
        mkdir(fullfile(datasetConfigs.AnalysisPath,'SDM-data',functionalRuns{f}))
    end
    
    copyfile(sdmPathName, fullfile(datasetConfigs.AnalysisPath,'SDM-data',...
        functionalRuns{f} ) );
    
    vmrProject.CorrectForSerialCorrelations = true;
    vmrProject.ComputeSingleStudyGLM;
    
    if motionParameters
        stringM = '_3DMC_SPK';
    else
        stringM = '';
    end
    
    vmrProject.SaveGLM( fullfile( SdmGlmFolder,[ configs.filesSignature stringM stringvtc '.glm']) );
    
    disp('GLM created.');
    
end

disp('SDM and GLM creation successful.')

%% -- Close COM
configs.bvqx.delete;

disp('fMRI Data Processing Script Ended!')
